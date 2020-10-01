# COVID DATA
df <- read.csv("https://raw.githubusercontent.com/slyang-cn/data/slyangcn/national-history.csv",header = TRUE,sep = ",",quote = '"') 
data <- df
data$date <- lubridate::ymd(data$date)

# GOOG STOCK DATA
stock <- quantmod::getSymbols("GOOG",src="yahoo",from="2020-01-22",to="2020-08-29",auto.assign = FALSE)
stock_ymd <- as.data.frame(stock)
stock_ymd$date <- rownames(stock_ymd)
stock_ymd$date <- lubridate::ymd(stock_ymd$date)

# COVID DATA "left_join" GOOG STOCK DATA
covid_stock_join <- dplyr::left_join(data,stock_ymd,by="date")




# map data
American_map <-read.csv("https://raw.githubusercontent.com/slyang-cn/data/slyangcn/American_map_data.csv")
# map cloor
map_color <-read.csv("https://raw.githubusercontent.com/slyang-cn/data/slyangcn/covid_20201001.csv")
# map data & map color join
map_join <- join(American_map,map_color,type="full")

map_join$Total_cases_q<-cut(map_join$Total_cases,breaks = c(0,5000,10000,50000,100000,500000,max(map_join$Total_cases)*1.2),
                      labels = c("5k-","5k-10k","10k-50k", "50k-100k","100k-500k","500k+"),include.lowest = TRUE)

