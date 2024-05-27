#!/bin/bash
#SBATCH -c 4
#SBATCH --mem=40G
#SBATCH --partition=dgimi-eha

module load  jre/jre.8_x64

#/nfs/work/faw_adaptation/programs/samtools-1.9/samtools index /lustre/namk/processing_fq/sfrugi_CAS/bam/$1.bam

/nfs/work/faw_adaptation/programs/gatk-4.1.2.0/gatk HaplotypeCaller -R /storage/simple/projects/faw_adaptation/ref/slitto/GCA_902850265.1_PGI_Spodlit_v1_genomic.fna -I /lustre/durandk/slitto_newref/VariantCalling/bam/$1.bam -O /lustre/durandk/slitto_newref/VariantCalling/VCF/$1".g.vcf.gz" -ERC GVCF



