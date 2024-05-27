#!/bin/bash
#SBATCH --partition=dgimi-eha

cd /lustre/durandk/slitto_newref/VariantCalling/


/nfs/work/faw_adaptation/programs/adapterremoval-2.1.7/build/AdapterRemoval --identify-adapters --file1 /lustre/namk/littoralis/ngs/$1".pair1.truncated.gz" --file2 /lustre/namk/littoralis/ngs/$1".pair2.truncated.gz" >> /lustre/durandk/slitto_newref/VariantCalling/"log"$1

