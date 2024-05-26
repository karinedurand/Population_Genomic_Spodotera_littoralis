#!/bin/bash
#SBATCH -p dgimi-eha

# This script processes VCF files and prepares them for SweeD analysis.

# Ensure bgzip is used to avoid errors.

# Compress the VCF file using bgzip (this command is commented out because it's assumed to have been done previously)
# /storage/simple/projects/faw_adaptation/programs/htslib-1.9/bgzip -c EGT.noN.CHROM.recode.vcf > EGT.noN.CHROM.recode.vcf.gz

# Index the compressed VCF file
/storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -p vcf EGT.noN.CHROM.recode.vcf.gz

# Set the VCF file variable
vcfF=EGT.noN.CHROM.recode.vcf.gz
tempF=EGT.SweeD.vcf.gz

# Change to the directory where the SWEED analysis will be run
cd /lustre/durandk/PCA/SWEED

# Extract the header from the VCF file
zcat $vcfF | grep '^#' > $tempF

# Process each chromosome
for i in {1..31}
do
  # Set the chromosome name variable
  chrN=CHROM.$i

  # Extract and filter the chromosome-specific data from the VCF file, then prepare it for SweeD analysis
  /storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -h $vcfF $chrN | grep -v '^#' | grep -v '*' | grep -Pv '\t\.:' > ${chrN}.temp.vcf
  /storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --vcf ${chrN}.temp.vcf --recode --stdout | grep -v '^#' >> $tempF

  # Remove the temporary chromosome file
  rm ${chrN}.temp.vcf
done
