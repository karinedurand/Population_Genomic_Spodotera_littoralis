#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --cpus-per-task=16


VCF="/storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/2025_GenFAW600/VCF_notpruned/GenFAW_max5miss_biallelic.vcf.gz"
module load bioinfo-ifb
module load  vcftools/0.1.16  
OUTDIR="fst_observed"
mkdir -p $OUTDIR

vcftools  --gzvcf $VCF --weir-fst-pop Nat_C.pop --weir-fst-pop Nat_R.pop \
    --fst-window-size 100000 --fst-window-step 10000 --out $OUTDIR/Nat_C_vs_Nat_R

vcftools  --gzvcf $VCF --weir-fst-pop Inv_east.pop --weir-fst-pop Inv_west.pop \
    --fst-window-size 100000 --fst-window-step 10000 --out $OUTDIR/Inv_east_vs_Inv_west

vcftools  --gzvcf $VCF --weir-fst-pop Nat_C_Nat_R_Mex.pop --weir-fst-pop Nat_C_Nat_R.pop \
    --fst-window-size 100000 --fst-window-step 10000 --out $OUTDIR/NatCNatRMex_vs_NatCNatR

vcftools  --gzvcf $VCF --weir-fst-pop Zam.pop --weir-fst-pop Inv_east_west.pop \
    --fst-window-size 100000 --fst-window-step 10000 --out $OUTDIR/Zam_vs_InvEastWest

vcftools  --gzvcf $VCF --weir-fst-pop Nat_C_Nat_R_Mex.pop --weir-fst-pop Inv_east_west_zam.pop \
    --fst-window-size 100000 --fst-window-step 10000 --out $OUTDIR/NatCNatRMex_vs_InvEastWestZam
