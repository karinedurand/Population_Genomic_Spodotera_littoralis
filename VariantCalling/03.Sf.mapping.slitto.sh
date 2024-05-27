#!/bin/bash

#SBATCH --partition=dgimi-eha
#SBATCH --mem=5G

cd /lustre/durandk/slitto_newref/VariantCalling



/nfs/work/faw_adaptation/programs/bowtie2-2.3.4.1-linux-x86_64/bowtie2 -x  /storage/simple/projects/faw_adaptation/ref/slitto/GCA_902850265.1_PGI_Spodlit_v1_genomic  -1 /lustre/namk/littoralis/ngs/$1".pair1.truncated.gz" -2 /lustre/namk/littoralis/ngs/$1".pair2.truncated.gz" --very-sensitive-local  | /nfs/work/faw_adaptation/programs/samtools-1.9/samtools view -F 4 -b -h -o /lustre/durandk/slitto_newref/VariantCalling/$1".raw.bam"



/nfs/work/faw_adaptation/programs/samtools-1.9/samtools sort -o $1".sorted.bam" $1".raw.bam"

#rm SAMPLE.raw.bam

module load JDK/jdk.8_x64
java -Xmx4g -Djava.io.tmpdir=temp.SAMPLE -jar  /nfs/work/faw_adaptation/programs/picard.jar MarkDuplicates INPUT=$1".sorted.bam" OUTPUT=$1".dupl_rm.bam" REMOVE_DUPLICATES=true METRICS_FILE=$1".metricN.log" ASSUME_SORTED=True MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000

#rm -rf temp.SAMPLE
#rm SAMPLE.sorted.bam

java -Xmx4g -Djava.io.tmpdir=$1".SAMPLE" -jar /nfs/work/faw_adaptation/programs/picard.jar AddOrReplaceReadGroups INPUT=$1".dupl_rm.bam" OUTPUT=$1".bam" RGID=$1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=$1;

#rm -rf temp.SAMPLE
#rm SAMPLE.dupl_rm.bam

/nfs/work/faw_adaptation/programs/samtools-1.9/samtools index $1".bam"   
/nfs/work/faw_adaptation/programs/samtools-1.9/samtools stats $1".bam" > $1".stats"
