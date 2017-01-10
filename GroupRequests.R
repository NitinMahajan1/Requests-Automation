#Group Requests

setwd("C:/Users/Redirection/mahajn3/Documents/GitHub/Requests-Automation")

# library(xlsx)
library(dplyr)
library(openxlsx)
library(zoo)

# data_file<-data_file[c(14,13,1,9)]
##data_file<-data_file[c(14,13,1:12)]

data_file<-read.xlsx('Consolidated.xlsx')
x<-subset(data_file, grepl("^Closed", data_file$State), )
y<-data_file[data_file$State %in% c("Complete","Completed"),]
data_filex<-rbind(x,y)

data_df<-tbl_df(data_filex)
data_df<-data_df[c(2,14,13,1,9)]
data_df$Closed_At<- as.Date(data_df$Closed_At)
data_df$Closed_At<- as.yearmon(data_df$Closed_At,format="%b %Y")

by_Ops<- group_by(data_df,Ops_Grp,Ops_Team,Source,Closed_At)
agg<-summarise(by_Ops,count=n_distinct(Number))


data_awf<-read.xlsx('awf historical volumes.xlsx')
awf_df<-tbl_df(data_awf)
awf_df$Date<-convertToDateTime(awf_df$Date, origin = "1900-01-01")
awf_df$Date<-as.yearmon(awf_df$Date,format="%b %Y")

colnames(awf_df)[which(names(awf_df) == "Ops.Team")] <- "Ops_Team"
colnames(awf_df)[which(names(awf_df) == "Ops.Grp")] <- "Ops_Grp"
colnames(awf_df)[which(names(awf_df) == "Distinct.count.of.Number")] <- "count"
colnames(awf_df)[which(names(awf_df) == "Date")] <- "Closed_At"

awf_dataframe<-as.data.frame(awf_df)
agg_dataframe<-as.data.frame(agg)

new<-rbind(agg_dataframe,awf_dataframe)

new_df<-tbl_df(new)
new_sorted<-arrange(new_df,Ops_Grp)

write.xlsx(new_sorted, file="Consolidated_Agg.xlsx",row.names=FALSE)