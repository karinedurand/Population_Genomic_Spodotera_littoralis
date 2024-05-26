#!/bin/bash
#SBATCH --partition=dgimi-eha

module load cv-standard

cd /lustre/durandk/slitto_newref/VariantCalling/diversity



 
/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --gzvcf /lustre/durandk/slitto_newref/VariantCalling/VCF/slittonewref_2023.SNP.filtered.recode.vcf.gz --weir-fst-pop SA.pop  --weir-fst-pop EGT.pop --fst-window-size  500000 --fst-window-step  50000  --out SA_EGT  
 
/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --gzvcf /lustre/durandk/slitto_newref/VariantCalling/VCF/slittonewref_2023.SNP.filtered.recode.vcf.gz --weir-fst-pop ML.pop  --weir-fst-pop EGT.pop --fst-window-size  500000 --fst-window-step  50000  --out ML_EGT  

/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --gzvcf /lustre/durandk/slitto_newref/VariantCalling/VCF/slittonewref_2023.SNP.filtered.recode.vcf.gz --weir-fst-pop MLSA.pop  --weir-fst-pop EGT.pop --fst-window-size  500000 --fst-window-step  50000  --out MLSA_EGT  
