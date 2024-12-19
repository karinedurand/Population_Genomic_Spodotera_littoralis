#!/bin/bash
#SBATCH -p workq
#SBATCH 

#Load modules
module load bioinfo/tabix-0.2.5
module load bioinfo/vcftools-0.1.15
module load bioinfo/treemix-1.13


cd /work/kdurand/dgimi/sfrugi_hybrid/treemix

for i in {0..6}
do
 treemix -i Invasive_117.noN.thin100.treemix.frq.gz -o Invasive_117.$i   -m $i
done

#for i in {0..6}
#do
# treemix -i Invasive_117.noN.thin100.treemix.frq.gz -o Outgrouped.$i -root litura -k 500 -m $i
#done
