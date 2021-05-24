#!/bin/bash
#SBATCH -p edwards
#SBATCH -n 10
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 4-00:00
#SBATCH -J GATK-Genotype-interval
#SBATCH -o GATK-Genotype-interval_%A_%a.err
#SBATCH -e GATK-Genotype-interval_%A_%a.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent


module load samtools/1.5-fasrc02
module load jdk/10.0.1-fasrc01

LIST=/path/to/interval_"${SLURM_ARRAY_TASK_ID}".list
GATKPATH=/path/to/programs/gatk-4.1.4.0/gatk-package-4.1.4.0-local.jar
REFPATH=/path/to/referencegenome.fasta

java -Xmx40g -jar $GATKPATH GenotypeGVCFs -L $LIST \
-R $REFPATH \
-V gendb://database_${SLURM_ARRAY_TASK_ID} \
-O all_samples_interval_${SLURM_ARRAY_TASK_ID}.vcf \
--tmp-dir=/tmp
