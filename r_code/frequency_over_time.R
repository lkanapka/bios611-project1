library(tidyverse)

# Read in data
storms <- read_csv("derived_data/storms.csv")

# Get average number of storms per year 
countYr<- storms %>% group_by(year) %>%
          summarize(count=n(),countCyclone=sum(cycloneFlg))
avg<- countYr %>% summarize(avg=mean(count))
avg<- avg[[1,1]]

# Create a figure of the number of storms over time
storms$flag<-1
p <- ggplot(storms, aes(year)) +
  geom_freqpoly(stat="count")+
  theme_classic()+
  labs(x="Year",
       y="Count")+
  theme(plot.title = element_text(hjust = 0.5))+
  scale_x_continuous(breaks=seq(1968,2019, by=5))+
  ylim(0,40)+
  theme(axis.text.x= element_text(family="Times New Roman", color='black',size=14),
        axis.text.y= element_text(family="Times New Roman", color='black',size=14),
        axis.title.x = element_text(family="Times New Roman",size=14, margin=margin(15,0,0,0)),
        axis.title.y = element_text(family="Times New Roman",size=14, margin=margin(0,15,0,0)))

ggsave("figures/storm_count.png",plot=p, width=10, height=5)

# Add a horizontal line for the report
p<- p+ geom_hline(yintercept = avg, linetype='dashed')

ggsave("figures/storm_count_avg.png",plot=p, width=10, height=5)

# Text for report 
write(sprintf('From the data in Table 1, there is no clear pattern in the overall number of tracked storms by decade or the number of tropical cyclones by decade. This is further illustrated in Figure 1 which shows the number of storms recorded in the Atlantic by year between 1968 and 2019. The dashed line represents the average number of storms per year over the entire period.

In a linear regression model with the storm count as the dependent variable and the number of years since 1968 as a continuous covariate, the coefficient for time was not statistically significant (p=0.18). Therefore, there is no evidence of linear trend in the number of storms over time.
              
![Number of Tracked Storms by Year (1968-2019)](figures/storm_count_avg.png)'), 
      file='fragments/frequency.fragment.Rmd', append=FALSE)
