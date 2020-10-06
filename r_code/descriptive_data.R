library(tidyverse)

# Read in data
storms <- read_csv("derived_data/storms.csv")

# Create a variable for decade to make it easier to tabulate
storms <- storms %>% mutate(decade=floor(storms$year/10)*10) %>%
                     mutate(decade=paste(decade, "-", decade+9, sep=""))

# Create a table of descriptive data by decade
# Exclude the 60s because it is not complete
table<- storms %>% filter(decade != "1960-1969") %>%
        group_by(decade) %>%
        summarize(count=n(), countCyclone=sum(cycloneFlg),countHur=sum(hurFlg), 
                  countMajor=sum(majorFlg), avgWind=mean(wind)) %>%
        mutate(avgWind=round(avgWind))

# Output table
write.csv(table, "derived_data/decade_summary.csv", row.names=F)

# Box plot of wind speed by decade
p <- ggplot(storms, aes(x=decade, y=wind)) +
  geom_boxplot()+
  stat_summary(fun.y=mean, geom="point", shape=23, size=4)+
  theme_classic()+
  labs(x="Decade",
       y="Wind Speed")+
  theme(axis.text.x= element_text(family="Times New Roman", color='black',size=14),
        axis.text.y= element_text(family="Times New Roman", color='black',size=14),
        axis.title.x = element_text(family="Times New Roman",size=14, margin=margin(15,0,0,0)),
        axis.title.y = element_text(family="Times New Roman",size=14, margin=margin(0,15,0,0)))

ggsave("figures/wind_boxplot.png",plot=p, width=10, height=5)

# Text for report 
write(sprintf('Table 1 shows summary statistics by decade to demonstrate how the frequency and intensity of storms have changed between 1970 and 2019. A hurricane is defined as a tropical cyclone with sustained wind speed of at least 64 knots. A major hurricane is a tropical cyclone with sustained wind speed greater than 110 knots. P-values are based on a linear regression model with the number of years from 1968 as a continuous predictor.'),
              file='fragments/descriptive_dataA.fragment.Rmd', append=FALSE)

write(sprintf('![Boxplots of Wind Speed by Decade](figures/wind_boxplot.png)

However, there does appear to be an increase in the intensity of hurricanes over time. The number of hurricanes increased from 49 between 1970 and 1979 to 72 between 2010 and 2019. Similarly the average sustained wind speed increased from 48 knots between 1970 and 1979 to 68 knots between 2010 to 2019. Figure 2 shows boxplots for the sustained wind speed by decade.'),
      file='fragments/descriptive_dataB.fragment.Rmd', append=FALSE)
      
              
            