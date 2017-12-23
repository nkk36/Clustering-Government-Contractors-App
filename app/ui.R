###########################################################################################################################
#                                                                                                                         #
#                                                     LOAD PACKAGES                                                       #
#                                                                                                                         #
###########################################################################################################################

library(shiny)
library(shinydashboard)
library(markdown)
library(DT)

###########################################################################################################################
#                                                                                                                         #
#                                                    USER INTERFACE                                                       #
#                                                                                                                         #
###########################################################################################################################

ui <- dashboardPage(
  dashboardHeader(title = "Clustering Government Contractors", titleWidth = 400),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      textInput(inputId = "Vendor", label = "Choose vendor:", value = "77815736"),
      menuItem(text = "Filter Inputs", 
               icon = icon("filter"),
               sliderInput(inputId = "Min_Contract", label = "Minimum Number of Contracts:", min = 0, max = 100, value = 50, step = 1),
               sliderInput(inputId = "Max_Contract", label = "Maximum Number of Contracts:", min = 0, max = 1500, value = 100, step = 1),
               numericInput(inputId = "Min_Revenue", label = "Minimum revenue:", value = 20000000, min = 0, max = NA, step = 1),
               numericInput(inputId = "Max_Revenue", label = "Maximum revenue:", value = 80000000, min = 0, max = NA, step = 1)
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
               # sliderInput(inputId = "Num_Groups", 
               #             label = "Number of Groups:",
               #             min = 1,
               #             max = 100,
               #             value = 1,
               #             step = 1),
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
                                            selected = "Average", 
                                            multiple = FALSE)
               ),
               selectInput(inputId = "Similarity_Calc", 
                           label = "Choose similarity calculation:", 
                           choices = c("Euclidean" = "Euclidean", "Pearson" = "Pearson"), 
                           selected = "Pearson", 
                           multiple = FALSE),
               checkboxInput(inputId = "Scale_Variables", 
                             label = "Scale Variables", 
                             value = FALSE),
               selectInput(inputId = "Perc_Total", 
                           label = "Percent or Total:", 
                           choices = c("Total" = "Total", "Percent" = "Percent"), 
                           selected = "Total", multiple = FALSE)
      )
    ),
    actionButton("update","Update")
  ),
  dashboardBody(
    
    tabItems(
      tabItem(tabName = "home",
              includeMarkdown("intro.md")
      ),
      tabItem(tabName = "dashboard",
              fluidRow(
                box(DT::dataTableOutput("comparison_table"), width = 6),
                tabBox(tabPanel(title = "Variance Explained", plotOutput("pca_sum")),
                       tabPanel(title = "PCA Plot", plotOutput("pca_plot")), id = "pca", selected = "Variance Explained",
                       title = "Principal Component Analysis (PCA)", width = 6)
                ),
              conditionalPanel(condition = "input.Clustering_Method == 'Heirarchical'",
                               fluidRow(
                                 box(sliderInput(inputId = "HClust_NGroups", 
                                                          label = "Number of groups:",
                                                          min = 1,
                                                          max = 100, 
                                                          value = 1), width = 4),
                                 box(plotOutput("hclust_plot"), width = 8)))
      )
    )
  )
)