#!/bin/bash
#SBATCH -p workq
#SBATCH 

#Load modules
module load bioinfo/tabix-0.2.5
module load bioinfo/vcftools-0.1.15
module load bioinfo/treemix-1.13


cd /work/kdurand/dgimi/treemix

for i in {0..6}
do
 treemix -i slittonewref_2023_outgroup.SNP.TREEMIX.treemix.gz -root outgroup -k 500 -o treemix.$i   -m $i
done


