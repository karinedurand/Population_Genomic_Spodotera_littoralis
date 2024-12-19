#!/bin/bash
#SBATCH -p dgimi-eha
#SBATCH 

#Load modules


#/storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix

#vcftools --gzvcf /work/kdurand/dgimi/sfrugi_hybrid/VCF/Invasive_117.vcf.gz --max-missing 1 --thin 100 --recode --stdout | gzip > /work/kdurand/dgimi/sfrugi_hybrid/treemix/Invasive_117.noN.thin100.vcf.gz


/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --gzvcf /storage/simple/projects/faw_adaptation/Merged_vcf/slitto_2023_newref/slittonewref_2023_outgroup.SNP.filtered.recode.vcf.gz --max-missing 1  --recode --stdout | gzip > /lustre/durandk/slitto_newref/VariantCalling/TreeMix/slittonewref_2023_outgroup.SNP.TREEMIX.vcf.gz
