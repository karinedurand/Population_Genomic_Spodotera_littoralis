#!/bin/bash
#SBATCH -p dgimi-eha
#SBATCH --mem=50G

#Load modules




#vcftools --gzvcf /work/kdurand/dgimi/sfrugi_hybrid/VCF/Invasive_117.vcf.gz --max-missing 1 --thin 100 --recode --stdout | gzip > Invasive_117.noN.thin100.vcf.gz

populations -V slittonewref_2023_outgroup.SNP.TREEMIX.vcf.gz  -M 6pop.txt -t 8 --out-path treemix_6pops --treemix
