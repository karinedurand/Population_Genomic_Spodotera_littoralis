This repository contains scripts for performing an analysis pipeline from VCF (Variant Call Format) files to sNMF (Sparse Non-Negative Matrix Factorization) clustering and visualization.

## Overview
The pipeline includes the following steps:

1. **Preparing and Filtering the VCF**: Script `01.make_input_vcf2sNMF.sh` filters and prepares the VCF file for further processing.
2. **Converting VCF to BED**: Script `02.vcf2bed.sh` converts the VCF file into a BED format.
3. **Converting BED to GENO**: Script `03.sNMFpedtogeno.sh` transforms the BED format into a GENO format compatible with sNMF.
4. **Running sNMF**: Script `04.sNMF.sh` performs the sNMF analysis.
5. **Plotting the Results**: The R script `Plot_sNMF.R` generates a figure based on the sNMF results.
