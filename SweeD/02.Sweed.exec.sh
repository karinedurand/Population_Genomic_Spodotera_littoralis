#!/bin/bash
#SBATCH -p dgimi-eha  
#SBATCH -c 3         

# Navigate to the directory where the SweeD analysis will be run
cd /lustre/durandk/PCA/SWEED

# Run the SweeD analysis
# -name: Sets the base name for the output files
# -input: Specifies the input VCF file
# -grid: Sets the number of grid points for the analysis
# -threads: Specifies the number of threads to use (matches the number of CPU cores requested)
 /storage/simple/projects/faw_adaptation/programs/sweed-master/SweeD-P -name EGT.2024 -input EGT.SweeD.vcf -grid 1000 -threads 3
