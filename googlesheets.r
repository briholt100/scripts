library("googlesheets") #from https://github.com/jennybc/googlesheets
library(RCurl)
authorize(new_user=F)
getwd()
download_ss(key='1Yo0d8D7VuSavdti1V7NBvy_vWRpQOUdHK0YHTuW2LW8',to="./teachStats/per15.xlsx",overwrite=T) #add ws = int to pick particular worksheets
#(key='1Yo0d8D7VuSavdti1V7NBvy_vWRpQOUdHK0YHTuW2LW8')
