#!/bin/bash
#SBATCH --partition=dgimi-eha
#SBATCH --nodes 1
#SBATCH -c 10


module load cv-standard
module load jre

cd /lustre/durandk/slitto_newref/VariantCalling/VCF

/nfs/work/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --gzvcf     slittonewref_2023.SNP.annotated.sNMF.vcf.recode.vcf.gz   --out /lustre/durandk/slitto_newref/VariantCalling/Admixture/sNMF/slittonewref_2023.SNP.annotated.sNMF --plink
