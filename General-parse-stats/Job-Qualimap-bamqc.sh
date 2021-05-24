#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -N 1
#SBATCH -c 32
#SBATCH	--ntasks-per-node=1
#SBATCH --mem 128000
#SBATCH -t 6-00:00
#SBATCH -J qualmap
#SBATCH -o qualmap_%j.out
#SBATCH -e qualmap_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load Java/1.8.0_201
QUAL=/path/to/programs/qualimap_v2.2.1/qualimap
JAVA_MEM_DEFAULT_SIZE="128000M"
module load intel/19.0.5-fasrc01
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
unset DISPLAY

#in a loop run qualimap for each map file

for i in $(ls *.alnCHR.sam.sort.bam.dedup.remove.bam.OUT.SEX.CHR.bam); do $QUAL bamqc -bam $i -nr 100 -nt 32 --java-mem-size=128G; done

#after this you can generate a multi-bamqc plots
