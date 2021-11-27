
# the data comes from the sau_prep_for_shiny.R

#rm(list = ls())
# library(tidyverse)
# #install.packages(c("sf", "rnaturalearth", "rnaturalearthdata"))
# library("sf")
# library("viridis")

# In order to launch, it is necessary to have the data


library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(ggplot2)
library(viridis)
library(sf)
library(profvis)



load("data/sea_around_us_data_for_shiny.RData")

ui <- dashboardPage(
  dashboardHeader(title = "Indonesia"),
    
    dashboardSidebar(sidebarMenu(
    id = "sidebarid",
    menuItem("Select", tabName = "Select"),
    conditionalPanel(
      "Select 2",
      selectInput("sector", "Sector:",
                  choices = c("Artisanal", "Industrial", "Recreational", "Subsistence"), width = '98%'),
      selectInput("report", "Report Status:",
                  choices = c("Reported", "Unreported"), width = '98%'),
      
      sliderInput("year", "Year:",
                  min = 1990, max = 2018, value= 1990, 
                  width = '98%')
    )
  ) 
),
  
  dashboardBody(
    fillPage(
      tags$style(type = "text/css", "#Waterfall {height: calc(100vh - 80px) !important;}"),
      plotOutput("Indonesia", height="100%", width="100%"))
  )
)



server <- function(input, output) {
  
  # Reactive expression to create data frame of all input values ----
  sliderValues <- reactive({
    
    data.frame(
      Name = c("year",
      ),
      Value = as.character(c(input$year)),
      stringsAsFactors = FALSE)
    
  })
  
  # Show the values in an HTML table ----
  
  output$Indonesia <- renderPlot({
    
    x    <- input$year
    
   
    ggplot(data=ap, alpha=95) + geom_sf()+ geom_sf(data=indo)+
      geom_sf(data=indo_sau_data[indo_sau_data$year==x & indo_sau_data$reporting_status==as.character(input$report) & indo_sau_data$sector==as.character(input$sector),], color = 'grey', alpha=95, aes(fill=(sum))) +
      scale_fill_viridis(option="magma", name="Tonnes")+ggtitle(paste(as.character(x),as.character(input$report), as.character(input$sector)))
   
    
  }, height=900, width=1100)  #
}

shinyApp(ui, server)


