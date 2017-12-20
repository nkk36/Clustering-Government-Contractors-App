###########################################################################################################################
#                                                                                                                         #
#                                                     LOAD PACKAGES                                                       #
#                                                                                                                         #
###########################################################################################################################

library(shiny)
library(shinydashboard)

###########################################################################################################################
#                                                                                                                         #
#                                                    USER INTERFACE                                                       #
#                                                                                                                         #
###########################################################################################################################

ui <- dashboardPage(
  dashboardHeader(title = "Clustering Government Contractors", titleWidth = 400),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("dashboard")),
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      textInput(inputId = "Vendor", label = "Choose vendor:", value = "77815736"),
      menuItem(text = "Filter Inputs", 
               icon = icon("filter"),
               sliderInput(inputId = "Min_Contract", label = "Minimum Number of Contracts:", min = 0, max = 100, value = 0, step = 1),
               sliderInput(inputId = "Max_contract", label = "Maximum Number of Contracts:", min = 0, max = 1500, value = 0, step = 1),
               numericInput(inputId = "Min_Revenue", label = "Minimum revenue:", value = 0, min = 0, max = NA, step = 1),
               numericInput(inputId = "Max_Revenue", label = "Maximum revenue:", value = 100000, min = 0, max = NA, step = 1)
              )
    ),
    sidebarMenu(
      menuItem(text = "Clustering Inputs",
               icon = icon("cube"),
                selectInput(inputId = "Clustering_Method", 
                            label = "Choose clustering method:", 
                            choices = c("K-Means" = "K_Means", "Heirarchical" = "Heirarchical"), 
                            selected = "K-Means", 
                            multiple = FALSE),
                conditionalPanel(condition = "input.Clustering_Method == 'K_Means'",
                                 sliderInput(inputId = "Num_Groups", 
                                             label = "Number of Groups:", 
                                             min = 1, 
                                             max = 100, 
                                             value = 1, 
                                             step = 1)
                                ),
                conditionalPanel(condition = "input.Clustering_Method == 'Heirarchical'",
                                 selectInput(inputId = "HClust_Method", label = "Choose heirarchical clustering method:", 
                                             choices = c("Complete" = "Complete", "Average" = "Average"), 
                                             selected = "Complete", 
                                             multiple = FALSE)
                                            ),
                selectInput(inputId = "Similarity_Calc", 
                            label = "Choose similarity calculation:", 
                            choices = c("Euclidean" = "Euclidean", "Pearson" = "Pearson"), 
                            selected = "Euclidean", 
                            multiple = FALSE),
                checkboxInput(inputId = "Scale_Variables", 
                              label = "Scale Variables", 
                              value = FALSE),
                selectInput(inputId = "Perc_Total", 
                            label = "Percent or Total:", 
                            choices = c("Total" = "Total", "Percent" = "Percent"), 
                            selected = "Total", multiple = FALSE)
            )
      )
  ),
  dashboardBody(
    
    tabItems(
      tabItem(tabName = "home",
              h2("Home Tab Content")
            ),
      tabItem(tabName = "dashboard",
              h2("Dashboard Tab Content")
            )
      )
  )
)


###########################################################################################################################
#                                                                                                                         #
#                                                         SERVER                                                          #
#                                                                                                                         #
###########################################################################################################################

server <- function(input, output) { }



###########################################################################################################################
#                                                                                                                         #
#                                                     RUN SHINY APP                                                       #
#                                                                                                                         #
###########################################################################################################################

shinyApp(ui, server)