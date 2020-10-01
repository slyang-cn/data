library("RColorBrewer")
library("maptools")
library("plyr")
library("rJava")
library("ggplot2")

# COVID DATA
# setwd("C:\\Users\\ysl\\Desktop\\final")
df <- read.csv("https://raw.githubusercontent.com/slyang-cn/data/slyangcn/national-history.csv",header = TRUE,sep = ",",quote = '"') 
data <- df
data$date <- lubridate::ymd(data$date)

# GOOG STOCK DATA
stock <- quantmod::getSymbols("GOOG",src="yahoo",from="2020-02-01",to="2020-06-30",auto.assign = FALSE)

# map data
American_map <-readShapePoly("https://github.com/slyang-cn/data/blob/slyangcn/STATES.SHP")
AD1 <- American_map@data
AD2 <- data.frame(id=rownames(AD1),AD1)
American_map1 <- fortify(American_map)
American_map_data <- join(American_map1,AD2, type = "full")
American_map_data<-American_map_data[,1:12]

newdata<-read.csv("https://raw.githubusercontent.com/slyang-cn/data/slyangcn/President.csv")


data1<-subset(American_map_data,STATE_NAME!='Alaska'& STATE_NAME!='Hawaii')
data2<-subset(American_map_data,STATE_NAME=="Hawaii")    
data3<-subset(American_map_data,STATE_NAME=="Alaska") 

data2$long<-data2$long+65
data3$long<-data3$long+40
data3$lat<-data3$lat-42
data4<-rbind(data1,data2,data3)

American_data <- join(data4, newdata, type="full")
midpos <- function(AD1){mean(range(AD1,na.rm=TRUE))} 
centres <- ddply(American_data,.(STATE_ABBR),colwise(midpos,.(long,lat)))

mynewdata<-join(centres,newdata,type="full")

qb <- quantile(na.omit(American_data$Trump), c(0,0.2,0.4,0.6,0.8,1.0))
American_data$Trump_q<-cut(American_data$Trump,qb,labels = c("0-20%", "20-40%","40-60%","60-80%", "80-100%"),include.lowest = TRUE)
