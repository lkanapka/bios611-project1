library(tidyverse)

# Read in data
storms <- read_csv("derived_data/storms.csv")

# Create a variable for decade to make it easier to tabulate
storms <- storms %>% mutate(decade=floor(storms$year/10)*10) %>%
                     mutate(decade=paste(decade, "-", decade+9))

# Add flags for types of storms
storms <- storms %>% mutate(hurFlg=(status=="HU")) %>%
                     mutate(majorFlg=((hurFlg==1) & (wind>110)))

# Create a table of descriptive data by decade
# Exclude the 60s because it is not complete
table<- storms %>% filter(decade != "1960 - 1969") %>%
        group_by(decade) %>%
        summarize(count=n(), countHur=sum(hurFlg), 
                  countMajor=sum(majorFlg), avgWind=mean(wind)) %>%
        mutate(avgWind=round(avgWind))

# Output table
write.csv(table, "derived_data/decade_summary.csv")