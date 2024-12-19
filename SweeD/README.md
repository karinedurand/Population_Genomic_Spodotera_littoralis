This repository provides a set of scripts to run a SweeD analysis, which detects selective sweeps in genomic data. The pipeline includes data preparation and  execution of the SweeD analysis

### Steps:

1. **Processing the VCF File**  
   First, prepare the VCF file for analysis.
   sbatch 01.Sweed.prep.sh
2. **Run the SweeD Analysis** 
   Once the data is prepared, run the SweeD analysis using the command
   sbatch 02.Sweed.exec.sh
3. **Plot the SweeD results** 
   Plot Results with R
   03.SweeD_plotting.R
4. **Extract Outliers**  
   Extract the outliers from the SweeD results with the command
   04.Extract_SweeD_outliers.R
5. **Find Outliers in Genes Using GFF**
   Finally, identify the genes associated with the outliers using:
   perl 05.genefinding.pl

