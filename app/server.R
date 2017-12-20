###########################################################################################################################
#                                                                                                                         #
#                                             LOAD PACKAGES/FUNCTIONS/DATA                                                #
#                                                                                                                         #
###########################################################################################################################

# Load packages
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggfortify)

# Load functions
source("R/Load_Data.R")

# Load data
Data = Load_Data(TRUE)
naics = Data[[1]]
rc = Data[[2]]
vn = Data[[3]]

###########################################################################################################################
#                                                                                                                         #
#                                                         SERVER                                                          #
#                                                                                                                         #
###########################################################################################################################

server <- function(input, output){
  
  #################################################################
  #                                                               #
  #                      REACTIVE VALUES                          #
  #                                                               #
  #################################################################
  
  v <- reactiveValues(doPlot = FALSE)
  
  observeEvent(input$update, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v$doPlot <- input$update
  })
  
  #################################################################
  #                                                               #
  #                       REACTIVE DATA                           #
  #                                                               #
  #################################################################
  
  dataInput <- eventReactive(input$update, {

    # Subset data
    naics = naics[rc$ncontract >= input$Min_Contract & 
                    rc$ncontract <= input$Max_Contract |
                    rc$sum >= input$Min_Revenue & 
                    rc$sum <= input$Max_Revenue,]
    naics = naics[,2:ncol(naics)] # Remove duns column

    # Convert to percentage
    if (input$Perc_Total == "Percent"){
      naics[,1:ncol(naics)] = naics[,1:ncol(naics)]/sum(naics[,1:ncol(naics)])
    }

    # Take only columns that have a sum greater than 0
    naics = naics[,which(colSums(naics) > 0)]
    
    # Return data
    naics
  })
  
  duns <- reactive({

    # Subset data
    vn = vn[rc$ncontract >= input$Min_Contract & 
              rc$ncontract <= input$Max_Contract | 
              rc$sum >= input$Min_Revenue & 
              rc$sum <= input$Max_Revenue,]

  })
  
  #################################################################
  #                                                               #
  #                         OUTPUTS                               #
  #                                                               #
  #################################################################
  
  output$pca_plot <- renderPlot({
    if (v$doPlot == FALSE) return()
    
    isolate({
      autoplot(prcomp(scale(dataInput())))
    })

  }) # End pca_plot
  
  output$hclust_plot <- renderPlot({
    if (v$doPlot == FALSE) return()
    
    isolate({
      if (input$Similarity_Calc == "Euclidean"){
        d.hclust = hclust(dist(dataInput()), method = tolower(input$HClust_Method))
      }
      else if (input$Similarity_Calc == "Pearson"){
        d.hclust = hclust(as.dist(1 - cor(t(dataInput()),
                                          method = tolower(input$Similarity_Calc))),
                          method = tolower(input$HClust_Method)
                          )
      }
      
      plot(d.hclust, labels = FALSE, xlab = "Companies", sub = "")
    })
    
  }) # End hclust_plot
  
  
  
} # End server


















