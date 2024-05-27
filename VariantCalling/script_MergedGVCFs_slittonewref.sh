#!/bin/bash
#SBATCH --partition=dgimi-eha
#SBATCH --nodes 1
#SBATCH -c 10


module load cv-standard
module load jre
cd /lustre/durandk/slitto_newref/VariantCalling/VCF
#remove cd and merged
/nfs/work/faw_adaptation/programs/gatk-4.1.2.0/gatk CombineGVCFs -R /storage/simple/projects/faw_adaptation/ref/slitto/GCA_902850265.1_PGI_Spodlit_v1_genomic.fasta     -O slittonewref_2023.g.vcf.gz --variant   KNAM_0001.g.vcf.gz --variant KNAM_0002.g.vcf.gz --variant KNAM_0003.g.vcf.gz --variant KNAM_0005.g.vcf.gz --variant KNAM_0010.g.vcf.gz --variant KNAM_0012.g.vcf.gz --variant KNAM_0014.g.vcf.gz --variant KNAM_0015.g.vcf.gz --variant KNAM_0020.g.vcf.gz --variant KNAM_0021.g.vcf.gz --variant ML10.g.vcf.gz --variant ML11.g.vcf.gz --variant ML13.g.vcf.gz --variant ML2.g.vcf.gz --variant ML3.g.vcf.gz --variant ML4.g.vcf.gz --variant ML5.g.vcf.gz --variant ML7.g.vcf.gz --variant ML8.g.vcf.gz --variant ML9.g.vcf.gz --variant KNAM_0049.g.vcf.gz --variant KNAM_0050.g.vcf.gz --variant KNAM_0051.g.vcf.gz --variant KNAM_0052.g.vcf.gz --variant KNAM_0053.g.vcf.gz --variant KNAM_0054.g.vcf.gz --variant KNAM_0055.g.vcf.gz --variant KNAM_0056.g.vcf.gz --variant KNAM_0057.g.vcf.gz --variant KNAM_0059.g.vcf.gz --variant KNAM_0060.g.vcf.gz

 ## Variant calling
/nfs/work/faw_adaptation/programs/gatk-4.1.2.0/gatk GenotypeGVCFs -R /storage/simple/projects/faw_adaptation/ref/slitto/GCA_902850265.1_PGI_Spodlit_v1_genomic.fasta  --variant slittonewref_2023.g.vcf.gz  -O slittonewref_2023.vcf3.gz -all-sites

#cd ../vcf

## Selecting only SNPs
# I propose this  the input is slittonewref_2023.vcf3.gz 

/nfs/work/faw_adaptation/programs/gatk-4.1.2.0/gatk SelectVariants -select-type SNP -R /storage/simple/projects/faw_adaptation/ref/slitto/GCA_902850265.1_PGI_Spodlit_v1_genomic.fasta -V slittonewref_2023.vcf3.gz  -O slittonewref_2023.SNP.vcf3.gz
## Annotating bad SNPs
/nfs/work/faw_adaptation/programs/gatk-4.1.2.0/gatk VariantFiltration -R /storage/simple/projects/faw_adaptation/ref/slitto/GCA_902850265.1_PGI_Spodlit_v1_genomic.fasta  -V slittonewref_2023.SNP.vcf3.gz --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "my_snp_filter" -O slittonewref_2023.SNP.annotated.vcf.gz # Check each SNP is good or not.vcf.gz

## Collecting only good (PASS) SNPs
zcat slittonewref_2023.SNP.annotated.vcf.gz | grep -P '#|PASS' | /nfs/work/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --vcf - --max-missing 0.8 --out slittonewref_2023.SNP.filtered --recode #Perform filtering

#compress the new vcf file
/nfs/work/faw_adaptation/programs/htslib-1.9/bgzip slittonewref_2023.SNP.filtered.recode.vcf
#index the vcf file
/nfs/work/faw_adaptation/programs/htslib-1.9/tabix -p vcf slittonewref_2023.SNP.filtered.recode.vcf.gz


