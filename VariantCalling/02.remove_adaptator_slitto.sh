#!/bin/bash
#SBATCH --partition=dgimi-eha
#SBATCH -c 32


cd /lustre/durandk/slitto_newref/VariantCalling/

/nfs/work/faw_adaptation/programs/adapterremoval-2.1.7/build/AdapterRemoval --file1 /lustre/namk/littoralis/ngs/$1".pair1.truncated.gz"  --file2 /lustre/namk/littoralis/ngs/$1".pair2.truncated.gz" --basename /lustre/durandk/slitto_newref/VariantCalling/$1 --trimns --trimqualities --minquality 20 --gzip --gzip-level 9 --threads 32





