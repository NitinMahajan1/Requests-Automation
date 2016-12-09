#Group Requests

setwd("C:/Users/Redirection/mahajn3/Documents/GitHub/Requests-Automation")

library(xlsx)
library(dplyr)
library(openxlsx)
library(zoo)

data_file<-read.xlsx('Consolidated.xlsx')

# data_file<-data_file[c(14,13,1,9)]
##data_file<-data_file[c(14,13,1:12)]

data_df<-tbl_df(data_file)

data_df$Closed_At<- as.Date(data_df$Closed_At)
data_df$Closed_At<- as.yearmon(data_df$Closed_At,format="%b %Y")

data_df<-data_df[c(2,14,13,1,9)]
  
  
by_Ops<- group_by(data_df,Ops_Grp,Ops_Team,Source,Closed_At)

agg<-summarise(by_Ops,count=n_distinct(Number))

write.xlsx(agg, file="Consolidated_Agg.xlsx",row.names=FALSE)