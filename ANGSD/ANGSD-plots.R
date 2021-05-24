#libraries
library(ggplot2)
library(reshape)
library(dplyr)
library(tidyverse)
library(ggpubr)
library(rstatix)
library(gghighlight)
#
#plot tajimas D
M <-read.table("species1.pestPG",  header=TRUE)
B <-read.table("species2.pestPG", header=TRUE)
##group
B$group <- 'bicknelli'
M$group <- 'minimus'
pdf("Tajimas-correlation-plot.pdf")
# and combine into your new data frame vegLengths
df<- merge(B, M, by="WinCenter")
df2<- rbind(B, M)
p <- ggplot(df, aes(y=Tajima.y, x=Tajima.x)) + geom_point(stat="identity")+
labs(y = "Tajimas D' minimus",x = "Tajimas D' bicknelli") +
  theme_bw()+theme(axis.text=element_text(size=14), axis.line = element_line(colour = "black"),
	axis.text.y = element_text(size = 14, angle = 0, hjust = 1, vjust = 0, face = "plain"),
	axis.text.x = element_text(size = 14, angle = 0, hjust = 1, vjust = 0, face = "plain"),  
	axis.title.y = element_text(size = 20, angle = 90, hjust = .5, vjust = .5, face = "plain"), 
	axis.title=element_text(size=20),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank()) + gghighlight(Tajima.y > 2 & Tajima.x > 2|Tajima.y < -2 & Tajima.x < -2 )
p
# the best way to save all plots
ggsave(plot=p,"ZCHR-Tajima-ANGSD.eps",device=cairo_ps)
#
#SFS
##run in R
#plot the results
nnorm <- function(x) x/sum(x)
#expected number of sites with 1:32 derived alleles
res <- rbind(
  bicknelli=scan("species1.saf.idx.sfs")[-1],
  minimus=scan("species2.saf.idx.sfs")[-1]
)
colnames(res) <- 1:32
colnames(res) <- 1:30
resDown <- t(apply(resDown,1,nnorm))
# density instead of expected counts
res <- t(apply(res,1,nnorm))
pal <- colorRampPalette(colors = c("#E69F00","#999999"))(2)
#plot the none ancestral sites
downsampleSFS <- function(x,chr){ #x 1:2n , chr < 2n
    n<-length(x)
    mat <- sapply(1:chr,function(i) choose(1:n,i)*choose(n- (1:n),chr-i)/choose(n,chr))
    nnorm( as.vector(t(mat) %*% x)[-chr] )
}
setEPS()
postscript("40CHR-SFS-downsampled.eps")
resDown <- t(apply(res,1,downsampleSFS,chr=33))
par(mar=c(9,5,1,1)+.1)
barplot(resDown,beside=T,legend=c("bicknelli","minimus"),names=1:30,args.legend = list(x="topright"), xlab = "No. minor alleles", ylab = "Frequency",col = pal,cex.axis=1,cex.names=1, cex.lab=1, cex.lab=1, cex.sub=1)
dev.off()
#
