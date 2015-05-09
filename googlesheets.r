library(RCurl)
library(devtools)
devtools::install_github("jennybc/googlesheets")
library(dplyr)
library(googlesheets) #from https://github.com/jennybc/googlesheets
suppressMessages(library("dplyr"))

gs_auth(new_user=T) #will open up webbrowser, prompt to login, or go to #1 google account--may be worth logging out of all of them.

#dater
getwd()
#setwd("/home/brian/Projects/teachStats")

#Campus
getwd()
#setwd("I:/My Data Sources/classroom stuff/")

#look up key manually through googleDcocs, or after authorizing use gs_ls()
my_sheets <- gs_ls() #shows list of spreadsheets
per_key <- "1Yo0d8D7VuSavdti1V7NBvy_vWRpQOUdHK0YHTuW2LW8"
gs_copy(gs_key(per_key), to = "PersonalitySpring2015")

person<-gs_title("PersonalitySpring2015")
#(per_key <- my_sheets$sheet_key[my_sheets$sheet_title == "PersonalitySpring2015"])
objects(person)

#person_list_feed <- get_via_lf(Person, ws = "Sheet1") #creates a list
person_csv <- person %>% get_via_csv(ws = "Sheet1")
str(person_csv)
colnames(person_csv)<-c("num","SID","name","email","attend","exam1MC","exam1SA","examTot","case1","disc1","total","percent")
person_csv<-person_csv[-1,-1]


person_csv<-(as.matrix(person_csv))
person_csv<-as.data.frame(person_csv)
class((person_csv))
str(person_csv)
class(person_csv[,5])
apply(person_csv,2,class)

for (i in 4:11){
  person_csv[,i]<-as.numeric(as.character(person_csv[,i]))
}

mean(person_csv[,5],na.rm=T)

#download_ss(key='PersonalitySpring2015',to="./per15.xlsx",overwrite=T) #add ws = int to pick particular worksheets