#!/usr/bin/env python
# coding: utf-8
import pandas as pd
from plotnine import *

# Read in derived data set 
tracks = pd.read_csv("derived_data/tracks.csv")

# Select only tracks for tropical cyclones
tracks=tracks[tracks['status'].isin(['TD','TS','HU'])]

# Calculate accumulated cyclone energy
# If the wind is 35 knots or higher take the square
tracks['wind2'] = tracks['wind'].apply(lambda x: x**2 if x >=35 else 0) 
tracks[tracks['storm_name']=='IVAN']

# Sum all squared winds over the year
ace=tracks.groupby('year', as_index=False).agg(ace=pd.NamedAgg(column='wind2',aggfunc=sum))

# Divide the sums by 10,000
ace['ace']=ace['ace']/10000
ace

# Make plot of ACE over time
plot=ggplot(ace, aes(x='year', y='ace')) + geom_line() +\
            labs(x="Year", y="Accumulated Cyclone Energy (ACE)")+\
            scale_x_continuous(breaks=range(1968,2019,5))+\
            theme(axis_text_x= element_text(family="serif", color='black',size=14),\
                  axis_text_y= element_text(family="serif", color='black',size=14),\
                  axis_title_x = element_text(family="serif",size=14),\
                  axis_title_y = element_text(family="serif",size=14))
t=theme_classic(base_family='serif')
t._rcParams.update({'font.serif':'Times New Roman'})
plot=plot+t

plot.save('figures/ace_time.png',width=10,height=5)

#Text for report
f = open("fragments/ace.fragment.Rmd", "w")
f.write("Another measure of storm intensity is called accumulated cyclone energy (ACE). For each storm the wind speed is measured at 6 hour intervals. The ACE is calculated for each storm by squaring the wind speed at each interval and summing the values where the storm was considered a tropical cyclone. The ACE can be calculated over a whole year by summing the ACE across storms. The resulting values are usually scaled by dividing by 10,000. Figure 4 shows the ACE by year. There does appear to be a trend for increasing ACE over time. This is further evidence that the intensity of storms has increased since 1968.\
        ![Accumulated Cylone Energy Over Time (1968-2019)](figures/ace_time.png)")
f.close()
