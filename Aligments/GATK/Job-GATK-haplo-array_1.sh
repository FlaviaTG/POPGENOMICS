#!/bin/bash
#SBATCH -p unrestricted
#SBATCH -n 10
#SBATCH -N 1
#SBATCH --mem 40000
#SBATCH -t 5-24:00
#SBATCH -J GATK-hapcall-ACGGTC-interval
#SBATCH -o GATK-hapcall-ACGGTC-interval_%A_%a.err
#SBATCH -e GATK-hapcall-ACGGTC-interval_%A_%a.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent


module load samtools/1.5-fasrc02
module load jdk/10.0.1-fasrc01

LIST=/path/to/interval_"${SLURM_ARRAY_TASK_ID}".list
GATKPATH=/path/to/programs/gatk-4.1.4.0/gatk-package-4.1.4.0-local.jar
REFPATH=/path/to/referencegenome.fasta

#example for one individual sample.

java -Xmx40g -XX:ParallelGCThreads=10 -jar $GATKPATH HaplotypeCaller -R $REFPATH -L $LIST -I sample.ACGGTC.aln.sam.sort.bam.dedup.bam -O ${SLURM_ARRAY_TASK_ID}.sample.ACGGTC.raw.g.vcf -ERC GVCF -OVI true
