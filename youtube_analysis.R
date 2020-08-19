library(readr)
library(dplyr)
library(wordcloud2) 
library(ggplot2)
library(epitools)

words = read_csv("/home/marlon/mainfolder/projects/Google_takeout/Youtube/words.csv")

#Frequency of words
words = words %>%
    group_by(words) %>%
    summarise(numero = n())

#Word Cloud
wordcloud2(data = words, size=1.6)


sentences = read_csv("/home/marlon/mainfolder/projects/Google_takeout/Youtube/sentences.csv")

sentences_year = sentences %>%
    mutate(dates = as.Date(dates, format = "%Y-%m-%d")) %>%
    mutate(month = month(as.POSIXlt(dates, format="%Y-%m-%d"))) %>%
    mutate(month = month.abb[month], year = format(as.Date(dates, format="%Y-%m-%d"),"%Y")) %>%
    group_by(year, month) %>%
    summarise(n = n())

sentences_year$month = factor(sentences_year$month, levels = month.abb)


sentences_hour = sentences %>%
    mutate(dates = as.Date(dates, format = "%Y-%m-%d"))%>%
    mutate(hour = format(as.POSIXct(hours,format="%H:%M:%S"),"%H"), 
            year = format(as.Date(dates, format="%Y-%m-%d"),"%Y")) %>%
    group_by(year, hour) %>%
    summarise(n = n())
    


#By year, By month, By Hour

#Number of Searches on YouTube per Month and Year
ggplot(sentences_year, aes(x = month, y = n, group = year, color = year))+
    geom_line()+
    geom_point()+
    scale_x_discrete(limits = month.abb)+
    labs(title = "Number of Searches on YouTube per Month and Year")+
    ylab("Number of Searches") +
    xlab("Month")+
    theme_bw()
    
#Number of searches per hours in each year
ggplot(sentences_hour, aes(x = hour, y = n, group = year))+
    geom_bar(stat = "identity", aes(fill = year))+
    facet_grid(year ~ .)+
    labs(title = "Number of Searches on YouTube per Hour and Year")+
    ylab("Number of Searches") +
    xlab("Hour")+
    theme_bw()+
    theme(legend.position = "None")
   
    
