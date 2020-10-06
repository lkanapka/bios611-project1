library(tidyverse)

# Read in data
storms <- read_csv("derived_data/storms.csv")
storms$flag<-1

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
  labs(x="Year",
       y="Count")+
  theme(plot.title = element_text(hjust = 0.5))+
  scale_x_continuous(breaks=seq(1968,2019, by=5))+
  ylim(0,30)+ 
  theme(legend.title = element_blank())+ 
  scale_fill_manual(name = "status", values = c("red", "orange", "yellow"), 
                    labels = c("Hurricane", "Tropical Storm", "Tropical Depression"))+
  theme(axis.text.x= element_text(family="Times New Roman", color='black',size=14),
        axis.text.y= element_text(family="Times New Roman", color='black',size=14),
        axis.title.x = element_text(family="Times New Roman",size=14, margin=margin(15,0,0,0)),
        axis.title.y = element_text(family="Times New Roman",size=14, margin=margin(0,15,0,0)),
        legend.position="top")

ggsave("figures/cyclone_count.png",plot=p, width=10, height=5)

# Text for report 
write(sprintf('To further illustrate how the intensity of storms is increasing over time, Figure 3 shows the number of tropical cyclones by year broken down by classification. A tropical depression is the least intense and a hurricane is the most intense. Since 1968 there has been a decline in the number of tropical depressions and an increase in the number of tropical storms and hurricanes.   
              
![Number of Tropical Cylones by Intensity Over Time (1968-2019)](figures/cyclone_count.png)
              
In a linear regression model with the count of hurricanes as the dependent variable and the number of years from 1968 as a continuous variable, the coefficient for time was borderline statistically significant (p=0.067). In a similar linear regression model with average windspeed as the outcome, the coefficient for time was highly statistically significant (p<0.001). Therefore, there is some evidence of a linear relationship between time and intensity of storms.'), 
      file='fragments/intensity.fragment.Rmd', append=FALSE)