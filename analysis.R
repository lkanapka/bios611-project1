library(tidyverse)

# Read in data
storms <- read_csv("derived_data/storms.csv")

# Create a figure of the number of storms over time
storms$flag<-1
p <- ggplot(storms, aes(year)) +
  geom_freqpoly(stat="count")+
  theme_classic()+
  labs(title="Number of Tracked Storms by Year (1968-2019)",
       x="Year",
       y="Count")+
  theme(plot.title = element_text(hjust = 0.5))+
  scale_x_continuous(breaks=seq(1968,2019, by=5))+
  ylim(0,40)

ggsave("figures/storm_count.png",plot=p, width=10, height=5)


# Create a figure of the number of cyclones by intensity over time
cyclones<- storms %>%
  filter(status %in% c("TD", "TS","HU"))

cyclones$status<- factor(cyclones$status, levels=c("HU", "TS", "TD"))

cycloneCount <- cyclones %>%
  group_by(year, status, .drop=FALSE) %>%
  summarize(count=sum(flag))


p <- ggplot(cycloneCount, aes(x=year, y=count, fill=status))+
  geom_area()+
  theme_classic()+
  labs(title="Number of Tropical Cyclones by Intensity Over Time",
       x="Year",
       y="Count")+
  theme(plot.title = element_text(hjust = 0.5))+
  scale_x_continuous(breaks=seq(1968,2019, by=5))+
  ylim(0,30)+ 
  theme(legend.title = element_blank())+ 
  scale_fill_manual(name = "status", values = c("red", "orange", "yellow"), 
            labels = c("Hurricane", "Tropical Storm", "Tropical Depression"))


ggsave("figures/cyclone_count.png",plot=p, width=10, height=5)