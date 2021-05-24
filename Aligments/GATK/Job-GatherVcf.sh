#!/bin/bash
#SBATCH -p edwards
#SBATCH -n 20
#SBATCH -N 1
#SBATCH --mem 80000
#SBATCH -t 4-00:00
#SBATCH -J GATK-GatherVCF
#SBATCH -o GATK-GatherVCF_%A_%a.err
#SBATCH -e GATK-GatherVCF_%A_%a.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent


module load samtools/1.5-fasrc02
module load jdk/10.0.1-fasrc01

GATKPATH=/path/to/programs/gatk-4.1.4.0/gatk-package-4.1.4.0-local.jar
REFPATH=/path/to/referencegenome.fasta

java -Xmx80g -XX:ParallelGCThreads=20 -jar $GATKPATH GatherVcfs \
-I all_samples_interval_1.vcf \
-I all_samples_interval_2.vcf \
-I all_samples_interval_3.vcf \
-I all_samples_interval_4.vcf \
-I all_samples_interval_5.vcf \
-I all_samples_interval_6.vcf \
-I all_samples_interval_7.vcf \
-I all_samples_interval_8.vcf \
-I all_samples_interval_9.vcf \
-I all_samples_interval_10.vcf \
-I all_samples_interval_11.vcf \
-I all_samples_interval_12.vcf \
-I all_samples_interval_13.vcf \
-I all_samples_interval_14.vcf \
-I all_samples_interval_15.vcf \
-I all_samples_interval_16.vcf \
-I all_samples_interval_17.vcf \
-I all_samples_interval_18.vcf \
-I all_samples_interval_19.vcf \
-I all_samples_interval_20.vcf \
-I all_samples_interval_21.vcf \
-O all_samples_Catharus_bicknell_combined.vcf
