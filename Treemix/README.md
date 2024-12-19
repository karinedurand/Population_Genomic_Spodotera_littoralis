This folder contains scripts and input files required to run a Treemix analysis, which is used to infer population splits and migration events from genomic data. Below is an overview of the provided scripts and their respective roles in the analysis.

###***Summary***
Follow the steps in order to complete the Treemix analysis pipeline:
1. Run `01.make_input_treemix.sh` to prepare input data.
2. Use `02.stacks.sh` with the `6pop.txt` file to process population data.
3. Execute `03.treemix.sh` to perform the Treemix analysis.

This pipeline is designed to handle genomic datasets efficiently and provide insights into population history and gene flow.


