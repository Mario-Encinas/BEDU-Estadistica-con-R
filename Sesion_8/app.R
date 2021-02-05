library(shiny)
library(shinydashboard)
library(shinythemes)

#Esta parte es el análogo al ui.R
ui <- 
    
    fluidPage(
        
        dashboardPage(
            
            dashboardHeader(title = "Basic dashboard"),
            
            dashboardSidebar(
                
                sidebarMenu(
                    menuItem("Gráficas", tabName = "dashboard", icon = icon("area-chart")),
                    menuItem("Probabilidades de Goles", tabName = "imagen", icon = icon("area-chart")),
                    menuItem("Match", tabName = "data_table", icon = icon("align-right")),
                    menuItem("Ganancias", tabName = "img", icon = icon("file-picture-o"))
                    
                )
                
            ),
            
            dashboardBody(
                
                tabItems(
                    
                    #1. Una con las gráficas de barras, donde en el eje de las x se muestran los goles de local y
                    #    visitante con un menú de selección, con una geometría de tipo barras además de hacer un
                    #    facet_wrap con el equipo visitante
                    tabItem(tabName = "dashboard",
                            fluidRow(
                                titlePanel(h3("Goles de equipo")), 
                                selectInput("equipo", "Seleccione un equipo",
                                            choices = c("home.score", "away.score")),
                                box(plotOutput("goles_equipo", height = 1000, width = 1000))
                            )
                    ),
                    
                    #2. Realiza una pestaña donde agregues las imágenes de las gráficas del postwork 3
                    tabItem(
                        tabName = "imagen",
                        fluidRow(
                            titlePanel(h3("Probabilidades de anotacion.")),
                            img( src = "3-1.png", 
                                 height = 350, width = 350),
                            img( src = "3-2.png", 
                                 height = 350, width = 350),
                            img( src = "3-3.png", 
                                 height = 350, width = 350)
                        )
                    ),
                    
                    
                    
                    #3. En otra pestaña coloca el datatable del fichero match.data.csv
                    tabItem(tabName = "data_table",
                            fluidRow(        
                                titlePanel(h3("Data Table")),
                                dataTableOutput ("data_table")
                            )
                    ),
                    
                    
                    #4. Por último en otra pestaña agrega las imágenes de las gráficas de los factores de ganancia     
                    tabItem(tabName = "img",
                            fluidRow(
                                titlePanel(h3("Plots del script 'momios'.")),
                                img( src = "momios-1.jpeg", 
                                     height = 350, width = 350),
                                img( src = "momios-1.jpeg", 
                                     height = 350, width = 350)
                            )
                    )
                    
                )
            )
        )
    )

#De aquí en adelante es la parte que corresponde al server

server <- function(input, output) {
    library(ggplot2)
    df <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-con-R-Santander/master/Sesion-08/Postwork/match.data.csv")
    
    #Gráfico de Histograma
    output$goles_equipo <- renderPlot({
        if(input$equipo == "home.score"){
            ggplot(df, aes(x = home.team, y = input$equipo)) +
                geom_bar(stat = "identity") +
                facet_wrap( ~ away.team, ncol = 5) +
                labs(x = "Equipo de Casa", y = "Número de goles", size=2) +
                coord_flip()
        } else {
            ggplot(df, aes(x = away.team, y = input$equipo)) +
                geom_bar(stat = "identity") +
                facet_wrap( ~ away.team, ncol = 5) +
                labs(x = "Equipo de Visitante", y = "Número de goles", size=2) +
                coord_flip()
        }
    })
    
    
    #Data Table
    output$data_table <- renderDataTable( {df}, 
                                          options = list(aLengthMenu = c(5,25,50),
                                                         iDisplayLength = 5)
    )
    
}


shinyApp(ui, server)
