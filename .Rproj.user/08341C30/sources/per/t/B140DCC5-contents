library(shiny)
library(shinydashboard)


#dataset files
DownloadCovidData <- function()
{
  #getwd()
  download.file(
    url      = "https://github.com/CSSEGISandData/COVID-19/archive/master.zip",
    destfile = "data/covid19JHU.zip"
  )
  
  data_path <- "COVID-19-master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_"
  unzip(
    zipfile   = "data/covid19JHU.zip",  
    files     = paste0(data_path, c("confirmed_global.csv", "deaths_global.csv", "recovered_global.csv")),
    exdir     = "data",
    junkpaths = T
  )
  
}

#update function updates the data after a certain time stamp
UpdateCovidData <- function() {
  
  cur_time <- Sys.time()
  file_time <- file.info("data/covid19JHU.zip")$mtime
  time_diff <- difftime(cur_time, file_time, units = "hours") 
  
  if (!dir.exists("data")) {
    dir.create('data')
    DownloadCovidData()
  } else if ((!file.exists("data/covid19JHU.zip")) || (time_diff > 12)) {
    DownloadCovidData()
  }
}

#update with start of app
UpdateCovidData()

#reading downloaded files
data_confirmed <- read.csv("data/time_series_covid19_confirmed_global.csv")
data_deceased  <- read.csv("data/time_series_covid19_deaths_global.csv")
data_recovered <- read.csv("data/time_series_covid19_recovered_global.csv")




