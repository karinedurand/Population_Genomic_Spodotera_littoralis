#!/bin/bash
#SBATCH --partition=dgimi-eha

module load cv-standard

cd /lustre/durandk/slitto_newref/VariantCalling/diversity

 
/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --gzvcf /lustre/durandk/slitto_newref/VariantCalling/VCF/slittonewref_2023.SNP.filtered.recode.vcf.gz --window-pi 500000 --out SA_pi --keep SA.pop
 
/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --gzvcf /lustre/durandk/slitto_newref/VariantCalling/VCF/slittonewref_2023.SNP.filtered.recode.vcf.gz --window-pi 500000 --out ML_pi --keep ML.pop

/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --gzvcf /lustre/durandk/slitto_newref/VariantCalling/VCF/slittonewref_2023.SNP.filtered.recode.vcf.gz --window-pi 500000 --out EGT_pi --keep EGT.pop

