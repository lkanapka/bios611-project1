library(tidyverse)
library(lubridate)

# HURDAT2 is in a non-standard format and so we cannot use read_csv. 
# Each line must be read individually and split into columns. 
# The raw data is comma delimited. 
# Technique to read in data adapted from: 
# https://geanders.github.io/RProgrammingForResearch/entering-and-cleaning-data-3.html

dataRaw <- read_lines("source_data/hurdat2-1851-2019-052520.csv")

dataRaw <- purrr::map(dataRaw, str_split, pattern = ",", simplify = TRUE)
lineLengths <- map_int(dataRaw, length)
unique(lineLengths)

#The header rows have length 4 and and the data rows have length 21
headers <- dataRaw[lineLengths == 4]
obs <- dataRaw[lineLengths == 21]

# Convert to dataframe
headers <- headers %>% 
  purrr::map(as_tibble) %>% 
  bind_rows()

# Remove column 4 as it all missing, rename columns, and remove whitespace  
unique(headers$V4)
headers <- headers %>%
  select(-V4) %>%
  rename(storm_id = V1, storm_name = V2, n_obs = V3) %>%
  mutate(storm_name = str_trim(storm_name),
         n_obs = as.numeric(n_obs))

# The n_obs column tells you how many rows in obs are associated with this 
# storm_id
storm_id <- rep(headers$storm_id, times = headers$n_obs)

# Convert the obs data to a dataframe and merge with storm_id
tracks <- obs %>% 
  purrr::map(as_tibble) %>% 
  bind_rows() %>%
  select(V1:V8) %>%
  rename(date=V1, time=V2, event=V3, status=V4, latitude=V5, longitude=V6, 
         wind=V7, pressure=V8) %>%
  mutate(storm_id = storm_id, 
         wind=as.numeric(wind), 
         pressure=as.numeric(pressure),
         status= str_trim(status),
         event=str_trim(event), 
         datetime=as.POSIXct(paste(date, time), format="%Y%m%d%H%M"),
         year=year(datetime)) %>%
  select(-date, -time) 

# Get storm name 
tracks <- tracks %>% 
  inner_join(headers[,-3], by="storm_id") %>%
  relocate(storm_id, storm_name, datetime)

# Only consider storms after 1967
tracks <- tracks %>% filter(year>1967)

# Create data set that has only one record per storm with the first time 
# that it reaches its maximum wind speed.
maxWind <- tracks %>%
  group_by(storm_id) %>%
  summarize(maxWind=max(wind))

tracks <- tracks %>% 
  inner_join(maxWind, by="storm_id") 

storms <- tracks %>%
  filter(wind==maxWind) %>%
  group_by(storm_id) %>%
  slice(1)

storms <- storms %>% mutate(cycloneFlg=(status %in% c("TD", "TS","HU"))) %>%
  mutate(hurFlg=(status=="HU")) %>%
  mutate(majorFlg=((hurFlg==1) & (wind>110)))

# Replace -99 with missing 
storms$wind[storms$wind==-99]<-NA 

# Create a variable for decade to make it easier to tabulate
storms <- storms %>% mutate(decade=floor(year/10)*10) %>%
  mutate(decade=paste(decade, "-", decade+9, sep=""))

# Output cleaned data 
write.csv(tracks, "derived_data/tracks.csv")
write.csv(storms, "derived_data/storms.csv")


