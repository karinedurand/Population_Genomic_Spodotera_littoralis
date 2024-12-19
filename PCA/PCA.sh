#!/bin/bash
#SBATCH dgimi-eha
#SBATCH --output PCA.out


cd /lustre/durandk/PCA/

/nfs/work/faw_adaptation/programs/plink1.9/plink  --double-id  --vcf /storage/simple/projects/faw_adaptation/Merged_vcf/slitto_2023_newref/slittonewref_2023_outgroup.SNP.filtered.recode.vcf.gz   --allow-extra-chr   --pca --out PCA_outgroup_litura

