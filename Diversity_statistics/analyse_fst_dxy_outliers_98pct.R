library(readr)
library(ggplot2)
library(dplyr)
library(tidyr) # Nécessaire pour la fonction separate()

# Configuration du répertoire de base
base_dir <- "/home/karine/Documents/Obsidian_Vault/Spodo/GenFAW_122025/FST_DXY_Windows/"
setwd(base_dir)

################################################################################
# --- SECTION FST ---
################################################################################

# 1. Inv_east_inv_west
Inv_east_Inv_west_fst <- read_delim("FST_Inv_east_Inv_west.results.tsv", delim = "\t", col_names = FALSE, show_col_types = FALSE)
names(Inv_east_Inv_west_fst) <- c("CHROM", "WEIGHTED_FST")

Inv_east_Inv_west_fst <- Inv_east_Inv_west_fst %>%
  separate(CHROM, into = c("CHROM", "START", "END"), sep = "_", convert = TRUE) 
#####################################################verification des donnees brutes :
  # Charger la librairie
  library(dplyr)

# 1. Pour le dataframe Fst
# On groupe par CHROM et on calcule la moyenne de WEIGHTED_FST
df_fst_mean <- Inv_east_Inv_west_fst  %>%
  group_by(CHROM) %>%
  summarise(
    mean_fst = mean(WEIGHTED_FST, na.rm = TRUE),
    n_windows = n()
  )
# Affichage des résultats
print("Moyennes Fst par chromosome :")
print(df_fst_mean)




seuil_outlier_Inv_east_Inv_west_fst <- quantile(Inv_east_Inv_west_fst$WEIGHTED_FST, 0.98, na.rm = TRUE)

pdf("distrib_Inv_east_Inv_west.pdf", width = 8, height = 6) 
ggplot(Inv_east_Inv_west_fst, aes(x = WEIGHTED_FST)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white", alpha = 0.8) +
  geom_vline(xintercept = seuil_outlier_Inv_east_Inv_west_fst, color = "firebrick", linewidth = 1.1, linetype = "dashed") +
  annotate("text", x = seuil_outlier_Inv_east_Inv_west_fst, y = Inf, 
           label = paste("Threshold 98% =", round(seuil_outlier_Inv_east_Inv_west_fst, 4)),
           vjust = 2, hjust = -0.1, color = "firebrick") +
  theme_minimal()
dev.off()

write.csv(subset(Inv_east_Inv_west_fst, WEIGHTED_FST > seuil_outlier_Inv_east_Inv_west_fst), "treshold_Inv_east_Inv_west98.csv", row.names = FALSE)


# 2. Zam_Inv_east
Zam_Inv_east <- read_delim("FST_Inv_east_Zam.results.tsv", delim = "\t", col_names = FALSE, show_col_types = FALSE)
names(Zam_Inv_east) <- c("CHROM", "WEIGHTED_FST")

Zam_Inv_east <- Zam_Inv_east %>%
  separate(CHROM, into = c("CHROM", "START", "END"), sep = "_", convert = TRUE) 

df_fst_mean <- Zam_Inv_east  %>%
  group_by(CHROM) %>%
  summarise(
    mean_fst = mean(WEIGHTED_FST, na.rm = TRUE),
    n_windows = n()
  )
# Affichage des résultats
print("Moyennes Fst par chromosome :")
print(df_fst_mean)
seuil_outlier_Zam_Inv_east <- quantile(Zam_Inv_east$WEIGHTED_FST, 0.98, na.rm = TRUE)

pdf("distrib_Zam_Inv_east.pdf", width = 8, height = 6)
ggplot(Zam_Inv_east, aes(x = WEIGHTED_FST)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white", alpha = 0.8) +
  geom_vline(xintercept = seuil_outlier_Zam_Inv_east, color = "firebrick", linewidth = 1.1, linetype = "dashed") +
  annotate("text", x = seuil_outlier_Zam_Inv_east, y = Inf, 
           label = paste("Threshold 98% =", round(seuil_outlier_Zam_Inv_east, 4)),
           vjust = 2, hjust = -0.1, color = "firebrick") +
  theme_minimal()
dev.off()

write.csv(subset(Zam_Inv_east, WEIGHTED_FST > seuil_outlier_Zam_Inv_east), "treshold_Zam_Inv_east98.csv", row.names = FALSE)


# 3. Zam_Inv_west
Zam_Inv_west <- read_delim("FST_Inv_west_Zam.results.tsv", delim = "\t", col_names = FALSE, show_col_types = FALSE)
names(Zam_Inv_west) <- c("CHROM", "WEIGHTED_FST")

Zam_Inv_west <- Zam_Inv_west %>%
  separate(CHROM, into = c("CHROM", "START", "END"), sep = "_", convert = TRUE)

df_fst_mean <- Zam_Inv_west   %>%
  group_by(
    CHROM) %>%
  summarise(
    mean_fst = mean(WEIGHTED_FST, na.rm = TRUE),
    n_windows = n()
  )
# Affichage des résultats
print("Moyennes Fst par chromosome :")
print(df_fst_mean)

seuil_outlier_Zam_Inv_west <- quantile(Zam_Inv_west$WEIGHTED_FST, 0.98, na.rm = TRUE)

pdf("distrib_Zam_Inv_west.pdf", width = 8, height = 6)
ggplot(Zam_Inv_west, aes(x = WEIGHTED_FST)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white", alpha = 0.8) +
  geom_vline(xintercept = seuil_outlier_Zam_Inv_west, color = "firebrick", linewidth = 1.1, linetype = "dashed") +
  annotate("text", x = seuil_outlier_Zam_Inv_west, y = Inf, 
           label = paste("Threshold 98% =", round(seuil_outlier_Zam_Inv_west, 4)),
           vjust = 2, hjust = -0.1, color = "firebrick") +
  theme_minimal()
dev.off()

write.csv(subset(Zam_Inv_west, WEIGHTED_FST > seuil_outlier_Zam_Inv_west), "treshold_Zam_Inv_west98.csv", row.names = FALSE)


################################################################################
# --- SECTION DXY ---
################################################################################

# 4. DXY Inv_east_inv_west
# Note : j'utilise le chemin relatif pour éviter de multiplier les setwd()
Inv_east_Inv_west_dxy <- read_delim("all_dxy_inv_east_inv_west.tsv", delim = "\t", col_names = TRUE, show_col_types = FALSE)
# names(Inv_east_Inv_west_dxy) <- c("chrom", "window_start", "window_end","SNP","dxy" )
library(dplyr)

# Supposons que ton dataframe s'appelle df_dxy
df_windowed <- Inv_east_Inv_west_dxy %>%
  group_by(chrom, window_start, window_end) %>%
  summarize(
    # On fait la moyenne des Dxy pour la fenêtre
    mean_Dxy = mean(Dxy, na.rm = TRUE), 
    # On garde le compte des SNPs pour info
    total_snps = sum(N_SNP)
  ) %>%
  filter(!is.na(mean_Dxy)) # On enlève les fenêtres sans données

##################################################verification des donnees brutes 
# 2. Pour le dataframe Dxy
# Attention : les colonnes sont ici 'chrom' et 'Dxy'
df_dxy_mean <- Inv_east_Inv_west_dxy %>%
  group_by(chrom) %>%
  summarise(
    mean_dxy = mean(Dxy, na.rm = TRUE),
    n_windows = n()
  )

print("Moyennes Dxy par chromosome :")
print(df_dxy_mean)

seuil_outlier_dxy <- quantile(Inv_east_Inv_west_dxy$Dxy, 0.98, na.rm = TRUE)

pdf("distrib_DXY_Inv_east_Inv_west.pdf", width = 8, height = 6)
ggplot(Inv_east_Inv_west_dxy, aes(x = Dxy)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white", alpha = 0.8) +
  geom_vline(xintercept = seuil_outlier_dxy, color = "firebrick", linewidth = 1.1, linetype = "dashed") +
  annotate("text", x = seuil_outlier_dxy, y = Inf, 
           label = paste("Threshold 98% =", seuil_outlier_dxy),
           vjust = 2, hjust = -0.1, color = "firebrick") +
  theme_minimal()
dev.off()

write.csv(subset(Inv_east_Inv_west_dxy, Dxy > seuil_outlier_dxy), "treshold_DXY_Inv_east_Inv_west98.csv", row.names = FALSE)


# 5. DXY Zam_Inv_east
Zam_Inv_east_dxy <- read_delim("all_dxy_rinv_east_zam.tsv", delim = "\t", show_col_types = FALSE)
Zam_Inv_east_dxy <- Zam_Inv_east_dxy %>% filter(chrom < 29)
df_dxy_mean <- Zam_Inv_east_dxy %>%
  group_by(chrom) %>%
  summarise(
    mean_dxy = mean(Dxy, na.rm = TRUE),
    n_windows = n()
  )

print("Moyennes Dxy par chromosome :")
print(df_dxy_mean)

seuil_outlier_Zam_Inv_east_dxy <- quantile(Zam_Inv_east_dxy$Dxy, 0.98, na.rm = TRUE)

pdf("distrib_DXY_Zam_Inv_east.pdf", width = 8, height = 6) 
ggplot(Zam_Inv_east_dxy, aes(x = Dxy)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white", alpha = 0.8) + 
  geom_vline(xintercept = seuil_outlier_Zam_Inv_east_dxy, # Corrigé : nom de variable cohérent
             color = "firebrick", linewidth = 1.1, linetype = "dashed") +
  annotate("text", x = seuil_outlier_Zam_Inv_east_dxy, y = Inf, 
           label = paste("Threshold 98% =", round(seuil_outlier_Zam_Inv_east_dxy, 4)),
           vjust = 2, hjust = -0.1, color = "firebrick", fontface = "bold") +
  theme_minimal()
dev.off()

write.csv(subset(Zam_Inv_east_dxy, Dxy > seuil_outlier_Zam_Inv_east_dxy), "treshold_DXY_Zam_Inv_east98.csv", row.names = FALSE)


# 6. DXY Zam_Inv_west
Zam_Inv_west_dxy <- read_delim("all_dxy_inv_west_zam.tsv", delim = "\t", show_col_types = FALSE)
#Zam_Inv_west_dxy <- Zam_Inv_west_dxy %>% filter(chrom < 29)
seuil_outlier_Zam_west_dxy <- quantile(Zam_Inv_west_dxy$Dxy, 0.98, na.rm = TRUE)

pdf("distrib_DXY_Zam_Inv_west.pdf", width = 8, height = 6) 
ggplot(Zam_Inv_west_dxy, aes(x = Dxy)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white", alpha = 0.8) + 
  geom_vline(xintercept = seuil_outlier_Zam_west_dxy, 
             color = "firebrick", linewidth = 1.1, linetype = "dashed") +
  annotate("text", x = seuil_outlier_Zam_west_dxy, y = Inf, 
           label = paste("Threshold 98% =", round(seuil_outlier_Zam_west_dxy, 4)),
           vjust = 2, hjust = -0.1, color = "firebrick", fontface = "bold") +
  theme_minimal()
dev.off()

write.csv(subset(Zam_Inv_west_dxy, Dxy > seuil_outlier_Zam_west_dxy), "treshold_DXY_Zam_Inv_west98.csv", row.names = FALSE)

