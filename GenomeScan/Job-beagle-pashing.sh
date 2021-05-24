#!/bin/bash
#SBATCH -p serial_requeue
#SBATCH -n 20
#SBATCH -N 1
#SBATCH --mem 190000
#SBATCH -t 5-00:00
#SBATCH -J B_phasing
#SBATCH -o B_phasing_%j.err
#SBATCH -e B_phasing_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ftermignoni@fas.harvard.edu # Email to which notifications will be sent

module load jdk/1.8.0_172-fasrc01

BPATH=/path/to/programs/beagle.18May20.d20.jar


java -Djava.io.tmpdir=/path/to/tempdir -Xmx180000m -jar $BPATH gt=genolike1-myspecies.vcf out=genolike1-myspecies-PHASED.vcf.gz nthreads=20
