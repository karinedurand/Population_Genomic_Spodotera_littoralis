# ============================================================================
# FST + Dxy : Manhattan plots alignés et détection d'outliers
# FST  : colonnes CHROM, BIN_START, BIN_END, N_VARIANTS, WEIGHTED_FST
# Dxy  : colonnes chrom, window_start, window_end, (sites/SNP), Dxy
# ============================================================================

library(ggplot2)
library(dplyr)
library(gtools)
library(readr)
library(patchwork)

setwd("/home/karine/Documents/Obsidian_Vault/Spodo/GenFAW_122025/FST_DXY_Windows/")

# --- Paramètres globaux -----------------------------------------------------
CHROM_KEEP  <- as.character(1:28)   # chromosomes à garder
MIN_SNP_FST <- 10                   # fenêtres FST avec trop peu de SNP = bruit
MIN_SNP_DXY <- 10                   # idem pour Dxy (mettre NA si pas de colonne)
QUANT       <- 0.99                 # seuil outlier (0.99 = top 1 %)
MIN_RUN     <- 2                    # nb mini de fenêtres outlier contiguës
COLS        <- c("darkslateblue", "cadetblue")

# ============================================================================
# FONCTIONS UTILITAIRES
# ============================================================================

# Nettoyage commun : renomme la colonne chromosome en `chr`, la position de
# début en `start`, filtre les chromosomes, trie, ordonne le facteur.
prepare_windows <- function(df, chr_col, start_col, end_col, value_col,
                            nsnp_col = NULL, min_snp = NA) {
  
  df <- df %>%
    rename(chr = all_of(chr_col),
           start = all_of(start_col),
           end   = all_of(end_col),
           value = all_of(value_col))
  
  if (!is.null(nsnp_col) && nsnp_col %in% names(df)) {
    df <- df %>% rename(nsnp = all_of(nsnp_col))
  } else {
    df$nsnp <- NA_integer_
  }
  
  df <- df %>%
    mutate(chr = gsub("^HiC_scaffold_", "", as.character(chr))) %>%
    filter(chr %in% CHROM_KEEP) %>%
    filter(!is.na(value))
  
  # filtre densité de SNP (n'agit que si la colonne existe)
  if (!is.na(min_snp) && any(!is.na(df$nsnp))) {
    df <- df %>% filter(is.na(nsnp) | nsnp >= min_snp)
  }
  
  df %>%
    mutate(chr = factor(chr, levels = mixedsort(unique(chr)))) %>%
    arrange(chr, start)
}

# Offsets cumulés calculés sur l'UNION des deux jeux de données :
# garantit que la position x est identique entre le panneau FST et le Dxy.
make_offsets <- function(fst_df, dxy_df) {
  bind_rows(
    fst_df %>% select(chr, end),
    dxy_df %>% select(chr, end)
  ) %>%
    group_by(chr) %>%
    summarise(len = max(end, na.rm = TRUE), .groups = "drop") %>%
    arrange(chr) %>%
    mutate(offset = cumsum(as.numeric(len)) - as.numeric(len))
}

add_cum_pos <- function(df, offsets) {
  df %>%
    left_join(offsets %>% select(chr, offset), by = "chr") %>%
    mutate(pos_cum = start + offset)
}

axis_centers <- function(df) {
  df %>%
    group_by(chr) %>%
    summarise(center = (min(pos_cum) + max(pos_cum)) / 2, .groups = "drop")
}

# Outliers : au-dessus du quantile ET dans un bloc d'au moins MIN_RUN fenêtres
# contiguës. Renvoie les fenêtres retenues + un identifiant de région.
find_outliers <- function(df, thr, min_run = MIN_RUN) {
  df %>%
    mutate(is_out = value > thr) %>%
    group_by(chr) %>%
    mutate(run_id = cumsum(!is_out)) %>%
    ungroup() %>%
    filter(is_out) %>%
    group_by(chr, run_id) %>%
    filter(n() >= min_run) %>%
    mutate(region = paste0(chr, "_", min(start), "-", max(end))) %>%
    ungroup() %>%
    select(-is_out, -run_id)
}

manhattan_plot <- function(df, centers, thr, ylab, hide_x = FALSE) {
  p <- ggplot(df, aes(x = pos_cum, y = value, color = chr)) +
    geom_point(size = 0.3) +
    scale_color_manual(values = rep(COLS, length.out = nlevels(df$chr))) +
    scale_x_continuous(breaks = centers$center, labels = centers$chr,
                       expand = expansion(mult = 0.01)) +
    geom_hline(yintercept = thr, linetype = "dashed",
               color = "red", linewidth = 0.5) +
    theme_bw() +
    theme(legend.position = "none", panel.grid = element_blank()) +
    labs(x = "Chromosome", y = ylab)
  
  if (hide_x) {
    p <- p + theme(axis.text.x = element_blank(),
                   axis.title.x = element_blank(),
                   axis.ticks.x = element_blank())
  }
  p
}

# ============================================================================
# PIPELINE COMPLET POUR UNE PAIRE DE POPULATIONS
# ============================================================================
analyse_pair <- function(pair_name, fst_file, dxy_file,
                         dxy_value_col = "Dxy",
                         dxy_nsnp_col  = "SNP") {
  
  message("=== ", pair_name, " ===")
  
  # --- Lecture --------------------------------------------------------------
  fst_raw <- read_delim(fst_file, delim = "\t", col_names = TRUE,
                        show_col_types = FALSE, trim_ws = TRUE)
  dxy_raw <- read_delim(dxy_file, delim = "\t", col_names = TRUE,
                        show_col_types = FALSE, trim_ws = TRUE)
  
  # --- Préparation (noms de colonnes différents entre FST et Dxy) -----------
  fst <- prepare_windows(fst_raw,
                         chr_col   = "CHROM",
                         start_col = "BIN_START",
                         end_col   = "BIN_END",
                         value_col = "WEIGHTED_FST",
                         nsnp_col  = "N_VARIANTS",
                         min_snp   = MIN_SNP_FST) %>%
    mutate(value = pmax(value, 0))          # FST négatifs -> 0
  
  dxy <- prepare_windows(dxy_raw,
                         chr_col   = "chrom",
                         start_col = "window_start",
                         end_col   = "window_end",
                         value_col = dxy_value_col,
                         nsnp_col  = dxy_nsnp_col,
                         min_snp   = MIN_SNP_DXY)
  
  # --- Positions cumulées communes -----------------------------------------
  offsets <- make_offsets(fst, dxy)
  fst <- add_cum_pos(fst, offsets)
  dxy <- add_cum_pos(dxy, offsets)
  
  centers <- axis_centers(bind_rows(fst %>% select(chr, pos_cum),
                                    dxy %>% select(chr, pos_cum)))
  xrange  <- range(c(fst$pos_cum, dxy$pos_cum))
  
  # --- Seuils et outliers ---------------------------------------------------
  thr_fst <- quantile(fst$value, probs = QUANT, na.rm = TRUE)
  thr_dxy <- quantile(dxy$value, probs = QUANT, na.rm = TRUE)
  
  out_fst <- find_outliers(fst, thr_fst)
  out_dxy <- find_outliers(dxy, thr_dxy)
  
  message(sprintf("  FST : seuil = %.4f | %d fenêtres outlier (%d régions)",
                  thr_fst, nrow(out_fst), n_distinct(out_fst$region)))
  message(sprintf("  Dxy : seuil = %.5f | %d fenêtres outlier (%d régions)",
                  thr_dxy, nrow(out_dxy), n_distinct(out_dxy$region)))
  
  # --- Intersection FST x Dxy (chevauchement génomique) ---------------------
  shared <- out_fst %>%
    select(chr, fst_start = start, fst_end = end, FST = value,
           fst_region = region) %>%
    inner_join(
      out_dxy %>% select(chr, dxy_start = start, dxy_end = end,
                         Dxy = value, dxy_region = region),
      by = "chr", relationship = "many-to-many"
    ) %>%
    filter(fst_start < dxy_end, dxy_start < fst_end)   # chevauchement
  
  message(sprintf("  Intersection FST x Dxy : %d fenêtres partagées",
                  nrow(shared)))
  
  # --- Écriture des tables --------------------------------------------------
  q_tag <- sub("0\\.", "", as.character(QUANT))
  write_csv(out_fst, paste0(pair_name, "_outliers_FST_", q_tag, ".csv"))
  write_csv(out_dxy, paste0(pair_name, "_outliers_DXY_", q_tag, ".csv"))
  write_csv(shared,  paste0(pair_name, "_outliers_SHARED_", q_tag, ".csv"))
  
  # --- Graphiques -----------------------------------------------------------
  pFST <- manhattan_plot(fst, centers, thr_fst, "Weighted FST", hide_x = TRUE) +
    coord_cartesian(xlim = xrange)
  pDXY <- manhattan_plot(dxy, centers, thr_dxy, "Dxy", hide_x = FALSE) +
    coord_cartesian(xlim = xrange)
  
  ggsave(paste0("Plot_FST_", pair_name, ".pdf"), pFST, width = 15, height = 4)
  ggsave(paste0("Plot_DXY_", pair_name, ".pdf"), pDXY, width = 15, height = 4)
  
  combined <- (pFST / pDXY) +
    plot_layout(guides = "collect", axes = "collect_x") +
    plot_annotation(title = paste("FST vs Dxy -", pair_name)) &
    theme(axis.title.x = element_text(size = 10),
          plot.margin  = unit(c(0.2, 0.5, 0.2, 0.5), "cm"))
  
  ggsave(paste0("Combined_FST_DXY_", pair_name, ".pdf"), combined,
         width = 15, height = 8)
  
  invisible(list(fst = fst, dxy = dxy,
                 thr_fst = thr_fst, thr_dxy = thr_dxy,
                 out_fst = out_fst, out_dxy = out_dxy, shared = shared,
                 pFST = pFST, pDXY = pDXY, combined = combined))
}

# ============================================================================
# EXÉCUTION
# ============================================================================

res_Inv_west108_vs_Sen1 <- analyse_pair(
  pair_name = "Sen1_vs_Inv_west108",
  fst_file  = "Sen1_vs_Inv_west108.windowed.weir.fst",
  dxy_file  = "Inv-west108_Sen1.csv"
)

res_Nat_C_vs_Nat_R <- analyse_pair(
  pair_name = "Nat_C_vs_Nat_R",
  fst_file  = "Nat_C_vs_Nat_R.windowed.weir.fst",
  dxy_file  = "Nat-C_Nat-R.csv"
)
res_Inv_east_vs_Inv_west_sen1 <- analyse_pair(
  pair_name = "Inv-east_Inv-west-sen1",
  fst_file  = "Inv_east_vs_Inv_westsen.windowed.weir.fst",
  dxy_file  = "Inv-east_Inv-west-sen1.csv"
)

res_Inv_west_sen1_vs_Nat_C <- analyse_pair(
  pair_name = "Inv-west-sen1_Nat-C",
  fst_file  = "Inv-west-sen1_vs_Nat-c.windowed.weir.fst",
  dxy_file  = "Inv-west-sen1_Nat-c.csv"
)



# Affichage interactif
write.csv(res_Inv_west108_vs_Sen1$shared, "common_Sen1_vs_Inv_west108.csv", row.names = FALSE)
write.csv(res_Nat_C_vs_Nat_R$shared,      "common_Nat_C_vs_Nat_R.csv",      row.names = FALSE)

print(res_Nat_C_vs_Nat_R$combined)

# Régions candidates (FST élevé ET Dxy élevé)
head(res_Nat_C_vs_Nat_R$shared, 100)
