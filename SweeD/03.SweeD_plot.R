# Load necessary libraries
library(ggplot2)  # Library for creating plots
library(dplyr)     # Library for data manipulation

# Read the SweeD_parsed.EGT file
v2 <- read.table('/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results/2024/SweeD_parsed.EGT', header = TRUE)

# Create a vector of chromosomes sorted numerically
chromosomes_order <- sort(unique(as.numeric(gsub("CHROM\\.", "", v2$chrN))))

# Order the dataframe v2 based on the chromosome order
v2 <- v2[order(match(as.numeric(gsub("CHROM\\.", "", v2$chrN)), chromosomes_order)), ]

# Add an index column
v2$i <- c(1:nrow(v2))

# Aggregate minimum and maximum indices per chromosome
vg.1 <- aggregate(v2$i, by = list(v2$chrN), min)
vg.2 <- aggregate(v2$i, by = list(v2$chrN), max)
vg <- merge(vg.1, vg.2, by = "Group.1")

# Calculate the center of each chromosome interval
vg$center <- with(vg, (x.x + x.y) / 2)

# Rename the first column of vg
colnames(vg)[1] <- 'chro'

# Remove the "CHROM." prefix from chrN values
v2$chrN <- gsub("CHROM\\.", "", v2$chrN)
vg$chro <- gsub("CHROM\\.", "", vg$chro)
vg$chro[vg$chro == '31'] <- 'Z'

# Create the ggplot graph
pEGT <- ggplot(v2, aes(x = i, y = likelihood, color = chrN)) +
  geom_point(size = 1) +
  scale_color_manual(values = rep(c("darkslateblue", "cadetblue"), nrow(v2))) +
  xlab('Chromosome') +
  ylab('Composite Likelihood') +
  theme_bw() +
  scale_x_continuous(labels = as.character(vg$chro), breaks = vg$center) +
  theme(
    axis.title = element_text(size = 12),
    plot.title = element_text(size = 23),
    strip.text.y = element_text(size = 20)
  ) +
  guides(color = FALSE)

# Display the plot
pEGT

# Save the graph as a PDF
pdf(output2, width = 15, height = 4)
pEGT
dev.off()

