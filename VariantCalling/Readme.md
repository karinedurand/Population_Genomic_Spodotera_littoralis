# Spodoptera littoralis Variant Calling Pipeline


### 01.find_adaptator_slitto.sh
**Purpose**: This script identifies adaptors present in the raw sequencing reads.
**Usage**: 

sbatch 01.find_adaptator_slitto.sh

### 02.remove_adaptator_slitto.sh
**Purpose**: This script removes the adaptors identified in the previous step from the raw sequencing reads.
**Usage**:
sbatch 02.remove_adaptator_slitto.sh

### 03.Sf.mapping.slitto.sh
**Purpose**: This script maps the cleaned reads to the reference genome.
**Usage**:
sbatch 03.Sf.mapping.slitto.sh

###04.gatk.sh
**Purpose**: This script performs variant calling using the GATK toolkit.
**Usage**:
sbacth 04.gatk.sh

### script_MergedGVCFs_slittonewref.sh
**Purpose**: This script merges the variant call files from multiple samples.
**Usage**:
sbacth script_MergedGVCFs_slittonewref.sh
