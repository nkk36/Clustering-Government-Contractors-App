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
      textInput(inputId = "Vendor", label = "Choose vendor:", value = "964725688"), #77815736
      menuItem(text = "Pre-Process Inputs",
               icon = icon("filter"),
               selectInput(inputId = "Dim_Reduction",
                           label = "Dimensionality Reduction:",
                           choices = c("None", "PCA", "SVD"),
                           selected = "PCA"),
               conditionalPanel(condition = "input.Dim_Reduction != 'None'",
                                selectInput(inputId = "Components",
                                            label = "Choose number of reduced dimensions (Maximum of 10):",
                                            choices = 1:10,
                                            selected = 10,
                                            multiple = FALSE)
                                ),
               checkboxInput(inputId = "Scale_Variables",
                             label = "Scale Variables",
                             value = FALSE),
               selectInput(inputId = "Perc_Total",
                           label = "Total or Percent:",
                           choices = c("Total" = "Total", "Percent" = "Percent"),
                           selected = "Total", multiple = FALSE)
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
                                            value = 10,
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
                           selected = "Euclidean",
                           multiple = FALSE)
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
                conditionalPanel(condition = "input.Dim_Reduction != 'None'",
                                 fluidRow(
                                   tabBox(tabPanel(title = "Variance Explained",
                                                   plotOutput("Variance_Explained")),
                                          tabPanel(title = "Plot",
                                                   plotOutput("Dim_Reduction_Plot")),
                                          id = "pca",
                                          selected = "Variance Explained",
                                          title = "Dimensionality Reduction",
                                          width = 6)
                                   )
                                 )
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