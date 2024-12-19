This repository provides a set of scripts to run a SweeD analysis, which detects selective sweeps in genomic data. The pipeline includes data preparation and  execution of the SweeD analysis

### Steps:

1. **Processing the VCF File**  
   First, prepare the VCF file for analysis.

2. **Run the SweeD Preparation Script**  
   Execute the preparation script with the following command:  
   ```bash
   sbatch 01.Sweed.prep.sh
