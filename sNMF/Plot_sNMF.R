# Load necessary libraries
library(vcfR)
library(ggplot2)
library(dplyr)
library(tidyr)

# Set working directory
setwd("/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/sNMF")

# Read population data
pops <- read_table("~/Documents/Spodo/PROJET_slitto_2023_newref/sNMF/pop.csv")

# Read cross-validation data
cv.snp <- read_table("cv.txt", col_names = FALSE)

# Plot cross-validation data
f.cv.snp <- ggplot(cv.snp , aes(x = X4, y = X5)) + geom_point() + 
  xlab("K") + ylab("CV") + theme_bw() + expand_limits(y = 0) + ylim(0.2, 0.4)
f.cv.snp

# Save cross-validation plot to PDF
pdf("CV.pdf", width = 5, height = 5)
f.cv.snp
dev.off()

# Read Q matrix for K=2
q_mat <- read_table("slittonewref_2023.SNP.filtered.sNMF.vcf.recode.vcf.sNMF.2.Q",  col_names = FALSE)


# Add column names to Q matrix
colnames(q_mat) <- paste0("P", 1:2)

# Convert Q matrix to data frame
q_df <- q_mat %>% 
  as_tibble() %>% 
  mutate(individual = pops$ID,
         region = pops$pop,
         order = pops$pop_order)

# Reshape data for plotting
q_df_long <- q_df %>% 
  pivot_longer(cols = starts_with("P"), names_to = "pop", values_to = "q") 

# Plot Q matrix for K=2
q_palette <- c("#fde725", "#35b779", "#440154","red")
pdf("K2.pdf", width = 9, height =1)
q_df_long %>% 
  ggplot() +
  geom_col(aes(x = individual, y = q, fill = pop)) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.2, hjust = 1)) +
  scale_fill_manual(values = q_palette, labels = c("Pop1", "Pop2","pop3", "pop4")) +
  labs(fill = "Populations") +
  theme_minimal() +
  theme(panel.spacing.x = unit(0, "lines"),
        axis.line = element_blank(),
        axis.text = element_blank(),
        strip.background = element_rect(fill = "transparent", color = "black"),
        panel.background = element_blank(),
        axis.title = element_blank(),
        panel.grid = element_blank()) +
  guides(fill = FALSE)
dev.off()

# Repeat the process for K=3, K=4, K=5, and K=6 if needed
