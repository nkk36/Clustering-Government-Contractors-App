###########################################################################################################################
#                                                                                                                         #
#                                                     LOAD PACKAGES                                                       #
#                                                                                                                         #
###########################################################################################################################

# Load packages
library(shiny)
library(shinydashboard)
library(markdown)
library(DT)

# Load functions
source("R/load_data.R")

# Load data
all_data = load_data(TRUE)
duns_vendor_names_orig = all_data[[2]]

###########################################################################################################################
#                                                                                                                         #
#                                                    USER INTERFACE                                                       #
#                                                                                                                         #
###########################################################################################################################

ui <- dashboardPage(
  dashboardHeader(title = "Clustering Government Contractors", titleWidth = 400),
  dashboardSidebar(width = "20em",
    sidebarMenu(
      menuItem(text = "Home", tabName = "home", icon = icon("home")),
      menuItem(text = "Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      selectInput(inputId = "vendor", 
                  label = "Choose vendor:", 
                  choices = duns_vendor_names_orig$vendorname,
                  selected = "BOOZ ALLEN HAMILTON INC."),
      
      
      #################################################################
      #                                                               #
      #                 PRE-PROCESSING INPUTS                         #
      #                                                               #
      #################################################################
      
      menuItem(text = "Pre-Processing Inputs",
               icon = icon("filter"),
               selectInput(inputId = "dim_reduction_technique",
                           label = "Dimensionality Reduction:",
                           choices = c("None", "PCA", "SVD"),
                           selected = "PCA"),
               conditionalPanel(condition = "input.dim_reduction_technique != 'None'",
                                selectInput(inputId = "n_dim_reduction",
                                            label = "Choose number of reduced dimensions (Maximum of 10):",
                                            choices = 1:10,
                                            selected = 10,
                                            multiple = FALSE)
                                ),
               checkboxInput(inputId = "scale_variable_binary",
                             label = "Scale Variables",
                             value = FALSE),
               selectInput(inputId = "total_percent_binary",
                           label = "Total or Percent:",
                           choices = c("Total" = "Total", "Percent" = "Percent"),
                           selected = "Total", multiple = FALSE)
      )
    ),
    sidebarMenu(
      
      
      #################################################################
      #                                                               #
      #                 CLUSTERING INPUTS                             #
      #                                                               #
      #################################################################
      
      menuItem(text = "Clustering Inputs",
               icon = icon("cube"),
               selectInput(inputId = "clustering_method",
                           label = "Choose clustering method:",
                           choices = c("K-Means" = "K_Means", "Heirarchical" = "Heirarchical"),
                           selected = "K-Means",
                           multiple = FALSE),
               conditionalPanel(condition = "input.clustering_method == 'K_Means'",
                                sliderInput(inputId = "num_groups_kmeans",
                                            label = "Number of Groups:",
                                            min = 1,
                                            max = 100,
                                            value = 10,
                                            step = 1)
               ),
               conditionalPanel(condition = "input.clustering_method == 'Heirarchical'",
                                selectInput(inputId = "hclust_method", label = "Choose heirarchical clustering method:",
                                            choices = c("Complete" = "Complete", "Average" = "Average"),
                                            selected = "Average",
                                            multiple = FALSE)
               ),
               selectInput(inputId = "distance_definition",
                           label = "Choose similarity calculation:",
                           choices = c("Euclidean" = "Euclidean", "Pearson" = "Pearson"),
                           selected = "Euclidean",
                           multiple = FALSE)
      )
    ),
    actionButton("update","Update")
  ),
  
  #################################################################
  #                                                               #
  #                     DASHBOARD BODY                            #
  #                                                               #
  #################################################################
  
  dashboardBody(

    tabItems(
      tabItem(tabName = "home",
              includeMarkdown("intro.md")
      ),
      tabItem(tabName = "dashboard",
              fluidRow(
                box(DT::dataTableOutput("comparison_table"), width = 6),
                conditionalPanel(condition = "input.dim_reduction_technique != 'None'",
                                 fluidRow(
                                   tabBox(tabPanel(title = "Variance Explained",
                                                   plotOutput("variance_explained_plot")),
                                          tabPanel(title = "Plot",
                                                   plotOutput("dim_reduction_component_plot")),
                                          id = "pca",
                                          selected = "Variance Explained",
                                          title = "Dimensionality Reduction",
                                          width = 6)
                                   )
                                 )
                ),
              conditionalPanel(condition = "input.clustering_method == 'Heirarchical'",
                               fluidRow(
                                 box(sliderInput(inputId = "num_groups_hclust",
                                                          label = "Number of groups:",
                                                          min = 1,
                                                          max = 100,
                                                          value = 1), width = 4),
                                 box(plotOutput("dendrogram_plot"), width = 8)))
      )
    )
  )
)