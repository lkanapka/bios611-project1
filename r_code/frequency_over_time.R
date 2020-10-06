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

# Text for report 
write(sprintf('Figure 1 shows the number of storms recorded in the Atlantic by year between 1968-2019. Again, there is no clear trend in the overall number of storms over time. '), 
      file='fragments/frequency.fragment.Rmd', append=FALSE)
