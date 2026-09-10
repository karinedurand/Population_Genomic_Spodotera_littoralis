#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --array=1-29
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

cd /home/durandk/scratch_durandk/GenFAW600/FST_DXY_Windows/

# Définir les comparaisons de populations
#Adaptations locales le long du corridor d'expansion africain Inv_east vs Inv_west 
#Loci responsables de l'adaptation à la plante hôte  "Nat_C_Nat_R"
#Loci sous sélection spécifique lors du passage de l'Amérique à l'Afrique Nat_C vs Inv_west
#Identifier les loci responsables de la dérive/différenciation propre au Sénégal : Inv_west vs Sen
POP_PAIRS=(
  "Inv-east_Inv-west-sen1"
  "Nat-C_Nat-R"
  "Inv-west-sen1_Nat-C"
  "Inv-west108_Sen1"
)

# Reconstruction du nom exact du chromosome/scaffold
CHR_ID="HiC_scaffold_${SLURM_ARRAY_TASK_ID}"

VCF_SRC="/storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2026_GenFAW_merged_bam/GenFAW2026.allchr.biallelic_snp.miss05.vcf.gz"
VCF_TMP="${CHR_ID}.vcf.gz"

source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bgzip_tabix

# Extraction du scaffold correspondant
tabix -h "$VCF_SRC" "$CHR_ID" | bgzip -c > "$VCF_TMP"
tabix -p vcf "$VCF_TMP"

conda deactivate

module load bioinfo-cirad
module load anaconda/python3.8

# Calcul du Dxy pour chaque paire de populations
for PAIR in "${POP_PAIRS[@]}"; do
    POP1=${PAIR%%_*}
    POP2=${PAIR##*_}
    OUTNAME="${POP1}_${POP2}_${CHR_ID}.dxy"
    
    python3 Dxy_calculate -v "$VCF_TMP" -p "$PAIR" -o "$OUTNAME" -w 100000 -s 10000
done
