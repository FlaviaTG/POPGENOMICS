#call your installed R version in your user home
module load gcc/8.2.0-fasrc01 R/3.6.1-fasrc02
export R_LIBS_USER=$HOME/app/R_3.6:$R_LIBS_USER
#now you can call R
#
library(SNPRelate)
library(gdsfmt)
library("devtools")
library(ggplot2)
#make the .gds format, can take a while
snpgdsVCF2GDS("genolike1.vcf", "genolike1.gds", method="biallelic.only")
genofile <- snpgdsOpen("enolike1.gds", readonly = FALSE)
#annotate population and species category. The order is the same as in your .vcf file header
samp.annot1 <- data.frame(pop.group = c("Vermont","Vermont","Nova_Scotia","Nova_Scotia","Nova_Scotia","Nova_Scotia","Nova_Scotia","Vermont","Vermont","Catskill","Essex","Catskill","New_Hampshire","Quebec","Quebec","Essex","Labrador","Newfoundland","Newfoundland","Newfoundland","Newfoundland","Labrador","Labrador","Newfoundland","Newfoundland","Newfoundland","Newfoundland","Labrador","Costa_Rica","Costa_Rica","Braddock_Bay"
),
                         sub.species = c("bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","bicknelli","minimus","minimus","minimus","minimus","minimus","minimus","minimus","minimus","minimus","minimus","minimus","minimus","minimus","minimus","minimus"
))


add.gdsn(genofile, "sample.annot1", samp.annot1)
pop_code <- read.gdsn(index.gdsn(genofile, path="sample.annot1/pop.group"))

pca <- snpgdsPCA(genofile, autosome.only=FALSE)
#Principal Component Analysis (PCA) on genotypes:
#Excluding 26,868 SNPs (monomorphic: TRUE, MAF: NaN, missing rate: NaN)
#Working space: 31 samples, 72,976 SNPs


# variance proportion (%)
pc.percent <- pca$varprop*100
head(round(pc.percent, 2))
#[1] 30.45  5.10  3.85  3.23  3.01  3.00


# Get sample id
sample.id <- read.gdsn(index.gdsn(genofile, "sample.id"))

# Get population information
pop_code <- read.gdsn(index.gdsn(genofile, "sample.annot1/pop.group"))

# Get subspecies information
subspecies_code <- read.gdsn(index.gdsn(genofile, "sample.annot1/sub.species"))
#
head(cbind(sample.id, pop_code))
### Make a data.frame
tab <- data.frame(sample.id = pca$sample.id,
    pop = factor(pop_code)[match(pca$sample.id, sample.id)],
    sp = factor(subspecies_code)[match(pca$sample.id, sample.id)],
#    pop_shape = c(0,1,2,2,3,2,4,5,6,7,2,3,4,6,3,7,1,2,8,5,3,6,4,6,8,2,8,8,2,9,3),
    EV1 = pca$eigenvect[,1],    # the first eigenvector
    EV2 = pca$eigenvect[,2],    # the second eigenvector
    stringsAsFactors = FALSE)
head(tab)
##########
colors <- c("#E69F00","#999999")
colors <- colors[as.numeric(tab$sp)]

# Define shapes
shapes = c(0,1,2,3,4,5,6,7,8,9,10) 
shapes <- shapes[as.numeric(tab$pop)]
pdf("PCA-minimus-31.pdf")
setEPS()
postscript("PCA-minimus-31.eps")
par(xpd = T, mar = par()$mar + c(0,0,0,10))
plot(tab$EV2, tab$EV1, col=colors,pch=shapes, xlab="eigenvector 2 (5.10%)", ylab="eigenvector 1 (30.45%)",cex=1.5,yaxt = "n",cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)
#legend("bottomleft", legend=levels(tab$pop), col=c("#E69F00","#999999"), cex=2, pch=c(0,1,2,3,4,5,6,7,8,9,10))
legend(0.2, 0.2, legend=levels(tab$pop),col=c("#E69F00","#999999"), cex=1.2, pch=c(0,1,2,3,4,5,6,7,8,9,10),
       lwd = 1, lty = 1)
axis(side = 1, labels = FALSE,cex=1.5,cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)

## Draw the y-axis.
axis(side = 2,
     ## Rotate the labels.
     las = 2,cex=1.5,
     ## Adjust the label position.
     mgp = c(3, 0.75, 0))
par(mar=c(7, 5, 5, 6) + 0.1)
##all plots
lbls <- paste("PC", 1:4, "\n", format(pc.percent[1:4], digits=2), "%", sep="")
pairs(pca$eigenvect[,1:4], labels=lbls, col=colors, pch=shapes)
dev.off()
ggsave(plot=plot,"Mutation-rate-rho-10Mbp-chunksCHR-and-ZCHR.eps",device=cairo_ps)
#####################
# relatedness 

ibd.robust <- snpgdsIBDKING(genofile, sample.id=sample.id, num.thread=2, autosome.only=FALSE)


data <- snpgdsIBDSelection(ibd.robust)

for (i in 1:nrow(data)) {
        if (data$kinship[i]>= 0.354) data$color[i] <- "gray"
        if (data$kinship[i]>= 0.177 & data$kinship[i]< 0.354) data$color[i] <- "red"
        if (data$kinship[i]>= 0.0884 & data$kinship[i]< 0.177) data$color[i] <- "blue"
        if (data$kinship[i]>= 0.0442 & data$kinship[i]< 0.0884) data$color[i] <- "green"
        if (data$kinship[i]>= 0 & data$kinship[i]< 0.0442) data$color[i] <- "cyan"
        if (data$kinship[i]< 0) data$color[i] <- "black"
}
pdf("kingship_minimus-31all.pdf")
# full plot
plot(data$IBS0, data$kinship, xlab="Proportion of Zero IBS",
     ylab="Estimated Kinship Coefficient (KING-robust)",
     pch = 21, col=1, bg = data$color, cex = 2)
abline(h=0.354, lty = 2)
abline(h=0.177, lty = 2)
abline(h=0.0884, lty = 2)
abline(h=0.0442, lty = 2)
abline(h=0, lty = 2)

legend("topright", inset = 0.02, legend = c("1st degree", "2nd degree", "3rd degree", "unrelated"),
       pch = 21, col = 1, pt.bg = c("red","blue","green", "black"), pt.cex = 2, bg = "white", y.intersp =2)


# zoomed plot
plot(data$IBS0, data$kinship, xlab="Proportion of Zero IBS",
     ylab="Estimated Kinship Coefficient (KING-robust)",
     ylim = c(0,0.25), xlim = c(0,0.04),
     pch = 21, col=1, bg = data$color, cex = 2)
abline(h=0.354, lty = 2)
abline(h=0.177, lty = 2)
abline(h=0.0884, lty = 2)
abline(h=0.0442, lty = 2)
abline(h=0, lty = 2)

legend("topright", inset = 0.02, legend = c("1st degree", "2nd degree", "3rd degree", "unrelated"),
       pch = 21, col = 1, pt.bg = c("red","blue","green", "black"), pt.cex = 2, bg = "white", y.intersp =2)

dev.off()
#########dendrogram
set.seed(100)
ibs.hc <- snpgdsHCluster(snpgdsIBS(genofile, num.thread=2, autosome.only=FALSE))
set.seed(100)
ibs.hc <- snpgdsHCluster(snpgdsIBS(genofile, num.thread=2, autosome.only=FALSE))
rv <- snpgdsCutTree(ibs.hc)
pdf("dendogram-minimus-31.pdf")
plot(rv$dendrogram, leaflab="none", main="HapMap Phase II")
table(rv$samp.group)
rv2 <- snpgdsCutTree(ibs.hc, samp.group=as.factor(pop_code))
#Create 10 groups.
plot(rv2$dendrogram, leaflab="none", main="HapMap Phase II")
#legend("topright", legend=levels(subspecies_code), col=1:nlevels(subspecies_code), pch=19, ncol=3)
legend("bottomright", legend=levels(pop_code), col=1:nlevels(pop_code), pch=19, ncol=3)
dev.off()
#############

