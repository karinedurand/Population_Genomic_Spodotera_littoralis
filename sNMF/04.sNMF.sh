#!/bin/bash
#SBATCH --partition=dgimi-eha
#SBATCH --mem=100G
#SBATCH -c 8
#Load modules

cd /lustre/durandk/slitto_newref/VariantCalling/Admixture/sNMF
 
for i in {1..6}
do
  sNMF -x slittonewref_2023.SNP.annotated.sNMF.geno -K "$i" -c -p 8
done
