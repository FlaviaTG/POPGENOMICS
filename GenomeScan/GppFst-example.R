library(devtools)
library(GppFst)
library(phybase)
library(Geneland)
library(dplyr)

#input the beast output .log from SNAPP, to select theta values
df <- read.table("SNAPP.log", header=T)
dt <- select(df, theta0, theta1, theta4, TreeHeightLogger)
colnames(dt) <- c("pop0.theta", "pop1.theta", "pop12.theta", "TreeHeightLogger")
#write the posteriorParameters to use in GppFst
write.table(dt, "GppFstPosteriorParameters-ZCHR.csv" , row.names=FALSE, quote=F, sep = "\t")
library(tidyr)
library(anchors)
#calculate Fst with vcftools on the dataset runned on SNAPP
vcftools --vcf genolike1.vcf --weir-fst-pop individuals-tokeep-calculation.txt --out genolike1
###
#add 3 columns
#1 with lenght of window 10000bp for all SNPs
#2 with number of samples from pop.0
#3 with number of samples for pop.1
Fst <- read.table("genolike1.weir.fst", header=T)
#number of individuals per sub species and the window size
Fst['locus.length']='10000'
Fst['pop0.samples']='16'
Fst['pop1.samples']='12'
Fst$pop0.samples <- as.numeric(Fst$pop0.samples)
Fst$pop1.samples <- as.numeric(Fst$pop1.samples)
Fst$locus.length <- as.numeric(Fst$locus.length)
dd2 <- replace.value(Fst,c("WEIR_AND_COCKERHAM_FST"),NaN,as.double(NA))
Fst <- Fst %>% drop_na()
#GppFST parameters obtained from SNAPP parsed on R
MCMC.samples <- read.posterior("GppFstPosteriorParameters-ZCHR.csv",format="tab",burnin=0.25)
pop0.samples<- Fst$pop0.samples
pop1.samples<- Fst$pop1.samples
locus.length<- Fst$locus.length
MCMC.samples <- MCMC.samples %>% drop_na()
#
Gppfst.results<- GppFst(posterior.samples = MCMC.samples,
			loci.per.step=10,
			SNP.per.locus=1,
			sample.vec.0=pop0.samples,
			sample.vec.1=pop1.samples,
			sequence.length.vec=locus.length)
data(GppFst.results)
fst.results <- GppFst.results[,1][is.na(GppFst.results[,1])==F]
#compare empirical to simulated
pdf("GppFst-results-ZCHR.pdf")
hist(as.numeric(fst.results), breaks=100)
empirical.Fst <- Fst$WEIR_AND_COCKERHAM_FST, Fst$POS
par(mfrow=c(2,2))
hist(as.numeric(fst.results),breaks=100)
hist(as.numeric(empirical.Fst),breaks=100)
dev.off()
#lets look at the number of loci with Fst > 0.9
fstR <- fst.results[fst.results > .9]
emFst <- empirical.Fst[empirical.Fst > .9]
write.table(fstR,"neutral-falsePositive-ZCHR.csv" , row.names=FALSE, quote=F, sep = "\t")
write.table(emFst,"selection-ZCHR.csv" , row.names=FALSE, quote=F, sep = "\t")
#empirical will have more probably suggesting false postive du to other evolutionary process. There is aout 10x the proportion of loci with Fst> 0.9 in the empirical when compared to the PPS
#lest compare the proportion of loci with Fst > 0.9
length(fst.results[fst.results > .9]/length(fst.results))
length(empirical.Fst[empirical.Fst > .9]/length(empirical.Fst))
#lets compare the proportion of loci with Fst=1, complate fixation for opposite alleles
length(fst.results[fst.results == 1]/length(fst.results))
length(empirical.Fst[empirical.Fst == 1]/length(empirical.Fst))
# compute the probability of observing 10 or more loci with an Fst value of 1
observed <- length(empirical.Fst[empirical.Fst == 1])
1-pbinom(q=(observed-1),size=length(empirical.Fst), prob= length(fst.results[fst.results == 1]/length(fst.results)))
1-dbinom(x=0,size=length(empirical.Fst), prob= length(fst.results[fst.results == 1]/length(fst.results)))
#
#for the dxy
Gppdxy.results<- GppDxy(posterior.samples = MCMC.samples,
			loci.per.step=10,
			sample.vec.0=pop0.samples,
			sample.vec.1=pop1.samples,
			sequence.length.vec=locus.length)
data(Gppdxy.results)
dxy.results <- Gppdxy.results[,1][is.na(Gppdxy.results[,1])==F]
#compare empirical to simulated
pdf("GppFst-results-ZCHR-dxy.pdf")
hist(as.numeric(dxy.results), breaks=100)
empirical.Fst <- Fst$WEIR_AND_COCKERHAM_FST
par(mfrow=c(2,2))
hist(as.numeric(dxy.results),breaks=100)
hist(as.numeric(empirical.Fst),breaks=100)
dev.off()
#lets look at the number of loci with Fst > 0.9
dxyR <- dxy.results[dxy.results > .9]
emFst <- empirical.Fst[empirical.Fst > .9]
write.table(dxyR,"neutral-falsePositive-ZCHR-dxy.csv" , row.names=FALSE, quote=F, sep = "\t")
write.table(emFst,"selection-ZCHR-dxy.csv" , row.names=FALSE, quote=F, sep = "\t")
#empirical will have more probably suggesting false postive du to other evolutionary process. There is aout 10x the proportion of loci with Fst> 0.9 in the empirical when compared to the PPS
#lest compare the proportion of loci with Fst > 0.9
length(fst.results[fst.results > .9]/length(fst.results))
length(empirical.Fst[empirical.Fst > .9]/length(empirical.Fst))
#lets compare the proportion of loci with Fst=1, complate fixation for opposite alleles
length(fst.results[fst.results == 1]/length(fst.results))
length(empirical.Fst[empirical.Fst == 1]/length(empirical.Fst))
# compute the probability of observing 10 or more loci with an Fst value of 1
observed <- length(empirical.Fst[empirical.Fst == 1])
1-pbinom(q=(observed-1),size=length(empirical.Fst), prob= length(fst.results[fst.results == 1]/length(fst.results)))
1-dbinom(x=0,size=length(empirical.Fst), prob= length(fst.results[fst.results == 1]/length(fst.results)))
#
