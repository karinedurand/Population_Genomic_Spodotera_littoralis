#!/bin/bash
#SBATCH -p dgimi-eha
#SBATCH --mem=50G



/storage/simple/projects/faw_adaptation/programs/stacks-2.68/populations -V slittonewref_2023_outgroup.SNP.TREEMIX.vcf.gz  -M 6pop.txt -t 8 --out-path treemix_6pops --treemix
