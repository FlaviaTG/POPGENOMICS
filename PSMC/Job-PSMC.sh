#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH --mem 20000
#SBATCH -n 5
#SBATCH -N 1
#SBATCH -t 2-00:00
#SBATCH -o psmc_%j.out
#SBATCH -e psmc_%j.err
#SBATCH -J psmc
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu
source new-modules.sh
module load centos6/0.0.1-fasrc01
module load psmc/0.6.5-fasrc01
module load gnuplot/4.6.4-fasrc01

PSMC=/path/to/programs/psmc

#runing PSMC
#step1#
#first make the formated imput per chromosome
#$PSMC/utils/fq2psmcfa P964.consensus.fq > P964.psmcfa

#in a loop for all the chromosomes 
for i in *consensus.fq; do $PSMC/utils/fq2psmcfa $i > $i.psmcfa;done

#step2#
#generate psmc calculations
#for i in *psmcfa; do $PSMC/psmc -p "4+25*2+4+6" -o $i.psmc $i;done

#step3#
#then plot
#for i in *.consensus.fq.psmcfa.psmc; do $PSMC/utils/psmc_plot.pl -R -u 0.25e-8 -g 1 -p $i_plot $i;done

