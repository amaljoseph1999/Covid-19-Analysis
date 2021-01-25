library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(tidyverse)
library(magrittr)
library(leaflet)
library(plotly)
library(DT)
library(wbstats)
library(PerformanceAnalytics)


source("DownloadingFiles.R")
source("DataProcessing.R")
source("ui.R")
source("server.R")

# Run the application 
shinyApp(ui = ui, server = server) 
