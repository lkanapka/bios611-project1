library(tidyverse)
library(shiny)
library(leaflet)
library(bamlss)

# Read in cleaned data
storms <- read_csv("derived_data/storms.csv")
tracks <- read_csv("derived_data/tracks.csv")

# -99 is dummy value for missing
storms$maxWind[storms$maxWind==-99]<-NA

# Convert lat and long to numeric

# If latitude direction is N it should be positive, S should be negative
tracks <- tracks %>% mutate(latitudeDir=substr(latitude,nchar(latitude),
                                               nchar(latitude))) %>%
                     mutate(latitude=as.numeric(substr(latitude,1,
                                                       nchar(latitude)-1))*
                                     ifelse(latitudeDir=="N",1,-1))

# If longitude direction is E it should be positive, W it should be negative
tracks <- tracks %>% mutate(longitudeDir=substr(longitude,nchar(longitude),
                                                nchar(longitude))) %>%
                     mutate(longitude=as.numeric(substr(longitude,1,
                                                        nchar(longitude)-1))*
                                      ifelse(longitudeDir=="E",1,-1))

# Create a list of storm latitudes
latitude<-list()
for(i in 1:nrow(storms)){
  latitude[[i]]<- tracks$latitude[tracks$storm_id==storms$storm_id[i]]
  names(latitude)[i]<-storms$storm_id[i]
}

#Create a list of storm longitudes
longitude<-list()
for(i in 1:nrow(storms)){
  longitude[[i]]<- tracks$longitude[tracks$storm_id==storms$storm_id[i]]
  names(longitude)[i]<-storms$storm_id[i]
}

#Get the start time of the storm
start<- tracks %>% arrange(datetime) %>% 
                   group_by(storm_id) %>% 
                   slice(1) %>% 
                   select(storm_id, datetime)%>%
                   rename(start=datetime)

storms <- storms %>% inner_join(start, by="storm_id") 

#Get the end time of the storm
end<- tracks %>%  arrange(datetime) %>%
                  group_by(storm_id) %>% 
                  slice_tail() %>% 
                  select(storm_id, datetime)%>%
                  rename(end=datetime)

storms <- storms %>% inner_join(end, by="storm_id")

# Add color based on max wind speed
colorPal<- rev(heat.colors(16))
storms$color <- colorPal[cut(storms$maxWind, breaks = c(0,30,40,50,60,70,80,
                             90,100,110,120,130,140,150,160,170,999))]


# Get the port number from the command line arguments 
args <- commandArgs(trailingOnly=T);

port <- as.numeric(args[[1]]);


# Define UI for shiny app 
ui <- fluidPage(
  
  # Title
  titlePanel("Atlantic Storms by Year (1968-2019)"),
  column(7,
         # Slider for year
         column(8, wellPanel(sliderInput(inputId = "year",label = "Year",
                                         min = 1968, max = 2019, value = 2000, 
                                         sep="", width="100%"),
                             style="margin-left:-15px;")),
         # Radio buttons for a storm type filter
         column(4, wellPanel(radioButtons(inputId="type", label="Filter",
                                          choices=c("All storms","Hurricanes", 
                                                    "Major hurricanes")), 
                             style="padding-bottom:9px;margin-right:-15px")),
         # Map with storm tracks
         leafletOutput("map"),
         
         # Legend for track colors 
         plotOutput("legend",height="100px")),
  
  # Gantt chart of storms 
  column(5, plotOutput("gantt", height="650px"))     
         
)

server <- function(input, output) {
  
  # Create map with storm tracks from the input year 
  output$map <- renderLeaflet({
    
    # Initialize the map centered on a point in the Atlantic
    myMap = leaflet() %>% setView(lng=-46.490182, lat=31.995865, zoom=3)%>% 
                          addTiles()
    
    # Add each track from the selected year
    for(i in 1:nrow(storms)){
      if(storms$year[i]==input$year){
        # If "all storms" is selected add the tracks from all storms
        if(input$type=="All storms"){
          myMap <- myMap %>% addPolylines(lat=latitude[[i]], lng=longitude[[i]], 
                                        weight=2, color=storms$color[i], 
                                        opacity=0.7)
        }
        
        # If "hurricanes" selected, only add tracks for hurricanes
        if((input$type=="Hurricanes") & (storms$hurFlg[i]==1)){
          myMap <- myMap %>% addPolylines(lat=latitude[[i]], lng=longitude[[i]], 
                                          weight=2, color=storms$color[i], 
                                          opacity=0.7)
        }
        
        # If "major hurricanes" selected, only add tracks for major hurricanes
        if((input$type=="Major hurricanes") & (storms$majorFlg[i]==1)){
          myMap <- myMap %>% addPolylines(lat=latitude[[i]], lng=longitude[[i]], 
                                          weight=2, color=storms$color[i], 
                                          opacity=0.7)
        }
      }
    }
    
    myMap
  })
  
  # Create legend
  output$legend<-renderPlot({
    par(mar=c(0,0,0,0))
    colorlegend(color=colorPal,range=c(20,170),at=c(20,50,80,110,140,170),
                digits=0, height=0.1, width=0.8, 
                breaks=c(0,30,40,50,60,70,80,90,100,110,120,130,140,150,
                         160,170,999),
                title="Maximum Windspeed (knots)")
  })
  
  #Create gantt chart of storms from the selected year
  output$gantt<-renderPlot({
    
    #First filter data to the selection
    filteredData <- storms %>% filter(year==input$year)
    if(input$type=="Hurricanes"){
      filteredData <- filteredData %>% filter(hurFlg==1)
    }
    if(input$type=="Major hurricanes"){
      filteredData <- filteredData %>% filter(majorFlg==1)
    }
    
    # Generate gantt chart
    ggplot(filteredData, 
           aes(x=start, xend=end, y=storm_id, yend=storm_id)) +
      theme_bw()+ 
      geom_segment(size=8,color=filteredData$color) + 
      labs(x='Month', y=NULL,title=paste0("Gantt Chart of Storms in ",input$year))+
      scale_y_discrete(labels= rev(filteredData$storm_name), 
                       limits = rev(filteredData$storm_id))+
      theme(plot.title = element_text(hjust = 0.5, size=18))
    
  })
}

# Start shiny on the specified port 
port<-8788
print(sprintf("Starting shiny on port %d", port))
shinyApp(ui = ui, server = server, options = list(port=port, host="0.0.0.0"))







