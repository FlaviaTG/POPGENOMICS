ADM=/path/to/program/admixture
PLI=/path/to/program/plink
#use another version of plink that supoort more than ~50000 contigs
PLI2=/n/holylfs/LABS/edwards_lab/ftermignoni/programs/plink2/plink
module load vcftools/0.1.14-fasrc01
module load GCC/7.3.0-2.30 OpenMPI/3.1.1 BCFtools/1.9
#first thin sampling SNP 10kb with vcftools
vcftools --vcf genolike1.vcf --thin 10000 --recode --recode-INFO-all --out genolike1
#add chr or scaffold at the begining of the markers if you dont have it
sed -E 's/^([0-9])/scaffold_\1/g' genolike1.vcf > newNAME-genolike1.vcf
#run the programs plink to make your .bed file to use it for ADMIXTURE
$PLI2 --vcf newNAME-genolike1.vcf --geno 0.9 --recode --no-fid --no-parents --no-sex --no-pheno --out newNAME-genolike1 --noweb --make-bed --allow-extra-chr 0
#run admixture test if works well run more K
$ADM newNAME-genolike1.bed 5
####in a loop to get many values of K and validations. You can run this in a slurm job
for K in 1 2 3 4 5 6 7 8 9 10; do $ADM -B2000 -j40 --cv newNAME-genolike1.bed $K | tee Bootlog${K}.out; done
