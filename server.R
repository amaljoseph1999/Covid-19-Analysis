#----------------------------------------SERVER------------------------------------------------------#
library(leaflet)

server <- function(input, output) 
{
  
  #TABLE DATA-------------------------------------------------------------------------
  
  getFullTableData1 <- function(groupBy) {
    padding_left <- max(str_length(data_evolution$value_new), na.rm = TRUE)
    data12         <- data_evolution %>%
      filter(date == current_date) %>%
      pivot_wider(names_from = var, values_from = c(value, value_new)) %>%
      select(-date, -Lat, -Long) %>%
      add_row(
        "Province/State"      = "World",
        "Country/Region"      = "World",
        "population"          = 7800000000,
        "value_confirmed"     = sum(.$value_confirmed, na.rm = T),
        "value_new_confirmed" = sum(.$value_new_confirmed, na.rm = T),
        "value_recovered"     = sum(.$value_recovered, na.rm = T),
        "value_new_recovered" = sum(.$value_new_recovered, na.rm = T),
        "value_deceased"      = sum(.$value_deceased, na.rm = T),
        "value_new_deceased"  = sum(.$value_new_deceased, na.rm = T),
        "value_active"        = sum(.$value_active, na.rm = T),
        "value_new_active"    = sum(.$value_new_active, na.rm = T)
      ) %>%
      group_by(!!sym(groupBy)) %>%
      summarise(
        confirmed_total     = sum(value_confirmed, na.rm = T),
        confirmed_new       = sum(value_new_confirmed, na.rm = T),
        confirmed_totalNorm = round(sum(value_confirmed, na.rm = T) / max(population,na.rm = T) * 100000, 0),
        recovered_total     = sum(value_recovered, na.rm = T),
        recovered_new       = sum(value_new_recovered, na.rm = T),
        deceased_total      = sum(value_deceased, na.rm = T),
        deceased_new        = sum(value_new_deceased, na.rm = T),
        active_total        = sum(value_active, na.rm = T),
        active_new          = sum(value_new_active, na.rm = T),
        active_totalNorm    = round(sum(value_active, na.rm = T) / max(population,na.rm = T) * 100000, 0)
      ) %>%
      mutate(
        "confirmed_newPer" = confirmed_new / (confirmed_total - confirmed_new) * 100,
        "recovered_newPer" = recovered_new / (recovered_total - recovered_new) * 100,
        "deceased_newPer"  = deceased_new / (deceased_total - deceased_new) * 100,
        "active_newPer"    = active_new / (active_total - active_new) * 100
      ) %>%
      mutate_at(vars(contains('_newPer')), list(~na_if(., Inf))) %>%
      mutate_at(vars(contains('_newPer')), list(~na_if(., 0))) %>%
      mutate(
        confirmed_new = str_c(str_pad(confirmed_new, width = padding_left, side = "left", pad = "0"), "|",
                              confirmed_new, if_else(!is.na(confirmed_newPer), sprintf(" (%+.2f %%)", confirmed_newPer), "")),
        recovered_new = str_c(str_pad(recovered_new, width = padding_left, side = "left", pad = "0"), "|",
                              recovered_new, if_else(!is.na(recovered_newPer), sprintf(" (%+.2f %%)", recovered_newPer), "")),
        deceased_new  = str_c(str_pad(deceased_new, width = padding_left, side = "left", pad = "0"), "|",
                              deceased_new, if_else(!is.na(deceased_newPer), sprintf(" (%+.2f %%)", deceased_newPer), "")),
        active_new    = str_c(str_pad(active_new, width = padding_left, side = "left", pad = "0"), "|",
                              active_new, if_else(!is.na(active_newPer), sprintf(" (%+.2f %%)", active_newPer), ""))
      ) %>%
      
      as.data.frame()
  }
  #------------------------------------------------------------------------------ ----------------------------- 
  
  output$fullTable <- renderDataTable({
    data12       <- getFullTableData1("Country/Region")
    columNames <- c(
      "Country",
      "Total Confirmed",
      "New Confirmed",
      "Total Confirmed <br>(per 100k)",
      "Total Estimated Recoveries",
      "New Estimated Recoveries",
      "Total Deceased",
      "New Deceased",
      "Total Active",
      "New Active",
      "Total Active <br>(per 100k)")
    datatable(
      data12,
      rownames  = FALSE,
      colnames  = columNames,
      escape    = FALSE,
      selection = "none",
      options   = list(
        pageLength     = -1,
        order          = list(8, "desc"),
        scrollX        = TRUE,
        scrollY        = "calc(100vh - 250px)",
        scrollCollapse = TRUE,
        dom            = "ft",
        server         = FALSE,
        columnDefs     = list(
          list(
            targets = c(2, 5, 7, 9),
            render  = JS(
              "function(data12, type, row, meta) {
              if (data12 != null) {
                split = data12.split('|')
                if (type == 'display') {
                  return split[1];
                } else {
                  return split[0];
                }
              }
            }"
            )
          ),
          list(className = 'dt-right', targets = 1:ncol(data12) - 1),
          list(width = '100px', targets = 0),
          list(visible = FALSE, targets = 11:14)
        )
      )
    ) %>%
      formatStyle(
        columns    = "Country/Region",
        fontWeight = "bold"
      ) %>%
      formatStyle(
        columns         = "confirmed_new",
        valueColumns    = "confirmed_newPer",
        backgroundColor = styleInterval(c(10, 20, 33, 50, 75), c("NULL", "#FFE5E5", "#FFB2B2", "#FF7F7F", "#FF4C4C", "#983232")),
        color           = styleInterval(75, c("#000000", "#FFFFFF"))
      ) %>%
      formatStyle(
        columns         = "deceased_new",
        valueColumns    = "deceased_newPer",
        backgroundColor = styleInterval(c(10, 20, 33, 50, 75), c("NULL", "#FFE5E5", "#FFB2B2", "#FF7F7F", "#FF4C4C", "#983232")),
        color           = styleInterval(75, c("#000000", "#FFFFFF"))
      ) %>%
      formatStyle(
        columns         = "active_new",
        valueColumns    = "active_newPer",
        backgroundColor = styleInterval(c(-33, -20, -10, 10, 20, 33, 50, 75), c("#66B066", "#99CA99", "#CCE4CC", "NULL", "#FFE5E5", "#FFB2B2", "#FF7F7F", "#FF4C4C", "#983232")),
        color           = styleInterval(75, c("#000000", "#FFFFFF"))
      ) %>%
      formatStyle(
        columns         = "recovered_new",
        valueColumns    = "recovered_newPer",
        backgroundColor = styleInterval(c(10, 20, 33), c("NULL", "#CCE4CC", "#99CA99", "#66B066"))
      )
  })
  
  
  #MAP------------------------------------------------------
  
  output$mapp <- renderLeaflet({
    
    
    Day <- data_confirmed_sub
    Day<-Day %>% 
      mutate(popup_Info=paste(h5(`Country/Region`), "Confirmed: ", confirmed))
    
    leaflet() %>% 
      setMaxBounds(-180, -90, 180, 90) %>%
      setView(0, 20, zoom = 2) %>%
      addTiles() %>% 
      addCircleMarkers(data=Day, lat=~Lat, lng =~Long, 
                       radius = 0.03 * sqrt(Day$confirmed),
                       color = "#E0695F",
                        popup = ~popup_Info, 
                       stroke       = FALSE,
                       fillOpacity  = 0.01,
                       ) %>%
      addProviderTiles(providers$CartoDB.Positron, group = "Light") %>%
      addProviderTiles(providers$HERE.satelliteDay, group = "Satellite") %>%
      addLayersControl(
        baseGroups = c("Light", "Satellite"),
      ) %>%
      addEasyButton(easyButton(
        icon    = "glyphicon glyphicon-globe", title = "Reset zoom",
        onClick = JS("function(btn, map){ map.setView([20, 0], 2); }")))
    
  })
  
  
  #VALUE BOX----------------------------------------------------
  
  output$rate <- renderValueBox({
    cur_dat=Sys.Date()-1
    
    valueBox(
      value = data_evolution %>% filter(data_evolution$date==cur_dat,data_evolution$var=="confirmed") %>% select(value_new) %>% sum(na.rm=TRUE),
      subtitle = "Confirmed Cases",
      icon = icon("area-chart"),width = 2,
      color = "yellow"
    )
  })
  output$rate1<- renderValueBox({
    
    cur_dat=Sys.Date()-1
    valueBox(
      value = data_evolution %>% filter(data_evolution$date==cur_dat,data_evolution$var=="recovered") %>% select(value_new) %>% sum(na.rm=TRUE),
      subtitle = "Recovered Cases",
      icon = icon("angle-double-down"),width = 2,
      color = "blue"
    )
  })
  output$rate2 <- renderValueBox({
    
    cur_dat=Sys.Date()-1
    valueBox(
      value = data_evolution %>% filter(data_evolution$date==cur_dat,data_evolution$var=="deceased") %>% select(value_new) %>% sum(na.rm=TRUE),
      subtitle = "Deceased",
      icon = icon("angle-double-up"),width = 2,
      color = "red"
    )
  })
  output$rate3 <- renderValueBox({
    
    cur_dat=Sys.Date()-1
    valueBox(
      value = data_evolution %>% filter(data_evolution$date==cur_dat,data_evolution$var=="active") %>% select(value) %>% sum(na.rm=TRUE),
      subtitle = "Active Cases",
      icon = icon("bed"),width = 2,
      color = "green"
    )
  })
  

  
  #ANALYSIS TAB PLOTS---------------------------------------------
  
  output$Plot_Confirmed <- renderPlot({
    data <- data_evolution %>%
      filter(date == current_date) %>% filter(`Country/Region` %in% input$caseEvolution_country)   %>%
      pivot_wider(names_from = var, values_from = c(value, value_new))
    data %>% 
      group_by(`Country/Region`) %>% 
      filter(date >'2020-02-22') %>% 
      summarise(confirmed = sum(value_new_confirmed)) %>% 
      arrange(desc(confirmed)) %>% 
      head(10) %>% 
      ggplot(mapping = aes(x = reorder(`Country/Region`, -confirmed), y = confirmed)) +
      geom_bar(stat = "identity", width = 0.4, fill = "#EC7063") +
      labs(x = "Countries", y = "Confirmed Cases") +
      theme(axis.title = element_text(size = 15)) +
      geom_label(aes(y = confirmed, label = confirmed %>% scales::comma()), size = 3.5, vjust = 0.5)
    
  })
  

  output$Plot_Recovered <- renderPlot({
    
    data <- data_evolution %>%
      filter(date == current_date) %>%
      pivot_wider(names_from = var, values_from = c(value, value_new))
    data %>% 
      group_by(`Country/Region`) %>% 
      filter(date >'2020-02-22') %>% filter(`Country/Region` %in% input$caseEvolution_country)   %>%
      summarise(confirmed = sum(value_new_recovered)) %>% 
      arrange(desc(confirmed)) %>% 
      head(10) %>% 
      ggplot(aes(x = reorder(`Country/Region`, -confirmed), y = confirmed)) +
      geom_bar(fill="#76D7C4", stat = "identity", width = 0.4) +
      labs(x = "Countries", y = "Recovered Cases") +
      geom_label(aes(y = confirmed, label = confirmed %>% scales::comma()), size = 3.5, vjust = 0.5)
    
  })
  
  
  output$Plot_Deceased <- renderPlot({
    
    data <- data_evolution %>%
      filter(date == current_date) %>%
      pivot_wider(names_from = var, values_from = c(value, value_new))
    data %>% 
      group_by(`Country/Region`) %>% 
      filter(date >'2020-02-22') %>% filter(`Country/Region` %in% input$caseEvolution_country)   %>%
      summarise(confirmed = sum(value_new_deceased)) %>% 
      arrange(desc(confirmed)) %>% 
      head(10) %>% 
      ggplot(aes(x = reorder(`Country/Region`, -confirmed), y = confirmed)) +
      geom_bar(stat = "identity", width = 0.4, fill = "#FF5733") +
      labs(x = "Countries", y = "Deceased Cases") +
      geom_label(aes(y = confirmed, label = confirmed %>% scales::comma()), size = 3.5, vjust = 0.5)
    
  })
  
  
  output$Plot_Active <- renderPlot({
    
    data <- data_evolution %>%
      filter(date == current_date) %>%
      pivot_wider(names_from = var, values_from = c(value, value_new))
    data %>% 
      group_by(`Country/Region`) %>% 
      filter(date >'2020-02-22') %>% filter(`Country/Region` %in% input$caseEvolution_country)   %>%
      summarise(confirmed = sum(value_active)) %>% 
      arrange(desc(confirmed)) %>% 
      head(10) %>% 
      ggplot(aes(x = reorder(`Country/Region`, -confirmed), y = confirmed)) +
      geom_bar(stat = "identity", width = 0.4, fill = "#2ECC71") +
      labs(x = "Countries", y = "Active Cases") +
      geom_label(aes(y = confirmed, label = confirmed %>% scales::comma()), size = 3.5, vjust = 0.5)
    
  })
  
  
  output$selectize_casesByCountries <- renderUI({
    selectizeInput(
      "caseEvolution_country",
      label    = "Select Countries",
      choices  = unique(data_evolution$`Country/Region`),
      multiple = TRUE,
      selected =  top10_countries
    )
  
  })
  
  top10_countries <- data_evolution %>%
    filter(var == "active", date == current_date) %>%
    group_by(`Country/Region`) %>%
    summarise(value = sum(value, na.rm = T)) %>%
    arrange(desc(value)) %>%
    top_n(10) %>%
    select(`Country/Region`) %>%
    pull() 
  

  #HEATMAP--------------------------------------------
  
  output$Heatmap <- renderPlot(
    
    source("correlation_new.R", local = TRUE)
    
  )
  
  output$CorrelationMatrix <- renderPlot(
    
    chart.Correlation(data_weather,histogram=TRUE,method="spearman")
    
  )
  
  
  
  #DATE PLOTS-----------------------------------------

  output$plot_conf<-renderPlot({
    
    x<-data_confirmed_sub    
    x$date=strptime(x$date, "%m/%d/%y")
    x$date<-as.Date(x$date, "%m/%d/%Y")
    a<-x %>% filter(`Country/Region`==input$caseEvolution_country1)
    a<-a %>% filter(date>input$start_date & date<input$end_date)
    
    ggplot(a, aes(x =date , y = confirmed)) +
      geom_area(fill="yellow",
               
               stat = "identity", position = position_stack()
      )+ggtitle(paste("Country :",input$caseEvolution_country1)) 
    
  })
  
  output$plot_dece<-renderPlot({
    
    x<-data_deceased_sub    
    x$date=strptime(x$date, "%m/%d/%y")
    x$date<-as.Date(x$date, "%m/%d/%Y")
    a<-x %>% filter(`Country/Region`==input$caseEvolution_country1)
    a<-a %>% filter(date>input$start_date & date<input$end_date)
    
    ggplot(a, aes(x =date , y = deceased)) +
      geom_area(fill="#E7B800",
               
               stat = "identity", position = position_stack()
      )+ggtitle(paste("Country :",input$caseEvolution_country1)) 
  })
  
  
  output$plot_reco<-renderPlot({
    
    x<-data_recovered_sub    
    x$date=strptime(x$date, "%m/%d/%y")
    x$date<-as.Date(x$date, "%m/%d/%Y")
    a<-x %>% filter(`Country/Region`==input$caseEvolution_country1)
    a<-a %>% filter(date>input$start_date & date<input$end_date)
    
    ggplot(a, aes(x =date , y = recovered)) +
      geom_area(fill="#00AFBB",
               
               stat = "identity", position = position_stack()
      )+ggtitle(paste("Country :",input$caseEvolution_country1)) 
  })
  
  output$casesByCountries <- renderUI({
    selectizeInput(
      "caseEvolution_country1",
      label    = "Countries",
      choices  = unique(data_evolution$`Country/Region`),
      selected="US",
      multiple = FALSE
    )
    
   })
  
  
  #TOTAL CASES vs TOTAL DEATHS (per 100K)-------
  output$plot_population<-renderPlot({
    
    top5_countries <- data_evolution %>%
      filter(var == "active", date == current_date) %>%
      group_by(`Country/Region`) %>%
      summarise(value = sum(value, na.rm = T)) %>%
      arrange(desc(value)) %>%
      top_n(input$bins) %>%
      select(`Country/Region`) %>%
      pull() 
    data1<-filter(data12,data12$`Country/Region` %in% top5_countries)
    

    ggplot(data1, aes(x =`Country/Region` , y = confirmed_totalNorm, fill = data1$`Country/Region` )) +
      geom_bar(
        
        stat = 'identity', position = "identity"
      ) +labs(title = "Total Cases (per 100K)",y="Cases",x="Country")+theme(
        plot.title = element_text(color="red", size=14, face="bold.italic"),
        axis.title = element_text(family = "Helvetica", size = (10), colour = "steelblue4"),
        axis.text.y = element_text(family = "Courier", colour = "cornflowerblue", size = (10)),
        axis.text.x = element_text(angle = 90, hjust=0)
        
        
      )
    
  }) 
  

  
  output$plot_deathvscases<-renderPlot({
    

    topc <- data_evolution %>%
      filter(var == "active", date == current_date) %>%
      group_by(`Country/Region`) %>%
      summarise(value = sum(value, na.rm = T)) %>%
      arrange(desc(value)) %>%
      top_n(input$bins2) %>%
      select(`Country/Region`) %>%
      pull() 
    data10=filter(data12,`Country/Region` %in% topc)
    
    plot1 <- data10 %>% ggplot(aes(x=confirmed_total, y=deceased_total, col=deceased_total, size=confirmed_total)) +
      
      geom_text(aes(label=`Country/Region`), size=2.5, check_overlap=T, vjust=-1.6) +
      geom_point() +
      xlab('Total Confirmed') + ylab('Total Deaths') +
      labs(col="Death Rate (%)") +
      scale_color_gradient(low='#DC1805', high='#5A0C04') +
      scale_x_log10() + scale_y_log10() +
      labs(title=paste0('Top Countries - Confirmed vs Deaths (log scale)'))
    print(plot1)
    
    
  })   
  
  #Comparison Line Chart---------------------------
  
  output$linechart<-renderPlot({
    
    x<-data_confirmed_sub   
    x$date=strptime(x$date, "%m/%d/%y")
    x$date<-as.Date(x$date, "%m/%d/%Y")
    a<-x %>% filter(`Country/Region` %in% input$caseEvolution_line)
    a<-a %>% filter(date>"2020-01-01" & date<"2020-07-30")
    
    ggplot(a, aes(x =date , y = confirmed,group=`Country/Region`)) +
      geom_line(aes(colour=`Country/Region`),size=1) 
  })
  
  
  
  output$selectize_forline<- renderUI({
    selectizeInput(
      "caseEvolution_line",
      label    = "Countries",
      choices  = unique(data_evolution$`Country/Region`),
      selected = c("India","US", "Chile", "Brazil"),
      multiple = TRUE
    )
  })
  
  
  
  
  
}
  