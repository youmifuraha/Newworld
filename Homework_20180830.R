## 미국 지도에 주별 인구수 그리기!

# 크롤링 4총사
library(rvest)  
library(ggplot2) 
library(ggmap)
library(xml2)  

# html 파일 가져오기
html.pop = read_html("https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population")

html.pop
View(html.pop)

# 첫 번째 테이블만 추출

df_pop = html_table(html_nodes(html.pop, "table")[[3]], fill = TRUE)

df_pop
View(df_pop)
str(df_pop)

library(dplyr)
df_pop = rename(df_pop,
                pop = 2017population,
                name = State/Territory/Division/Region)

# 여전히 안되네...-_- 그럼 다른 방법!!!
colnames(df_pop)[1] = "state"
colnames(df_pop)[3] = "population"

# 소문자로
df_pop$state = tolower(df_pop$state)

library(ggplot2)
library(ggiraphExtra)

states_map = map_data("state")
str(states_map)
View(states_map)
ggChoropleth(data = df_pop,
             aes(fill = population,
                 map_id = state),
             map = pop_map,
             interactive = T)

# 안됨! 아... 그 pop에 이름이 state로 되있어서 그런듯? map은 변수이름이 region이니깐! region으로 맞춰보장.
colnames(df_pop)[1] = "region"

# 그려줭
ggChoropleth(data = df_pop,
             aes(fill = population,
                 map_id = region),
             map = pop_map,
             interactive = T)

# 에러 남. Error: `data` must be uniquely named but has duplicate elements

# 원하는 애들만 빼서 다시 df 만들어 보장.
library(dplyr)
df_pop1 = df_pop %>%
  select(region, population)

# -_- 이것도 안 됨... Error in select_impl(.data, vars) : Columns `Rank`, `Rank`, `Rank` must have a unique name

colnames(df_pop)[2] = "rank1"
colnames(df_pop)[4] = "rank2"
colnames(df_pop)[6] = "rank3"
colnames(df_pop)[8] = "rank4"

# 다쉬! 그려줭!
ggChoropleth(data = df_pop,
             aes(fill = population,
                 map_id = region),
             map = pop_map,
             interactive = T)

?ggChoropleth()

ggChoropleth(data = df_pop, mapping, map, palette = "OrRd", reverse = FALSE, color = "grey50", title = "", digits = 1, interactive = T)


# 이상해....... 그림 이상함.
View(df_pop)
str(df_pop$population)
# 캐릭터로 되어 있는디... 숫자로 바꿔야되지 않남.

df_pop$pop = as.numeric(df_pop$population)
View(df_pop)

# 다시
df_pop$pop = as.numeric(gsub(",", "", df_pop$population))
# 옷@@개꿀!! 됐당.


# 다쉬! 그려줭!
ggChoropleth(data = df_pop,
             aes(fill = pop,
                 map_id = region),
             map = pop_map,
             interactive = T)
# YAYAY