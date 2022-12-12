library(tidyverse)
library(stringr)
library(dplyr)
df = read.csv("https://raw.githubusercontent.com/wagstrom/ds-202-final-project/main/rym_top_5000_all_time.csv")

#Converting to numeric
df$Number.of.Ratings = as.numeric(gsub(",", "", df$Number.of.Ratings))
df$Ranking = as.numeric(df$Ranking)
df$Average.Rating = as.numeric(df$Average.Rating)
df$Number.of.Reviews = as.numeric(df$Number.of.Reviews)
df2 = df

#Converting comma-separated strings into separate columns
df2[c('Genre_1', 'Genre_2', 'Genre_3', 'Genre_4', 'Genre_5')] <- str_split_fixed(df2$Genres, ', ', 5)
df2[c('Desc_1', 'Desc_2', 'Desc_3', 'Desc_4', 'Desc_5', 'Desc_6', 'Desc_7', 'Desc_8',
     'Desc_9', 'Desc_10')] <- str_split_fixed(df2$Descriptors, ', ', 10)
sum(df2$Desc_10 != "")
df3 = df2

#Add column for average rating, average reviews, average ratings, and number of appearances per artist
df3 = df3 %>%
  group_by(Artist.Name) %>%
  mutate(Artist.Average.Score = mean(Average.Rating),
         Artist.Average.Reviews = mean(Number.of.Reviews),
         Artist.Average.Ratings = mean(Number.of.Ratings),
         Artist.Frequency = nrow(as.data.frame(Artist.Name))
         )

View(df3)

df_final = df3

Year_useful = str_sub(df_final$Release.Date,-2,-1)
Year_start = NULL
for(i in 1:5000){
  if(Year_useful[i] <  22){
    Year_start[i] = 20
  }else{
    Year_start[i] = 19
    }}
    year = data.frame(Year_start, Year_useful)
    df_final$Year = paste(year$Year_start, year$Year_useful)
    df_final$Year = gsub(" ", "", df_final$Year)
    Month = gsub("[^a-zA-Z]", "",df_final$Release.Date )
    df_final$Month = Month
    Day = parse_number(str_sub(df_final$Release.Date,,2))
    df_final$Day=factor(Day)
    
   # In this chunk we are adding columns to find the averages of scores,
  #  reviews, number of ratings, and number of appearances for each artist.
   # We do this so we can compare the individual values easier.

View(df_final)
  df_final <- df_final %>% select(!(Release.Date|Genres|Descriptors))  
  write.csv(df_final,"df_final.csv",row.names = FALSE)
  
#Summaries
nrow(unique(as.data.frame(df_final$Album)))
  #Some albums have the same names
nrow(unique(as.data.frame(df_final$Artist.Name)))
  #2787 unique artists
nrow(unique(as.data.frame(df_final$Genre_1)))
  #453 unique primary genres

summary(df_final)
str(df_final)

