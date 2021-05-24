#!/bin/bash
#SBATCH -p edwards
#SBATCH -n 20
#SBATCH -N 1
#SBATCH --mem 80000
#SBATCH -t 5-24:00
#SBATCH -J GATK-DBImport-interval
#SBATCH -o GATK-DBImport-interval_%A_%a.err
#SBATCH -e GATK-DBImport-interval_%A_%a.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent


module load samtools/1.5-fasrc02
module load jdk/10.0.1-fasrc01


LIST=/path/to/interval_"${SLURM_ARRAY_TASK_ID}".list
GATKPATH=/path/to/programs/gatk-4.1.4.0/gatk-package-4.1.4.0-local.jar


java -Xmx80g -XX:ParallelGCThreads=20 -jar $GATKPATH GenomicsDBImport -L $LIST \
-V ${SLURM_ARRAY_TASK_ID}.sample.ACGGTC.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.AGACCA.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.AGATCC.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.AGCTTT.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.AGGTAC.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.ATCCGC.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.ATGACT.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.ATTGTA.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.ATTTCG.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.CAGCTT.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.CAGTGT.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.CATTTT.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.CCATGT.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.CGATGT.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.CGCTAC.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.CTCACG.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.CTGAAA.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.CTGGCC.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.GACTCA.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.GGAACT.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.GGACGG.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.GTAGGC.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TAATGT.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TATAAT.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TATCAG.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TCATTC.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TCCCGA.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TCCTAG.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TCGAAG.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TGACAT.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TGAGCC.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TGTACG.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TTCGAA.raw.g.vcf \
-V ${SLURM_ARRAY_TASK_ID}.sample.TTGACT.raw.g.vcf \
--genomicsdb-workspace-path Catharus_database_${SLURM_ARRAY_TASK_ID}
