#!/bin/bash
#SBATCH --partition=dgimi-eha


cd /lustre/durandk/slitto_newref/VariantCalling/VCF

input_vcf="slittonewref_2023.SNP.annotated.vcf.gz"

filtered_vcf="slittonewref_2023.SNP.annotated.sNMF.vcf"


# Étape 1: Filtrage des données manquantes

/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --gzvcf "$input_vcf" --remove-indels --max-missing 0.2 --recode --recode-INFO-all --out "$filtered_vcf"


mv "$filtered_vcf"  /lustre/durandk/slitto_newref/VariantCalling/Admixture/sNMF


