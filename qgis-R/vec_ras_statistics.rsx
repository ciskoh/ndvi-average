##Vector Raster Overlay=group
##showplots
##Layer=vector
##basemap=raster
##Code=Field Layer
##Vector=output vector


library(sp)
library(raster)

#graphical parameters
par(

mfrow=c(2,2),
mar = c(4,2,4, 1),
mgp=c(1,1,0),
cex=1,
cex.axis=0.8

)

#0 function to count pixel values
f.count <- function(rast) {
test=as.matrix(table(as.vector(rast)))
test[,1]=test[,1]/sum(test[,1])*100
rownames(test)=names
return(test)
}

#0.2 names and colors for plots
names=c("Very deg.", "Deg.", "Healthy", "Potential")
cols=c("Red", "Orange", "Light Green", "Dark Green")
polyn=Layer[[Code]]

#1 create table for main raster
main=f.count(basemap)
>barplot(main[,1], ylim=c(0,50), col=cols,
las=2,
main=c("distribution of deg.", "categories in study area"))
text(((1:4)-0.3)*1.2, main[,1]+2, round(main[,1],2))

#2 crop raster and plot difference in values
values<- sapply(polyn, function(x) {
# get single polygon
pol=Layer[ Layer[[Code]] == x, ]
# crop raster
r1= crop(basemap, pol)
# create table wtih raster values
t1=f.count(r1)
t2=t1-main
return(t2)
})

#3 plot all the value differences

>sapply(c(1:NCOL(values)), function(x) {
barplot(values[,x], ylim=c(-50,50),
col=cols,
las=2,
names.arg=names,
main=paste("differences in polygon", Layer[[Code]][x] ))
abline(coef=c(0,0), col="blue", lty=2)
text(((1:4)-0.3)*1.2, values[,x]+2, round(values[,x],2))
} )

#add difference data to vector layer
Layer[[Code]]
Layer@data$VDeg=values[1,]
Layer@data$Deg=values[2,]
Layer@data$Healthy=values[3,]
Layer@data$Pot=values[4,]
Vector=Layer

