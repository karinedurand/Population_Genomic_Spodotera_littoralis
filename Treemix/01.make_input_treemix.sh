#!/bin/bash
#SBATCH -p dgimi-eha
cd /lustre/durandk/slitto_newref/VariantCalling/TreeMix

/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --gzvcf /storage/simple/projects/faw_adaptation/Merged_vcf/slitto_2023_newref/slittonewref_2023_outgroup.SNP.filtered.recode.vcf.gz \
--max-missing 1  --recode --stdout slittonewref_2023_outgroup.SNP.TREEMIX.vcf
