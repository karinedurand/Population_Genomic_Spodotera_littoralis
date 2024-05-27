#!/bin/bash
#SBATCH --partition=dgimi-eha
#SBATCH --mem=100G

#Load modules

cd /lustre/durandk/slitto_newref/VariantCalling/Admixture/sNMF
 

/storage/simple/projects/faw_adaptation/programs/sNMF_CL_v1.2/bin/ped2geno slittonewref_2023.SNP.annotated.sNMF.ped slittonewref_2023.SNP.annotated.sNMF.geno



