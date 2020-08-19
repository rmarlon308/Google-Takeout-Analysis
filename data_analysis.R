library(dplyr)
library(readr)
library(ggplot2)
library(leaflet)

df = read_csv("https://raw.githubusercontent.com/rmarlon308/google_takeout_analysis/master/activities.csv")


df_activities = df %>%
    mutate(totalTime = totalTime_min / 60) %>%
    group_by(activity) %>%
    summarise(total_min = sum(totalTime_min)) %>% 
    arrange(desc(total_min))

total_time = sum(df_activities$total_min)

df_activities = df_activities %>%
    mutate(percentage = format(round(total_min / total_time * 100, 2), nsmall = 2))

#Pie graph
ggplot(df_activities, aes(x = "", total_min, fill = activity)) +
    geom_bar(stat = "identity", width = 1, color = "white") +
    coord_polar("y", start = 0) + 
    geom_text(aes(label = paste(percentage, "%")), color = "white", position = position_stack(vjust = 0.5)) + 
    theme_void()

ggplot(df_activities, aes(x = total_min, activity , fill = activity)) +
    geom_bar(stat = "identity", width = 1, color = "white") +
    coord_polar("y", start = 0) + 
    theme_bw() + 
    theme(legend.position = "none", plot.title = element_text(face = "italic", size = 13)) + 
    xlab("Time [min]") + ylab("Activity") + labs(title = "Activity vs Time")


df_loacations = df %>%
    select(place, longitude, latitude) %>%
    mutate(longitude = longitude / 10^7, latitude = latitude / 10 ^7) %>%
    group_by(place) %>%
    summarise(n = n(), longitude =  mean(longitude), latitude =  mean(latitude))

longitude_mean = mean(df_loacations$longitude)
latitude_mean = mean(df_loacations$latitude)

#Map
leaflet(df_loacations) %>% 
    addTiles() %>%
    setView( longitude_mean, latitude_mean, zoom = 3) %>%
    addCircleMarkers(
        color = "purple",
        opacity = 0.5,
        radius = 5,
        label = ~place
    ) 