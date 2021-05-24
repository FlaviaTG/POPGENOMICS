#!/bin/bash
#SBATCH -p edwards
#SBATCH -n 20
#SBATCH -N 1
#SBATCH --mem 80000
#SBATCH -t 40-00:00
#SBATCH -J SNAPP40
#SBATCH -o SNAPP40%j.err
#SBATCH -e SNAPP40%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load jdk/1.8.0_172-fasrc01


BS=/path/to/programs/beast/bin/beast
 
#to run SNAPP via beast
#for this you need to prepare the input file .xml on BEAUTI specifiyng that the format is for SNAPP
$BS -overwrite -threads 20 genolike1-myspecies-SNAPP.xml
