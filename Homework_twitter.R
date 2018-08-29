library(RCurl)
library(base64enc)
library(twitteR)
library(ROAuth)

options(httr_oauth_cache = T)

options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))) 
download.file(url="https://curl.haxx.se/ca/cacert.pem", destfile = "carcert.pem") 
setup_twitter_oauth(consumerKey, consumerSecret, accesstoken, accesstokensecret) 

## 준비 끝 !!!


string = enc2utf8("미스터선샤인")

mr = searchTwitter(string, n = 3000, lang = "ko", retryOnRateLimit = 10000)

mr

mr_extracted = sapply(mr, function(t) t$getText())
mr_extracted

mr_extracted = twListToDF(mr)
mr_extracted$text

mr_extracted = unique(mr_extracted)
mr_extracted

head(mr_extracted$text)

library(wordcloud)
library(RColorBrewer)
library(stringr)
library(dplyr)
library(KoNLP)

mr_nouns = extractNoun(mr_extracted$text)
# 요거 위해서 KoNLP 패키지 필요~!

mr_wordcount = table(unlist(mr_nouns))
mr_df = as.data.frame(mr_wordcount, stringsAsFactors = F)
head(mr_df)
mr_df = rename(mr_df,
               word = Var1,
               freq = Freq)
mr_df = filter(mr_df, nchar(word) >= 2)
top20 = mr_df %>% 
  arrange(desc(freq)) %>% 
  head(20)

top20

library(wordcloud)

pal = brewer.pal(8, "Dark2")
set.seed(1234)
wordcloud(words = mr_df$word,
          freq = mr_df$freq,
          min.freq = 10,
          max.words = 50,
          random.order = F,
          rot.per = .1,
          scale = c(6, 0.2),
          colors = pal)


install.packages("d3Network")
library(d3Network)
?d3Network

d3Network(mr_df, Source = word(), Target = NULL, height = 600, width = 900,
          fontsize = 7, linkDistance = 50, charge = -200, linkColour = "#666",
          nodeColour = "#3182bd", nodeClickColour = "#E34A33",
          textColour = "#3182bd", opacity = 0.6, parentElement = "body",
          standAlone = TRUE, file = NULL, iframe = FALSE,
          d3Script = "http://d3js.org/d3.v3.min.js")

## 세개 이상 열이 있어야함. 관계를 나타내는 그래프인듯.