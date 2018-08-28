library(KoNLP)
library(dplyr)

useNIADic()

# 스티브잡스 책을 가져옵시다!
txt = readLines("SteveJobs_body.txt")
head(txt)

# 특수문자 제거!
install.packages("stringr")
library(stringr)

# 특수문자 제거... 요건, 해당 특수문자를 직접 다 넣어줘야하는듯? 이 패키지가 알아서 제거하는게 아이고.
txt = str_replace_all(txt, "//W", " ")

# 명사로 추출해줭 <- 단어단어로 해야죵
nouns = extractNoun(txt)

nouns
View(nouns)  # 와우 겁나 오래걸렸음! 기다려유.

# 명사 추출한 것으로 빈도표 생성해줭
wordcount = table(unlist(nouns))

df_word = as.data.frame(wordcount, stringsAsFactors = F)

head(df_word)  # Var1, Freq 으로 되어 있음!

# 변수명 수정하장. 인간의 언어로 ㄱㄱ
df_word = rename(df_word,
                 word = Var1,
                 freq = Freq)

# 두 글자 이상 단어 추출해줘용.
df_word = filter(df_word, nchar(word) >= 2)

# 상위 20개만 일단 뽑아볼까유
top_20 = df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)

top_20

# wordcloud 설치 & 로드!!
library(wordcloud)

# RColorBrewer 로드!!
library(RColorBrewer)

# Dark2 색상 목록이 있는데 거기에서 8개 색상을 뽑아줭
pal = brewer.pal(8, "Dark2")

# 워드 클라우드를 생성
set.seed(123)  # 난수를 고정한 거래유.
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 10,   # 최소한 2번은 나온애로?
          max.words = 200,  # 한 200개 정도 보여줭
          random.order = F,  # 랜덤하지말고, 고빈도 단어는 중앙에 배치해줭
          rot.per = .1,  # 회전 단어 비율? 아하. 단어 회전시켜서도 디스플레이하는데 걔네는 한 10퍼정도?
          scale = c(6, 0.2),  # 크기? 이건 뭐징?????????????????????????????????????
          colors = pal)  # 저 위에 디파인 해둔거!!

### 너무 안 이쁘게 나와여......ㅠㅠㅠㅠㅠㅠ
###