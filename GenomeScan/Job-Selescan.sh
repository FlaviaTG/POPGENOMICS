#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 20
#SBATCH -N 1
#SBATCH --mem 80000
#SBATCH -t 3-00:00
#SBATCH -J selescan
#SBATCH -o selescan_%j.out
#SBATCH -e selescan_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent


SEL=/path/to/programs/selscan
NORM=/path/to/programs/selescan/norm
PLI=/path/to/programs/plink

#run selescan in a loop
for i in $(ls *recode.vcf); do echo $i
       j=`echo $i | sed 's/.recode.vcf/.recode.vcf.map/'`
       $SEL --nsl --maf 0.05 --max-extend 1000000 --max-gap 200000 --cutoff 0.05 --vcf $i --map $j --out $i --threads 20; done

#Example cross poplation
#now yo can do the cross population analysis. All chromosomes in a loop, need one .list file per speices for ech chromosome. The lists need to have the same chromosome order of files. For example species1.list has the chromosomes list of files in the same order as species2.list

#paste species1.list species2.list |
#while read i j
#do $SEL --xpnsl --maf 0.05 --max-extend 1000000 --max-gap 200000 --cutoff 0.05 --vcf $i --vcf-ref $j --out minimus_$i --#threads 20; done
