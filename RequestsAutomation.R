setwd("C:/Users/Redirection/mahajn3/Documents/GitHub/Requests-Automation")
# library(xlsx)
library(readxl)
library(openxlsx)
library(RODBC)
library(dplyr)
library(stringr)
source("req_servnow_opsteam.R")
source("req_rms_opsteam.R")
##source("AddOpsGrp.R")

#####SERVICE NOW###########SERVICE NOW###########SERVICE NOW###########SERVICE NOW###########SERVICE NOW###########SERVICE NOW###########SERVICE NOW###########SERVICE NOW###########SERVICE NOW###########SERVICE NOW######

Serv_Now<-read.csv("sc_task.csv",header=TRUE)[,c('number','assignment_group','assigned_to','state','opened_at','due_date','expected_delivery_date','closed_at','request_item.cat_item.name')]
Serv_Now$SLOBreach<-''
Serv_Now$Product<-''
Serv_Now$Source<-'Service Now'

Serv_Now<-Serv_Now[c(12,1:11)]
colnames(Serv_Now)<-c("Source","Number","Assignment_Group","Assigned_To","State","Opened_At","Due_Date","Expected_Del_Date","Closed_At","Task","SLO_Breach","Product")

Serv_Now$Ops_Team<-req_servnow_opsteam(Serv_Now)

Serv_Now$Ops_Team[Serv_Now$Assignment_Group=="TS-OPS-Akamai" ] <- "Akamai"

Serv_Now$Ops_Team[Serv_Now$Assignment_Group=="ITS-OPS-IOS-APP" ] <- "iSeries"
Serv_Now$Ops_Team[Serv_Now$Assignment_Group=="ITS-OPS-IOS" ] <- "iSeries"
#####A3 Opened#############A3 Opened#############A3 Opened#############A3 Opened#############A3 Opened#############A3 Opened#############A3 Opened#############A3 Opened#############A3 Opened#############A3 Opened########

Master_A3_Opened<-read.xlsx("A3-master.xlsx",3)

A3_Opened<-Master_A3_Opened[,c(1,6,5,9,3,4,11,8,2)]

A3_Opened$Source<-'A3 Open'
A3_Opened$due.date<-''
A3_Opened$expected.delivery.date<-''

A3_Opened<-A3_Opened[,c(10,1:5,11,12,6,7,8,9)]

colnames(A3_Opened)<-c("Source","Number","Assignment_Group","Assigned_To","State","Opened_At","Due_Date","Expected_Del_Date","Closed_At","Task","SLO_Breach","Product")

A3_Opened$Closed_At<-convertToDateTime(A3_Opened$Closed_At, origin = "1900-01-01")
A3_Opened$Opened_At<-convertToDateTime(A3_Opened$Opened_At, origin = "1900-01-01")
A3_Opened$Opened_At<-as.character(A3_Opened$Opened_At)
A3_Opened$Closed_At<-as.character(A3_Opened$Closed_At)

A3_Opened$SLO_Breach<-ifelse(A3_Opened$SLO_Breach == 1,A3_Opened$SLO_Breach <- 'Y',A3_Opened$SLO_Breach <- 'N')

A3_Opened<-subset(A3_Opened,Assignment_Group!=63465 | is.na(Assignment_Group))

A3_Opened$Assignment_Group[A3_Opened$Assignment_Group==92322]<-"Enterprise Tools"

A3_Opened$Ops_Team <-
 ifelse  (A3_Opened$Assignment_Group=="Enterprise Tools" ,"Operations Tools","OTHERS")

new<-rbind(Serv_Now,A3_Opened)

#####A3 Closed##########A3 Closed##########A3 Closed##########A3 Closed##########A3 Closed##########A3 Closed##########A3 Closed##########A3 Closed##########A3 Closed##########A3 Closed##########A3 Closed##########A3 Closed##

Master_A3_Closed<-read.xlsx("A3-master.xlsx",2)
A3_Closed<-Master_A3_Closed[,c(1,6,5,9,3,4,11,8,2)]

A3_Closed$Source<-'A3 Closed'
A3_Closed$due.date<-''
A3_Closed$expected.delivery.date<-''

A3_Closed<-A3_Closed[,c(10,1:5,11,12,6,7,8,9)]


colnames(A3_Closed)<-c("Source","Number","Assignment_Group","Assigned_To","State","Opened_At","Due_Date","Expected_Del_Date","Closed_At","Task","SLO_Breach","Product")

A3_Closed$Closed_At<-convertToDateTime(A3_Closed$Closed_At, origin = "1900-01-01")
A3_Closed$Opened_At<-convertToDateTime(A3_Closed$Opened_At, origin = "1900-01-01")
A3_Closed$Opened_At<-as.character(A3_Closed$Opened_At)
A3_Closed$Closed_At<-as.character(A3_Closed$Closed_At)

A3_Closed$SLO_Breach<-ifelse(A3_Closed$SLO_Breach == 1,A3_Closed$SLO_Breach <- 'Y',A3_Closed$SLO_Breach <- 'N')

A3_Closed<-subset(A3_Closed,Assignment_Group!=63465 | is.na(Assignment_Group))

A3_Closed$Assignment_Group[A3_Closed$Assignment_Group==92322] <- "Enterprise Tools"

A3_Closed$Ops_Team <-
  ifelse  (A3_Closed$Assignment_Group=="Enterprise Tools" ,"Operations Tools","OTHERS")

new2<-rbind(new,A3_Closed)

########A3NEW#####START###########A3################A3########A3################A3################A3########A3################A3################A3
Master_A3_TDA<-read_excel("8Months2.xls")
A3_TDA<-Master_A3_TDA[,c(2,1,5,4,8,7,6)]

A3_TDA$Assignment_Group<-'Infrastructure Tools & Analysis'
A3_TDA$Due_Date<-''
A3_TDA$Expected_Del_Date<-""
A3_TDA$Task<-""
A3_TDA$SLO_Breach<-""
A3_TDA$Ops_Team<-'Infrastructure Tools & Analysis'

A3_TDA<-A3_TDA[,c(1,2,8,3,4,5,9,10,6,11,12,7,13)]

colnames(A3_TDA)<-c("Source","Number","Assignment_Group","Assigned_To","State","Opened_At","Due_Date","Expected_Del_Date","Closed_At","Task","SLO_Breach","Product","Ops_Team")

A3_TDA$Opened_At<-as.character(A3_TDA$Opened_At)
A3_TDA$Closed_At<-as.character(A3_TDA$Closed_At)
A3_TDA$Number<-as.character(A3_TDA$Number)

new2x<-rbind(new2,A3_TDA)
########A3NEW#####END###########A3################A3########A3################A3################A3########A3################A3################A3
########RMS################RMS################RMS################RMS################RMS################RMS################RMS################RMS################RMS################RMS################RMS################RMS########

RMS<-read.xlsx("RMS Good Data.xlsx",1)[,c(2,3,34,35,36,37,39,40,67)]

RMS$Source<-"RMS"
RMS$Expected_Del_Date<-""
RMS$Product<-""


RMS<-RMS[,c(10,1,4,5,2,8,6,11,7,3,9,12)]
colnames(RMS)<-c("Source","Number","Assignment_Group","Assigned_To","State","Opened_At","Due_Date","Expected_Del_Date","Closed_At","Task","SLO_Breach","Product")

RMS$Due_Date<-convertToDate(RMS$Due_Date, origin = "1900-01-01")
RMS$Due_Date<-as.character(RMS$Due_Date)

RMS_2<-RMS

RMS$Closed_At<-strptime(RMS$Closed_At,format ="%m/%d/%Y %I:%M %p" )
RMS$Closed_At<-as.character(RMS$Closed_At)

RMS$Ops_Team<-req_rms_opsteam(RMS)

new3<-rbind(new2x,RMS)

##############SDM  T_Requests###################

#dbhandle <- odbcDriverConnect('driver={SQL Server};server=49.32.15.29,3341;database=SDMReporting;uid=webuser;pwd=webUser')
#SDM <- sqlQuery(dbhandle, 'SELECT TOP 10  * FROM [SDMReporting].[dbo].[T_Requests]')

#PROD CONNECTION
dbhandle <- odbcDriverConnect('driver={SQL Server};server=CRSDPSSCA0REP,3341;database=SDMReporting;uid=webuser;pwd=WebUser72')
#SDM <- sqlQuery(dbhandle, "SELECT * FROM [SDMReporting].[dbo].[T_Requests] where Open_Date > '2016-08-31 23:59:59.000' and Open_Date < '2016-10-01 00:00:00.000'")

SDM <- sqlQuery(dbhandle, "SELECT * FROM [SDMReporting].[dbo].[T_Requests] where Assigned_Group in ('ITS-EITO-Batch Operations',	'ITS-EITO-BATCH-ANALYSIS',	'ITS-EITO-Change Management',	'ITS-EITO-Change Response Team',	'ITS-EITO-Cloud Infrastructure Support',	'ITS-EITO-Cloud Tenant Support',	'ITS-EITO-CloudOps',	'ITS-EITO-Database Netezza',	'ITS-EITO-Database-DB2',	'ITS-EITO-Database-Essbase',	'ITS-EITO-Database-Oracle',	'ITS-EITO-Database-SQL',	'ITS-EITO-Database-Sybase',	'ITS-EITO-EBX-Operations',	'ITS-EITO-Enterprise Environment Surveillance',	'ITS-EITO-Host Operations',	'ITS-EITO-iOS-APP',	'ITS-EITO-NS-NWO-NM',	'ITS-EITO-Operations Coordination Group',	'Inactive-ITS-EITO-OSG-APP-DC-US',	'Inactive-ITS-EITO-OSG-APP-TDCT-CORP-WW',	'ITS-EITO-OSG-iOS',	'ITS-EITO-OSG-MON',	'ITS-EITO-OSG-MW',	'ITS-EITO-OSG-NWO',	'ITS-EITO-OSG-WIN',	'ITS-EITO-Reporting',	'ITS-EITO-Scheduling Services',	'ITS-EITO-Service Management',	'ITS-EITO-Service Support Tools Services',	'ITS-EITO-TIS',	'ITS-EITO-Tool Solutions Distributed',	'ITS-EITO-Tool Solutions Host',	'ITS-EITO-TR-Application',	'ITS-EITO-TR-Data Protection',	'ITS-EITO-TR-Data Storage',	'ITS-EITO-TR-DCM',	'ITS-EITO-TR-DDSG',	'ITS-EITO-TR-EUT-Citrix',	'ITS-EITO-TR-EUT-Messaging',	'ITS-EITO-TR-EUT-Messaging Security',	'ITS-EITO-TR-EUT-Mobility',	'ITS-EITO-TR-EUT-SharePoint and IIS',	'ITS-EITO-TR-EUT-Unified Communications',	'ITS-EITO-TR-Middleware',	'ITS-EITO-TR-Monitoring',	'ITS-EITO-TR-NETWORK',	'ITS-EITO-TR-Network Performance',	'ITS-EITO-TR-SecTools',	'ITS-EITO-TR-Windows',	'ITS-EITO-UNIX',	'ITS-ETNS-WSP-INTEL-T',	'ITS-ETNS-WSP-TIVOLI',	'ITS-OPS-Incident Specialist',	'ITS-OPS-SPS-EUT-RAS',	'ITS-TDI-GI-AS400 Response Team',	'ITS-TDI-GI-AS400 Security Response Team',	'ITS-TDI-GI-BATCH-Operation response team',	'ITS-TDI-GI-Middleware Response Team',	'ITS-TDI-GI-UNIX Response Team',	'ITS-TDI-GI-Windows Response Team',	'TDI-LH-PSAM-ITS',	'VEN-IBM-AIX Acct Team',	'VEN-IBM-AIX Change Mgmt',	'VEN-IBM-AIX Support',	'VEN-IBM-EMSG',	'VEN-IBM-EMSG-ESC',	'VEN-IBM-EMSG-PGR',	'VEN-IBM-ESTORAGE',	'VEN-IBM-GOODTECH',	'CORP-GSI-VDI Support',	'DCTS-ATM-Operations',	'CBAW-APP-Support',	'EETS-PROD-Support-team',	'TDS-APP-SUPPORT',	'ITS-AMCB-EITO- Application Response Team - Encore',	'DCTS-Digital-Support',	'TS-AMCB-Ops-Application',	'DC-TS-CCS',	'DC-TS-AMCB-Online Channels',	'CAMS-APP-SUPPORT',	'CBAW-TS-Retail-Sales',	'CBAW-TS-Retail-Service',	'ITS-EITO-MQ Response', 'ITS-EITO-EBX-Operations','ITS-EITO-Scheduling Services','ITS-TDI-GI-BATCH-Operation','ITS-EITO-AKAMAI')")
odbcCloseAll()

SDM2<-SDM[,c(1,3,12,5,7,16,10)]
SDM2$Source<-"SDM"
SDM2$Due_Date<-""
SDM2$Expected_Del_Date<-""
SDM2$SLO_Breach<-""
SDM2$Product<-""
SDM2<-SDM2[,c(8,1,2,3,4,5,9,10,6,7,11,12)]
colnames(SDM2)<-c("Source","Number","Assignment_Group","Assigned_To","State","Opened_At","Due_Date","Expected_Del_Date","Closed_At","Task","SLO_Breach","Product")

SDM2$Number<-as.character(SDM2$Number)
SDM2$Opened_At<-as.character(SDM2$Opened_At)
SDM2$Closed_At<-as.character(SDM2$Closed_At)

#SDM2$Ops_Team<-req_sdm_opsteam(SDM2)


SDM2$Ops_Team <-
ifelse   (SDM2$Assignment_Group== "ITS-EITO-NS-NWO-NM","Infrastructure Tools & Analysis"
,ifelse  (SDM2$Assignment_Group== "ITS-EITO-OSG-NWO","Network"
,ifelse  (SDM2$Assignment_Group== "ITS-EITO-OSG-WIN","Windows"
,ifelse  (SDM2$Assignment_Group== "ITS-EITO-TR-Data Protection","Data Protection"
,ifelse  (SDM2$Assignment_Group== "ITS-EITO-TR-Data Storage","Storage"
,ifelse  (SDM2$Assignment_Group== "ITS-EITO-TR-DCM","Data Centre Mgmt"
,ifelse  (SDM2$Assignment_Group== "ITS-EITO-TR-Network","Network"
,ifelse  (SDM2$Assignment_Group== "ITS-EITO-TR-Network Performance","Infrastructure Tools & Analysis"
,ifelse  (SDM2$Assignment_Group== "ITS-EITO-TR-Windows" ,"Windows"
,ifelse  (SDM2$Assignment_Group== "ITS-EITO-UNIX" ,"UNIX"
,ifelse  (SDM2$Assignment_Group== "ITS-ETNS-WSP-INTEL-T" ,"Windows"
,ifelse  (SDM2$Assignment_Group== "ITS-TDI-GI-UNIX Response Team" ,"UNIX"
,ifelse  (SDM2$Assignment_Group== "ITS-TDI-GI-Windows Response Team" ,"Windows"
,ifelse  (SDM2$Assignment_Group== "VEN-IBM-AIX Acct Team" ,"AIX"
,ifelse  (SDM2$Assignment_Group== "VEN-IBM-AIX Change Mgmt" ,"AIX"
,ifelse  (SDM2$Assignment_Group== "VEN-IBM-AIX Support","AIX"
,ifelse   (SDM2$Assignment_Group=="ITS-EITO-Batch Operations","Batch"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-BATCH-ANALYSIS","Batch"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-EBX-Operations","Scheduling Services"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Enterprise Environment Surveillance","ESS & OCG"
,ifelse   (SDM2$Assignment_Group=="ITS-EITO-Host Operations" ,"Host Ops"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Operations Coordination Group","ESS & OCG"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-OSG-MON","Monitoring Tools Optimization"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Scheduling Services","Scheduling Services"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-TIS","Batch"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-TR-Monitoring","Monitoring Tools Optimization"
,ifelse  (SDM2$Assignment_Group=="ITS-ETNS-WSP-TIVOLI","Monitoring Tools Optimization"
,ifelse  (SDM2$Assignment_Group=="ITS-TDI-GI-BATCH-Operation response team","Scheduling Services"
,ifelse   (SDM2$Assignment_Group=="<DO NOT USE-OBSOLETE> ITS-EITO-TR-Database-Oracle-DB2-SYBASE","Database"
,ifelse  (SDM2$Assignment_Group=="<DO NOT USE-OBSOLETE>ITS-EITO-OSG-DB","Database"
,ifelse  (SDM2$Assignment_Group=="<DO NOT USE-OBSOLETE>ITS-EITO-TR-Database-SQL-ESSBASE","Database"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Database Netezza","Database"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Database-DB2","Database"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Database-Essbase","Database"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Database-Oracle","Database"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Database-SQL","Database"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Database-Sybase","Database"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-IOS-APP","iSeries"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-OSG-iOS","iSeries"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-OSG-MW","Middleware"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Service Support Tools Services","Operations Tools"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Tool Solutions Distributed","Operations Tools"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-Tool Solutions Host","Operations Tools"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-TR-DDSG","Directories"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-TR-EUT-Citrix","End User Technology"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-TR-EUT-Messaging","End User Technology"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-TR-EUT-Messaging Security","End User Technology"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-TR-EUT-Mobility","End User Technology"
,ifelse  (SDM2$Assignment_Group=="ITS-EITO-TR-EUT-Unified Communications","End User Technology",as.character(SDM2$Assignment_Group))))))))))))))))))))))))))))))))))))))))))))))))))
          
SDM2$Ops_Team <-         
 ifelse  (SDM2$Ops_Team=="ITS-EITO-TR-Middleware","Middleware"
,ifelse  (SDM2$Ops_Team=="ITS-EITO-TR-EUT-SharePoint and IIS","End User Technology"
,ifelse  (SDM2$Ops_Team=="ITS-EITO-TR-SecTools","Security and Monitoring Tools"
,ifelse  (SDM2$Ops_Team=="ITS-OPS-SPS-EUT-RAS","End User Technology"
,ifelse  (SDM2$Ops_Team=="ITS-TDI-GI-AS400 Response Team","iSeries"
,ifelse  (SDM2$Ops_Team=="ITS-TDI-GI-AS400 Security Response Team","iSeries"
,ifelse  (SDM2$Ops_Team=="ITS-TDI-GI-Middleware Response Team","Middleware"
,ifelse  (SDM2$Ops_Team=="VEN-IBM-EMSG","End User Technology"
,ifelse  (SDM2$Ops_Team=="VEN-IBM-EMSG-ESC","End User Technology"
,ifelse  (SDM2$Ops_Team=="VEN-IBM-EMSG-PGR","End User Technology"
,ifelse  (SDM2$Ops_Team=="VEN-IBM-ESTORAGE","End User Technology"
,ifelse  (SDM2$Ops_Team=="VEN-IBM-GOODTECH","End User Technology"
,ifelse  (SDM2$Ops_Team=="CORP-GSI-VDI Support","End User Technology"
,ifelse  (SDM2$Ops_Team=="ITS-EITO-MQ Response","MQ"
,ifelse  (SDM2$Ops_Team=="ITS-EITO-Cloud Infrastructure Support" ,"Cloud"
,ifelse  (SDM2$Ops_Team=="ITS-EITO-Cloud Tenant Support" ,"Cloud"
,ifelse  (SDM2$Ops_Team=="ITS-EITO-CloudOps" ,"Cloud"
,ifelse  (SDM2$Ops_Team=="ITS-EITO-Change Management" ,"Change"
,ifelse  (SDM2$Ops_Team=="ITS-EITO-Change Response Team" ,"Change"
,ifelse  (SDM2$Ops_Team=="ITS-EITO-Reporting" ,"Automation and Innovation"
,ifelse  (SDM2$Ops_Team=="TDI-LH-PSAM-ITS" ,"Ops Integration Lead",as.character(SDM2$Ops_Team))))))))))))))))))))))

SDM2$Ops_Team<- ifelse(
    SDM2$Ops_Team =="Middleware" | SDM2$Ops_Team=="Network"            | SDM2$Ops_Team=="Infrastructure Tools & Analysis"|
    SDM2$Ops_Team =="Windows"    | SDM2$Ops_Team=="Data Centre Mgmt"   | SDM2$Ops_Team=="Storage and Data Protection"|
    SDM2$Ops_Team =="UNIX"       | SDM2$Ops_Team=="AIX"                | SDM2$Ops_Team=="Scheduling Services"|
    SDM2$Ops_Team =="Batch"      | SDM2$Ops_Team=="ESS & OCG"          | SDM2$Ops_Team=="Host"|
    SDM2$Ops_Team =="Database"   | SDM2$Ops_Team=="iSeries"            | SDM2$Ops_Team=="Monitoring Tools Optimization"|
    SDM2$Ops_Team =="Directories"| SDM2$Ops_Team=="End User Technology"| SDM2$Ops_Team=="Operations Tools"|  
    SDM2$Ops_Team =="MQ"         | SDM2$Ops_Team=="Cloud"              | SDM2$Ops_Team=="Security and Monitoring Tools"|
    SDM2$Ops_Team =="Change"     | SDM2$Ops_Team=="Ops Integration Lead"| SDM2$Ops_Team=="Automation and Innovation" 
   ,SDM2$Ops_Team,"OTHERS")

SDM2$Ops_Team[SDM2$Ops_Grp=="ITS-EITO-AKAMAI" ] <- "Akamai"


new4<-rbind(new3,SDM2)

##############SDM  T_NIR###################


#Dev Connection has 0 NIR records
#dbhandle <- odbcDriverConnect('driver={SQL Server};server=49.32.15.29,3341;database=SDMReporting;uid=webuser;pwd=webUser')


#PROD CONNECTION
dbhandle <- odbcDriverConnect('driver={SQL Server};server=CRSDPSSCA0REP,3341;database=SDMReporting;uid=webuser;pwd=WebUser72')

#NIR <- sqlQuery(dbhandle, 'SELECT * FROM [SDMReporting].[dbo].[T_NIR] where Open_Date > '2016-09-31 23:59:08.000'')

#NIR <- sqlQuery(dbhandle, "SELECT *  FROM [SDMReporting].[dbo].[T_nir] where  DateRequested > '2016-08-31 23:59:59.000' and  DateRequested < '2016-10-01 00:00:00.000'")
NIR <- sqlQuery(dbhandle, "SELECT *  FROM [SDMReporting].[dbo].[T_nir]")
odbcCloseAll()

NIR$DateRequired<-as.character(NIR$DateRequired)

NIR2<-NIR[,c(3,2,13,25,28,1,16,5,14)]
NIR2$Source<-"NIR"
NIR2$Due_Date<-""
NIR2$Product<-""
NIR2<-NIR2[,c(10,1,2,3,4,5,11,6,7,8,9,12)]
colnames(NIR2)<-c("Source","Number","Assignment_Group","Assigned_To","State","Opened_At","Due_Date","Expected_Del_Date","Closed_At","Task","SLO_Breach","Product")

NIR2$Number<-as.character(NIR2$Number)
NIR2$Opened_At<-as.character(NIR2$Opened_At)
NIR2$Closed_At<-as.character(NIR2$Closed_At)
NIR2$Due_Date<-""
NIR2$Expected_Del_Date<-as.character(NIR2$Expected_Del_Date)
NIR2$SLO_Breach<-ifelse(NIR2$SLO_Breach == 1,NIR2$SLO_Breach <- 'Y',NIR2$SLO_Breach <- 'N')

NIR2$Ops_Team <-
 ifelse  (NIR2$Assignment_Group=="OS-Unix"  ,"UNIX"
,ifelse  (NIR2$Assignment_Group=="OS-Windows"  , "Windows"
,ifelse  (NIR2$Assignment_Group=="OS-Virtual"  , "Windows"
,ifelse  (NIR2$Assignment_Group=="Workspace Server Solutions & Support" ,"Windows"
,ifelse  (NIR2$Assignment_Group=="Systems Response File Print Team" ,"Windows"
,ifelse  (NIR2$Assignment_Group=="Storage-Data Protection" ,"Data Protection"
,ifelse  (NIR2$Assignment_Group=="Storage-Data Storage" ,"Storage"
,ifelse  (NIR2$Assignment_Group=="VEN-IBM-AIX Support" ,"AIX"
,ifelse  (NIR2$Assignment_Group=="ITS-EITO-TR-EUT-Messaging" ,"End User Technology"
,ifelse  (NIR2$Assignment_Group=="ITS-EITO-TR-EUT-SharePoint and IIS" ,"End User Technology"
,ifelse  (NIR2$Assignment_Group=="ITS-EITO-TR-EUT-Citrix" ,"End User Technology"
,ifelse  (NIR2$Assignment_Group=="Database-DB2" ,"Database"
,ifelse  (NIR2$Assignment_Group=="Database-SQL" ,"Database"
,ifelse  (NIR2$Assignment_Group=="Database-Oracle" ,"Database"
,ifelse  (NIR2$Assignment_Group=="Database-SyBase" ,"Database"
,ifelse  (NIR2$Assignment_Group=="Database-Essbase" ,"Database"
,ifelse  (NIR2$Assignment_Group=="DDSG (Dedicated Directories Support Group)" ,"Directories"
,ifelse  (NIR2$Assignment_Group=="SSTS HP-SA/BSAE Support" ,"Operations Tools"
,ifelse  (NIR2$Assignment_Group=="SSTS CiRBA Support" ,"Operations Tools"
,ifelse  (NIR2$Assignment_Group=="SSTS CfM support" ,"Operations Tools"
,ifelse  (NIR2$Assignment_Group=="SSTS AWF Support" ,"Operations Tools"
,ifelse  (NIR2$Assignment_Group=="SSTS SDM Support" ,"Operations Tools"
,ifelse  (NIR2$Assignment_Group=="SSTS UAPM Support" ,"Operations Tools"
,ifelse  (NIR2$Assignment_Group=="SSTS WOC Support" ,"Operations Tools"
,ifelse  (NIR2$Assignment_Group=="SSTS Attestation Support" ,"Operations Tools"
,ifelse  (NIR2$Assignment_Group=="Security Tools Infrastructure Support" ,"Security and Monitoring Tools"
,ifelse  (NIR2$Assignment_Group=="SSTS Gomez Support" ,"Monitoring Tools Optimization"
,ifelse  (NIR2$Assignment_Group=="Enterprise Change Management" ,"Change"
,ifelse  (NIR2$Assignment_Group=="Middleware-Tomcat" ,"Middleware"
,ifelse  (NIR2$Assignment_Group=="Middleware-Weblogic" ,"Middleware"
,ifelse  (NIR2$Assignment_Group=="Hosted VDI" ,"End User Technology"
,ifelse  (NIR2$Assignment_Group=="Database-Sybase" ,"Database"
,ifelse  (NIR2$Assignment_Group=="MQ Engineering and Support" ,"MQ","OTHERS")))))))))))))))))))))))))))))))))

new5<-rbind(new4,NIR2)

####NM1-start

#Add stringr library and REMOVE WHITESPACES
new5$Assignment_Group<-str_trim(new5$Assignment_Group)

#########del#########x--->new5<-new5[which(new5$Assignment_Group!="Infrastructure Tools and Analysis" & Source=="A3 Open"),]

# function(df_name,new_col,col_2b_checked)###Add new col Ops_Group
###**********new5$Ops_Group<-AddOpsGrp(new5,Ops_Group,Assignment_Group)

###*********x<-subset(new5,is.na(new5$Ops_Team)) ###Subsetdata with Ops_Team as NA


new5$Ops_Grp <- new5$Assignment_Group

new5$Ops_Grp[new5$Ops_Grp =="ITS-EITO-Batch Operations" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-BATCH-ANALYSIS" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-EBX-Operations" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Enterprise Environment Surveillance"] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Operations Coordination Group" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-OSG-MON" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Scheduling Services" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TIS" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-Monitoring" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Host Operations" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-ETNS-WSP-TIVOLI" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-TDI-GI-BATCH-Operation response team"] <- "Data Centre Operations"


new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-NS-NWO-NM" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-OSG-NWO" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-OSG-WIN" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-Data Protection" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-Data Storage" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-DCM"] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-NETWORK"] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-Network Performance"] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-Windows"] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-UNIX"] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-ETNS-WSP-INTEL-T" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-TDI-GI-UNIX Response Team" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-TDI-GI-Windows Response Team" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="VEN-IBM-AIX Acct Team"] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="VEN-IBM-AIX Change Mgmt" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="VEN-IBM-AIX Support" ] <- "Core Infrastructure"

new5$Ops_Grp[new5$Ops_Grp=="<DO NOT USE-OBSOLETE> ITS-EITO-TR-Database-Oracle-DB2-SYBASE"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="<DO NOT USE-OBSOLETE>ITS-EITO-OSG-DB"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="<DO NOT USE-OBSOLETE>ITS-EITO-TR-Database-SQL-ESSBASE"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database Netezza"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database-DB2"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database-Essbase"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database-Oracle"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database-SQL"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database-SyBase"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-iOS-APP"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-OSG-iOS"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-OSG-MW"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Service Support Tools Services"] <- "Software and Platform Services"

#// A3 Groups defined
new5$Ops_Grp[new5$Ops_Grp=="Enterprise Tools" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Infrastructure Tools and Analysis" ] <- "Core Infrastructure"

new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Tool Solutions Distributed"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Tool Solutions Host"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-DDSG"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-EUT-Citrix"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-EUT-Messaging"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-EUT-Messaging Security"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-EUT-Mobility"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-EUT-SharePoint and IIS"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-EUT-Unified Communications"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-Middleware"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-SecTools"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-OPS-SPS-EUT-RAS"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-TDI-GI-AS400 Response Team"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-TDI-GI-AS400 Security Response Team"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-TDI-GI-Middleware Response Team"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="VEN-IBM-EMSG"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="VEN-IBM-EMSG-ESC"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="VEN-IBM-EMSG-PGR"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="VEN-IBM-ESTORAGE"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="VEN-IBM-GOODTECH"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="CORP-GSI-VDI Support"] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-MQ Response"] <- "Software and Platform Services"

new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Cloud Infrastructure Support" ] <- "Cloud"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Cloud Tenant Support" ] <- "Cloud"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-CloudOps" ] <- "Cloud"

new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Change Management" ] <- "Solutions Management and Governance"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Change Response Team" ] <- "Solutions Management and Governance"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Reporting" ] <- "Solutions Management and Governance"
new5$Ops_Grp[new5$Ops_Grp=="TDI-LH-PSAM-ITS" ] <- "Solutions Management and Governance"

#//Service Now
new5$Ops_Grp[new5$Ops_Grp=="UNIX" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Database" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Operations Tools" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Middleware" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="iSeries" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Windows" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Storage and Data Protection" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Data Centre Mgt" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Infrastructure Tools & Analysis" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="AIX" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Host Ops" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="Monitoring Tools Optimization" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="Cloud" ] <- "Cloud"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database-DB2" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database-SQL" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database-Oracle" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database-Sybase" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database-Essbase" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database Netezza" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Database-Exadata" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS EITO TR Database" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-OPS-DCO-HOST-DOC" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-NETWORK-PERFORMANCE" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-OSG-iOS" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-IOS-APP" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-OPS-IOS400" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-OSG-MW" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-MW" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-OSG-Monitoring" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-Monitoring" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-NETWORK" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-Network" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-OSG-NWO" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-TR-NETWORK-IT-MANAGER-1" ] <- "OTHERS"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Data Storage-SAN" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-Data Storage-NAS" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-DATA Protection" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="VEN-IBM-AIX Team" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS EITO OSG Windows" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS EITO TR Windows" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS EITO Windows" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-OPS-IOS-APP" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-OPS-IOS" ] <- "Software and Platform Services"


#//NIR
new5$Ops_Grp[new5$Ops_Grp=="Unified  Communications" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Database" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Directories" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Operations Tools" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Security and Monitoring Tools" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="UNIX" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Windows" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Storage and Data Protection" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="AIX" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Monitoring Tools Optimization" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="Enterprise Change Management" ] <- "Solutions Management and Governance"
new5$Ops_Grp[new5$Ops_Grp=="Middleware" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="MQ Engineering and Support" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Database" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Database-DB2" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Database-SQL" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Database-Oracle" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Database-SyBase" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Database-Essbase" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="SSTS HP-SA/BSAE Support" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="SSTS CiRBA Support" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="SSTS CfM support" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="SSTS AWF Support" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="SSTS SDM Support" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="SSTS UAPM Support" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="SSTS WOC Support" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="SSTS Attestation Support" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Security Tools Infrastructure Support" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="SSTS Gomez Support" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="Middleware-Tomcat" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Middleware-Weblogic" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="OS-Unix"  ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="OS-Windows"]<-  "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="OS-Virtual"]<-  "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Workspace Server Solutions & Support" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Systems Response File Print Team" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Storage-Data Protection" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="Storage-Data Storage" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="DDSG (Dedicated Directories Support Group)" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Hosted VDI" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="Database-Sybase" ] <- "Software and Platform Services"         

#//RMS
new5$Ops_Grp[new5$Ops_Grp=="TDI-AS400 Response Team" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="ITS-TDI-BATCH-Operation Response Team" ] <- "Data Centre Operations"
new5$Ops_Grp[new5$Ops_Grp=="TDI-CCI-OPS" ] <- "GSS"
new5$Ops_Grp[new5$Ops_Grp=="TDI-DBA-Oracle access support" ] <- "Software and Platform Services"
new5$Ops_Grp[new5$Ops_Grp=="TDI-ServiceDesk Insurance support" ] <- "GSS"
new5$Ops_Grp[new5$Ops_Grp=="TDI-ServiceDesk Seniors" ] <- "GSS"
new5$Ops_Grp[new5$Ops_Grp=="TDI-ServiceDesk Telepresence" ] <- "GSS"
new5$Ops_Grp[new5$Ops_Grp=="TDI-Voice Support" ] <- "GSS"
new5$Ops_Grp[new5$Ops_Grp=="TDI-Unix Response Team" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="TDI-Windows-Response Team" ] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="TS-OPS-Akamai"] <- "Core Infrastructure"
new5$Ops_Grp[new5$Ops_Grp=="ITS-EITO-AKAMAI"] <- "Core Infrastructure"
                   

new5$Ops_Grp<- ifelse(
  new5$Ops_Grp =="Data Centre Operations"              | new5$Ops_Grp=="Core Infrastructure" |
  new5$Ops_Grp =="Software and Platform Services"      | new5$Ops_Grp=="Cloud"               |    
  new5$Ops_Grp =="Solutions Management and Governance" | new5$Ops_Grp=="GSS"                     
 ,new5$Ops_Grp,"OTHERS")


###WORKAROUND  DEFECT .
new5$Ops_Team[new5$Assignment_Group=="SSTS UAPM Support" ] <- "Operations Tools"
new5$Ops_Team[new5$Assignment_Group=="ITS-EITO-Host Operations"] <- "Batch"



###WORKAROUND...SHORCUT..CORRECT when you have time
#Serv Now
new5$Ops_Team[new5$Assignment_Group=="VEN-IBM-AIX Team"] <- "AIX"
# FIXED--?new5$Ops_Team[new5$Assignment_Group=="TS-OPS-Akamai"] <- "Akamai"
#SDM
new5$Ops_Team[new5$Assignment_Group=="ITS-EITO-AKAMAI"] <- "Akamai"
new5$Ops_Team[new5$Assignment_Group=="ITS-EITO-TR-Data Protection"] <- "Data Protection"
new5$Ops_Team[new5$Assignment_Group=="ITS-EITO-TR-Data Storage"] <- "Storage"

#A3
new5$Ops_Team[new5$Assignment_Group=="Infrastructure Tools and Analysis"] <- "Infrastructure Tools & Analysis"
new5$Ops_Team[new5$Assignment_Group=="Enterprise Tools"] <- "Operations Tools"



NA_Ops_team<-subset(new5,is.na(new5$Ops_Team))
NA_Ops_grp<-subset(new5,is.na(new5$Ops_Grp))
NA_Assigmt_Grp<-subset(new5,is.na(new5$Assignment_Group))

new5$Ops_Grp[is.na(new5$Ops_Grp)] <- "OTHERS"
new5$Ops_Team[is.na(new5$Ops_Team)] <- "OTHERS"

####NM1-end###

new5<-subset(new5,State!='Cancelled' & State!='Closed Cancelled' & State!='Closed Incomplete' 
             & State!='Closed Skipped' & State!= 'Returned to Requester' & State!= 'Template Creation')


write.xlsx(new5, file="Consolidated.xlsx",row.names=FALSE)
 
# 
# new6<-tbl_df(new5)
# new6<-filter(new5,!(Assignment_Group=="Infrastructure Tools and Analysis" & source='A3 Open'))