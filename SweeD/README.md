This repository provides a set of scripts to run a SweeD analysis, which detects selective sweeps in genomic data. The pipeline includes data preparation and  execution of the SweeD analysis

### Steps:

1. **Processing the VCF File**  
   First, prepare the VCF file for analysis.
   sbatch 01.Sweed.prep.sh
2. **Run the SweeD Analysis** 
   Once the data is prepared, run the SweeD analysis using the command:
   sbatch 02.Sweed.exec.sh
3. **Run the SweeD Analysis** 
   Prepare SweeD Report for Plotting
   perl 03.parseres.pl
4. **Run the SweeD Analysis** 
   Plot Results with R
   03.SweeD_plotting.R
5. **Extract Outliers**  
   Extract the outliers from the SweeD results with the command
   04.Extract_SweeD_outliers.R

