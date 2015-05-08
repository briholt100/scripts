library(RCurl)
library(devtools)
devtools::install_github("jennybc/googlesheets")
library("googlesheets") #from https://github.com/jennybc/googlesheets
library(dplyr)
suppressMessages(library("dplyr"))

authorize(new_user=T) #will open up webbrowser, prompt to login, or go to #1 google account--may be worth logging out of all of them.

#dater
getwd()
#setwd("I:/My Data Sources/classroom stuff/")

#Campus
getwd()
#setwd("I:/My Data Sources/classroom stuff/")

#look up key manually through googleDcocs, or after authorizing use gs_ls()
my_sheets <- gs_ls() #shows list of spreadsheets
gap_key <- "1Yo0d8D7VuSavdti1V7NBvy_vWRpQOUdHK0YHTuW2LW8"
copy_ss(key = gap_key, to = "PersonalitySpring2015")


Person<-register_ss("PersonalitySpring2015")
objects(Person)

#person_list_feed <- get_via_lf(Person, ws = "Sheet1") #creates a list
person_csv <- Person %>% get_via_csv(ws = "Sheet1")
str(person_csv)

#download_ss(key='PersonalitySpring2015',to="./per15.xlsx",overwrite=T) #add ws = int to pick particular worksheets