#---------------------------------------------------------DASH BOARD-----------------------------------------------------
# Define UI for application that draws a histogram


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
    menuItem("Data Table", icon = icon("file-alt"), tabName = "datatable"),
    menuItem("Analysis", icon = icon("th"), tabName = "analysis" ),
    menuSubItem("Plots", icon = icon("th"), tabName = "plots"),
    menuItem("Correlation", icon = icon("file"), tabName = "correlation")
  ),
  width = 180)

#----------------------------------------------------DASHBOARD BODY---------------------------------------------------------
body <- dashboardBody(
                      tags$head(
                          tags$style(HTML('.content-wrapper,.right-side{background-color:#c4c4c4}'))
                      ), 
                      
                      shinyDashboardThemes(
                        theme = "blue_gradient"
                      ),
                      
                      tabItems(
                        tabItem(tabName = "overview", 
                                fluidRow(
                                  valueBoxOutput("rate",width = 3),
                                  valueBoxOutput("rate1",width = 3),
                                  valueBoxOutput("rate2",width = 3),
                                  valueBoxOutput("rate3",width = 3)
                                ),
                                fluidRow(leafletOutput("mapp")),
                                fluidRow(
                                  HTML(
                                    '<html>
                                      <head>
                                      <h5><u> About COVID-19</u></h5>
                                      </head>
                                      <p>  Coronavirus disease (COVID-19) is an infectious disease caused by a newly discovered coronavirus. 
                                      <br>  Most people infected with the COVID-19 virus will experience mild to moderate respiratory illness and recover without requiring special treatment. Older people, and those with underlying medical problems like cardiovascular disease, diabetes, chronic respiratory disease, and cancer are more likely to develop serious illness. 
                                      <br>  The best way to prevent and slow down transmission is to be well informed about the COVID-19 virus, the disease it causes and how it spreads. Protect yourself and others from infection by washing your hands or using an alcohol based rub frequently and not touching your face. 
                                      <br>  The COVID-19 virus spreads primarily through droplets of saliva or discharge from the nose when an infected person coughs or sneezes, so it is important that you also practice respiratory etiquette (for example, by coughing into a flexed elbow).
                                      </p>
                                     
                                    </html>'
                        
                                  )
                                )
                      ),
                      
                      tabItem(tabName = "datatable",
                                fluidRow(
                                    dataTableOutput("fullTable")
                                )
                      ),
                      
                      tabItem(tabName = "analysis",
                              fluidRow(
                                box(width=6,
                                    title = "Countries", solidHeader = TRUE, status = "primary",
                                    background = "blue",
                                    uiOutput("selectize_casesByCountries")
                                )
                              ),
                              
                              fluidRow(
                                column(width = 12,
                                       
                                       box(width = 6, 
                                           title = "Countries with New Confirmed Cases", solidHeader = TRUE, status = "warning",
                                           plotOutput("Plot_Confirmed")
                                       ),       
                                       box(width = 6,
                                           title = "Countries with Recovered Cases", solidHeader = TRUE, status = "primary",
                                           plotOutput("Plot_Recovered")
                                       )
                                ),
                                column(width = 12,
                                       
                                       box(width =6,
                                           title = "Countries with Deceased Cases", solidHeader = TRUE, status = "danger",
                                           plotOutput("Plot_Deceased")
                                       ),
                                       box(width=6,
                                           title = "Countries with Active Cases", solidHeader = TRUE, status = "success",
                                           plotOutput("Plot_Active")
                                       )
                                       
                                ),
                                column(width = 12,
                                    
                                       box(width = 12, 
                                           sliderInput(inputId = "bins",
                                                                   label = "Number of Countries:",
                                                                   min = 1,
                                                                   max = 30,
                                                                   value = 10),
                                          plotOutput("plot_population")
                                       )
                                ),
                                column(width = 12,
                                       
                                       box(width = 12,
                                           sliderInput(inputId = "bins2",
                                                       label = "Number of Countries:",
                                                       min = 1,
                                                       max = 30,
                                                       value = 10),
                                           
                                           
                                           plotOutput("plot_deathvscases")
                                       )
                                )
                              )
                      ),
                      tabItem(tabName = "plots",
                              fluidRow(),
                              fluidRow(
                                column(width = 12,
                                       
                                       box(width = 4, solidHeader = TRUE, status = "primary",
                                           dateInput("start_date",
                                                     h5("Start Date"),
                                                     format = "yyyy-mm-dd",
                                                     value="2020-03-01",
                                                     min="2020-01-01",
                                                     max="2020-12-1")
                                           
                                       ),       
                                       box(width = 4, solidHeader = TRUE, status = "primary",
                                           dateInput("end_date",
                                                     h5("End Date"),
                                                     format="yyyy-mm-dd",
                                                     value="2020-07-30",
                                                     min="2020-01-01",
                                                     max="2020-12-1")
                                           
                                           
                                       ),
                                       box(width = 4, title = "Select Countries",solidHeader = TRUE, status = "primary",
                                           uiOutput("casesByCountries")
                                           
                                           
                                       )
                                )
                              ),
                              
                              fluidRow(box(width=12,title="Confirmed Cases:", color="red" , title_side="top right",column(width = 12, plotOutput("plot_conf",width = "100%",height = "400px")))),
                              fluidRow(box(width=12,title="Recovered Cases:", color="green" , title_side="top right",column(width = 12, plotOutput("plot_dece",width = "100%",height = "400px")))),
                              fluidRow(box(width=12,title="Active Cases:", color="blue" , title_side="top right",column(width = 12, plotOutput("plot_reco",width = "100%",height = "400px")))),
                              
                              fluidRow(box(width=6, title = "Select Countries for Line Plot", status = "primary", solidHeader = TRUE,
                                           uiOutput("selectize_forline"))),
                              fluidRow(box(width = 12, status = "primary", height = "400px",
                                           plotOutput("linechart")))
                      ),
                      
                      #Tab for correlation
                      tabItem(tabName = "correlation",
                              
                              mainPanel(                                  
                                    
                                h5("Correlation Between Covid-19 and Weather"),
                                
                                tabsetPanel( 
                                  tabPanel("Heatmap", plotOutput("Heatmap", width = "100%")),
                                  tabPanel("Correlation Matrix", plotOutput("CorrelationMatrix", width = "100%"))
                                  

                                )
                              )
                      )
                    )
)


header <- dashboardHeader(
  title = "COVID-19"
  
  
)


# Put them together into a dashboardPage

ui<-dashboardPage( 
                  header,
                  sidebar,
                  body
)
