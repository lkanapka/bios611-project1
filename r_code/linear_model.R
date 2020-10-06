library(tidyverse)

# Read in data
storms <- read_csv("derived_data/storms.csv")

# Code to fit linear regression models and save p-values

# Create empty p-values data set
pVal <- c("P-value for Time", NA, NA, NA, NA, NA)

# Number of storms over time
countYr<- storms %>% group_by(year) %>%
          summarize(count=n(),countCyclone=sum(cycloneFlg), 
                    countHur=sum(hurFlg), countMajor=sum(majorFlg),
                    meanWind=mean(wind))
countYr$time<- countYr$year-1968
modelA <- lm(count ~ time, data=countYr)
modelASum<-summary(modelA)
pVal[2]<- as.character(round(modelASum$coefficients[2,4], 2))

# Number of cyclones over time
modelB <- lm(countCyclone ~ time, data=countYr)
modelBSum<-summary(modelB)
pVal[3]<- as.character(round(modelBSum$coefficients[2,4], 2))

# Number of hurricanes over time
modelC <- lm(countHur ~ time, data=countYr)
modelCSum<-summary(modelC)
pVal[4]<- as.character(round(modelCSum$coefficients[2,4], 3))

# Number of major hurricanes over time
modelD <- lm(countMajor ~ time, data=countYr)
modelDSum<-summary(modelD)
pVal[5]<- as.character(round(modelDSum$coefficients[2,4], 3))

# Average wind speed over time
modelE <- lm(meanWind ~ time, data=countYr)
modelESum <- summary(modelE)
pVal[6]<- "<0.001"

# Output p-values to derived data
write.csv(pVal, "derived_data/pValues.csv", row.names = F)