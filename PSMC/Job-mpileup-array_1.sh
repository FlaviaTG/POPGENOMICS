#!/bin/bash
#SBATCH -p edwards
#SBATCH -n 1 #each chromosome will be processed on a single core (-n 1)
#SBATCH -N 1 #on one machine (-N 1)
#SBATCH -t 2-00:00 #most runs should finish in 3-4 hours but we'll a bit extra
#SBATCH --mem 2000 #most runs should be under 1 GB but we'll add a buffer
#SBATCH -o mpileup_ACGGTC_%j.out
#SBATCH -e mpileup_ACGGTC_%j.err
#SBATCH -J mpileup_ACGGTC #a basic name for this job
#SBATCH --array=0-999
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu

source new-modules.sh
module load centos6/0.0.1-fasrc01
module load samtools/1.2-fasrc01
module load bcftools/1.2-fasrc01

#to mpileup with samtools into the reference genome to run each chromosome at the same time anayses such as PSMC, for bam files aligments or fasta files
REFPATH=/path/to/referencegenome.fasta
CHR="scaffold_${SLURM_ARRAY_TASK_ID}"

#runing in a loop to al bam files
for i in *bam; do samtools mpileup -u -v -f $REFPATH -r $CHR $i | bcftools call -c | vcfutils.pl vcf2fq -d 5 -D 34 -Q 30 > ./scaffolds-ALLsamples/$i.PSMC.$CHR.fq;done

#runing on one reference genome,
#samtools mpileup -u -v -f $REFPATH -r $CHR referencegenome.fasta | bcftools call -c | vcfutils.pl vcf2fq -d 5 -D 34 -Q 30 > ./referencegenomes/referencegenome_$CHR.fq
