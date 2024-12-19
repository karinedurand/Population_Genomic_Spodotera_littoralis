This repository provides a set of scripts to run a SweeD analysis, which detects selective sweeps in genomic data. The pipeline includes data preparation, execution of the SweeD analysis, and downstream steps to process and visualize the results.

### 1. **Prepare the VCF File**

The first step is to prepare the VCF file for analysis.
sbatch 01.Sweed.prep.sh

### 2. **Run the SweeD Analysis**

Execute the SweeD analysis with the following command:
sbatch 02.Sweed.exec.sh

**Output File:** `SweeD_Report.SA`
- This file contains the results for each chromosome, indicated by identifiers (e.g., `//1`).

**Example Output:**
```
//1
Position    Likelihood    Alpha        StartPos    EndPos
1936.0000   0.000000e+00  1.200000e+03 1936.0000   1979.0000
15964.7852  6.285409e+00  2.415085e-04 1936.0000   65599.0000
29993.5703  0.000000e+00  2.222222e-01 29939.0000  30052.0000
```
###  **Parse the SweeD Results**
Use the `parseres.pl` script to process SweeD_Report.$name and SweeD_Info.$name,   and prepare the output file SweeD_parsed.$name for visualization.
perl parseres.pl 

**Example Output Format:**
```
chrN       pos         likelihood   alpha       startPos    endPos
CHROM.1    1936.0000   0.000000e+00 1.200000e+03 1936.0000   1979.0000
CHROM.1    15964.7852  6.285409e+00 2.415085e-04 1936.0000   65599.0000
CHROM.1    29993.5703  0.000000e+00 2.222222e-01 29939.0000  30052.0000
CHROM.1    44022.3555  3.527988e-02 3.538850e-03 42484.0000  47390.0000
```
### 3. **Plot the SweeD Results**
Visualize the parsed SweeD results using the R script `03.SweeD_plotting.R`.

### 4. **Extract Outliers**
Identify outlier regions from the SweeD results with the script `04.Extract_SweeD_outliers.R`.
```
**Output File:** `result_selected_data_SweeD_SA_0.9995.csv`
- This file contains the outlier regions and will be used as input for the next step.
```
### 6. **Find Genes Associated with Outliers**
Finally, identify the genes corresponding to the outlier regions using the GFF file containing genomic annotations.
perl 05.genefinding.pl

```
**Input Files:**
- GFF file with genomic annotations.
- CSV file with outlier regions (`result_selected_data_SweeD_SA_0.9995.csv`).
```

### **Summary**

This pipeline provides a complete workflow for detecting and analyzing selective sweeps in genomic data. Ensure that all input files (e.g., VCF and GFF) are formatted correctly before starting the analysis. Each script is designed to be executed sequentially, and outputs from earlier steps are used as inputs for subsequent ones.

