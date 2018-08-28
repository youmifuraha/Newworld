library(KoNLP)
library(dplyr)

useNIADic()

txt = readLines("SteveJobs_body.txt")
head(txt)

install.packages("stringr")
