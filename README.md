# Covid-19-Analysis
 



# Objective:
This project describes the comparison between covid-19 and weather on a certain period of time.
# Introduction:
This is an analysis report of the Novel Coronavirus (COVID-19) around the world, to demonstrate data processing and visualisation with R, tidyverse and ggplot2.
## What is a coronavirus?
The coronavirus family causes illnesses ranging from the common cold to more severe diseases such as severe acute respiratory syndrome (SARS) and Middle East respiratory syndrome (MERS), according to the WHO.
They circulate in animals and some can be transmitted between animals and humans. Several coronaviruses are circulating in animals that have not yet infected humans.
The new coronavirus, the seventh known to affect humans, has been named COVID-19.
## What are the symptoms?
Common signs of infection include fever, coughing and breathing difficulties. In severe cases, it can cause pneumonia, multiple organ failure and death.
The incubation period of COVID-19 is thought to be between one and 14 days. It is contagious before symptoms appear, which is why so many people get infected.
Infected patients can be also asymptomatic, meaning they do not display any symptoms despite having the virus in their systems.
## Where did it come from?
China alerted the WHO to cases of unusual pneumonia in Wuhan on December 31.
COVID-19 is thought to have originated in a seafood market where wildlife was sold illegally.
On February 7, Chinese researchers said the virus could have spread from an infected animal to humans through illegally trafficked pangolins, prized in Asia for food and medicine.
Scientists have pointed to either bats or snakes as possible sources. 
 

## Aim: 
The aim of this project is to visualize :
•	The impact of covid-19 on all the different countries of the world. 
•	The impact weather has on covid 19 and its correlation with covid-19. 
•	The impact of Covid-19 on India.

# Data Collection:
The data source used for this analysis is the 2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository built by the Center for Systems Science and Engineering, Johns Hopkins University. They are 3 csv files that are auto updated daily so that we can work with the current data and visualize it. These 3 csv files are downloaded and saved as local files and then are loaded into R.
## Loading Data:
![image](https://user-images.githubusercontent.com/40909273/124859053-c9639080-dfcc-11eb-883d-d74510d8ec9a.png)
 
 
 
Each dataset has 266 rows, corresponding to country/region/province/state. It has 150 columns. Starting from column 5, each column corresponds to a single day. Here we have a look at the first 10 rows and the first 10 columns.

# Packages Used:
 
### Shiny package-
Shiny is an R package that makes it easy to build interactive web apps straight from R. You can host standalone apps on a webpage or embed them in R Markdown documents or build dashboards.
### Shiny Dashboard package - 
shinydashboard is an R package whose job is to make it easier, as the name suggests, to build dashboards with Shiny.
### Dashboardthemes package -
Allows manual creation of themes and logos to be used in applications created using the 'shinydashboard' package. Removes the need to change the underlying css code by wrapping it into a set of convenient R functions.
### Tidyverse package –
This is a powerful package that allows us to wrangle, transform, import, manage and vizualize the data with the help of sub packages like dyplr, tidyr, tibble and ggplot2.
### Leaflet package – 
Leaflet is one of the most popular open-source libraries to make interactive maps. You can easily render spatial objects from the sp or sf packages, or data frames with latitude/longitude columns.
### Plotly package –
This package is an R package for creating interactive web-based graphs via the open source JavaScript graphing library plotly.js.
### DT package -
The R package DT provides an R interface to the JavaScript library DataTables. R data objects (matrices or data frames) can be displayed as tables on HTML pages, and DataTables provides filtering, pagination, sorting, and many other features in the tables.
### Wbstats package -
The wbstats R-package allows researchers to quickly search and download the data of their particular interest in a programmatic and reproducible fashion; this facilitates a seamless integration into their workflow and allows analysis to be quickly rerun on different areas of interest and with realtime access to the data as well.
### Hmisc package –
This package contains many functions useful for data analysis, high-level graphics, utility operations, functions for computing sample size and power, importing and annotating datasets, imputing missing values, advanced table making, variable clustering, character string manipulation, conversion of R objects to LaTeX and html code, and recoding variables.
### Reshape2 Package -
reshape2 is an R package written by Hadley Wickham that makes it easy to transform data between wide and long formats.
### Ggplot2 Package -
ggplot2 is a plotting package that makes it simple to create complex plots from data in a data frame. It provides a more programmatic interface for specifying what variables to plot, how they are displayed, and general visual properties. Therefore, we only need minimal changes if the underlying data change or if we decide to change from a bar plot to a scatterplot. This helps in creating publication quality plots with minimal amounts of adjustments and tweaking.

# Dashboard 
Our Covid-19 Dashboard has a side bar navigation orientation that consists of 5 tabs as you can see in the picture below:

![image](https://user-images.githubusercontent.com/40909273/124859279-40008e00-dfcd-11eb-9cd6-dcad0f562dab.png)


## Overview Tab
The above picture shows the Overview tab.
This tab consists of value boxes that shows the total confirmed, recovered, deceased and active cases of the world.  This tab also consists of a world map that depicts the total number of confirmed cases in every country. 

## Data Table
This tab consists of a Data table which summarizes all our datasets and shows us the most important columns that we took into consideration for our analysis and visualization. The Data Table consists of 15 columns and 190 rows.
This table also consists of a search bar through which you can type the name of a particular country and filter out the data for that country.
 
![image](https://user-images.githubusercontent.com/40909273/124859367-70482c80-dfcd-11eb-930d-801343220f59.png)




## Analysis Tab
This Tab consists of 6 different plots depicting the all the information contained in the data table. It consists of a select bar which lets you select any number of countries (with a default of 10) and shows you the visualized data of the countries selected.
![image](https://user-images.githubusercontent.com/40909273/124859485-ac7b8d00-dfcd-11eb-84f9-605454629299.png)
 
 ![image](https://user-images.githubusercontent.com/40909273/124859589-d46af080-dfcd-11eb-90ef-8b34e7e57fa6.png)
 
## Date Plot Tab

This tab consists of two date-range tabs, one start date and one end date, to select the time duration of the plots you want to see. This tab also contains a select tab to select the countries for which you want to see the visualizations.
 
![image](https://user-images.githubusercontent.com/40909273/124859792-20b63080-dfce-11eb-97ea-80c7e5031b23.png)
![image](https://user-images.githubusercontent.com/40909273/124859932-6bd04380-dfce-11eb-995e-14de92c4b374.png)


## Heatmap
 
This is a heatmap showing the correlation between covid-19 cases and weather factors. Red color (-1) shows strong negative correlation and Blue color (+1) shows strong positive correlation. From the colors in the heatmap we can say that new cases and temperature perfect negative correlation and specific humidity and relative humidity shows perfect positive correlation and for wind speed it shows weak negative correlation.

## Correlation Matrix
 
In this table we can see that the correlation coefficient of new cases and temperature is -0.82 at 0.01 level of significance and correlation coefficient for specific humidity and relative humidity with new cases are 0.81 and 0.80 respectively at 0.01 level of significance and the correlation between new cases and windspeed is 0.031. From the below correlation values we can say that the temperature and covid-19 cases have strong negative correlation whereas specific humidity and relative humidity have strong positive correlation with covid-19 cases. Wind speed shows no correlation at all.
The histogram shows how the data is distributed. The red line does not form a bell shaped curve which indicates that our data doesn’t follow normal distribution except wind speed.
From the scatter plot we can observe that the regression line goes from top left to bottom right for new cases vs temperature, which shows negative correlation. For both specific humidity and relative humidity with new cases the line goes from bottom left to top right which indicates positive correlation. For windspeed vs new cases, it is a horizontal line therefore shows no correlation.

![image](https://user-images.githubusercontent.com/40909273/124859686-f82e3680-dfcd-11eb-8c79-81f4bf4933d6.png)
