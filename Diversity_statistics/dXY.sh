#!/bin/bash
#SBATCH -p dgimi-eha
#SBATCH -c 12
#SBATCH --mem=120G

cd /lustre/durandk/slitto_newref/VariantCalling/diversity

# Optional: Uncomment the following lines if you need to compress and index your VCF file

/storage/simple/projects/faw_adaptation/programs/htslib-1.9/bgzip -c /storage/simple/projects/faw_adaptation/Merged_vcf/slitto_2023_newref/slittonewref_2023.SNP.filtered.recode.vcf >/lustre/durandk/slitto_newref/VariantCalling/diversity/slittonewref_2023.SNP.filtered.recode.vcf.gz
#index the vcf file
/storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -p vcf /lustre/durandk/slitto_newref/VariantCalling/diversity/slittonewref_2023.SNP.filtered.recode.vcf.gz


## Loop through chromosomes 1 to 31
for i in {1..31}
do
/storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -h /lustre/durandk/slitto_newref/VariantCalling/diversity/slittonewref_2023.SNP.filtered.recode.vcf.gz  HiC_scaffold_$i | gzip -f > chr$i.vcf.gz
  python3 /lustre/durandk/slitto_newref/VariantCalling/diversity/Dxy-master/Dxy_calculate -v CHROM.$i.vcf -p ML_EGT.txt   -o ML_EGT.$i    -w 500000 -s 50000
  python3 /lustre/durandk/slitto_newref/VariantCalling/diversity/Dxy-master/Dxy_calculate -v CHROM.$i.vcf -p SA_EGT.txt   -o SA_EGT.$i    -w 500000 -s 50000
  python3 /lustre/durandk/slitto_newref/VariantCalling/diversity/Dxy-master/Dxy_calculate -v CHROM.$i.vcf -p MLSA_EGT.txt -o MLSA_EGT.$i  -w 500000 -s 50000
# rm chr$i.vcf.gz
done


