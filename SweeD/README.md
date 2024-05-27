# Population_Genomic
# **SweeD Analysis**

This guide outlines the steps to perform a SweeD analysis starting from a VCF file. The SweeD analysis helps identify signatures of selection in genomic data. We will use two main scripts: 02.Sweed.prep.sh to prepare the data and 03.Sweed.exec.sh to execute the SweeD analysis.

**Prerequisites**

vcftools
SweeD

**Data Preparation**

1. Processing the VCF File
2. run sbatch 01.Sweed.prep.sh

**Running the SweeD Analysis**

1. Executing the SweeD Script
2. sbatch  02.Sweed.exec.sh
   
**Prepare SweeD report for plotting**

1.perl 03.parseres.pl

**Plot with R**

1.03.SweeD_plotting.R

**Extract ouliers**

1 04.Extract_SweeD_outliers.R

**Find outliers gene in gff**

perl 05.Genefinding.pl



