#!/bin/bash
#SBATCH dgimi-eha
#SBATCH --output PCA.out


cd /lustre/durandk/PCA/

/storage/simple/projects/faw_adaptation/programs/plink1.9/plink --bfile /storage/simple/projects/faw_adaptation/Merged_vcf/slitto_2023_newref/slittonewref_2023.SNP.filtered.recode.vcf.gz --pca 10 --out slittonewref_2023.SNP.PCA  

