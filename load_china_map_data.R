library(geojsonsf)
library(sf)
library(ggplot2)
library(RColorBrewer)

API_pre = "http://xzqh.mca.gov.cn/data/"
# setwd("C:\\Users\\ysl\\Desktop\\R_map\\Original_Data-master")
## 1.全国
China = st_read(dsn = paste0(API_pre, "quanguo.json"), 
                stringsAsFactors=FALSE) 
st_crs(China) = 4326

# 2.国境线
China_line = st_read(dsn = paste0(API_pre, "quanguo_Line.geojson"), 
                     stringsAsFactors=FALSE) 
st_crs(China_line) = 4326

# 3.读取省份地理中心
# 地图中心坐标：基于st_centroid和省会坐标以及部分调整值
province_mid <- read.csv("https://raw.githubusercontent.com/slyang-cn/data/slyangcn/province.csv")
