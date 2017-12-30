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
library(DT)

# Load functions
source("R/Load_Data.R")

# Load data
Data = Load_Data(TRUE)
naics = Data[[1]]
vn = Data[[2]]

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
    v$doPlot <- input$update
  })

  #################################################################
  #                                                               #
  #                       REACTIVE DATA                           #
  #                                                               #
  #################################################################

  dataInput <- eventReactive(input$update, {

    # Convert to percentage
    if (input$Perc_Total == "Percent"){
      naics[,1:ncol(naics)] = naics[,1:ncol(naics)]/sum(naics[,1:ncol(naics)])
    }
    
    if (input$Scale_Variables == TRUE){
      naics = scale(naics)
    }
    
    if (input$Dim_Reduction == "PCA"){
      naics = data.frame(prcomp(naics)$x[,1:input$Components])
    }
    else if (input$Dim_Reduction == "SVD"){
      SVD = svd(naics)
      naics = data.frame(SVD$u[,1:input$Components])
    }
    
        # Take only columns that have a non-zero column sum
        naics = naics[,which(colSums(naics) != 0)]

    # Return data
    naics
  })

  originalData <- eventReactive(input$update, {

    # Convert to percentage
    if (input$Perc_Total == "Percent"){
      naics[,1:ncol(naics)] = naics[,1:ncol(naics)]/sum(naics[,1:ncol(naics)])
    }

    if (input$Scale_Variables == TRUE){
      naics = scale(naics)
    }

    # Take only columns that have a non-zero column sum
    naics = naics[,which(colSums(naics) !=0)]

    # Return data
    naics
  })

  duns <- eventReactive(input$update, {
    vn
  })

  #################################################################
  #                                                               #
  #                         OUTPUTS                               #
  #                                                               #
  #################################################################

  output$Dim_Reduction_Plot = renderPlot({
    if (v$doPlot == FALSE) return()

    isolate({

      if (input$Dim_Reduction == "PCA"){
        autoplot(prcomp(originalData()))
      }
      else if (input$Dim_Reduction == "SVD"){
        SVD = svd(originalData())
        SVD = data.frame(SVD$u)
        ggplot(data = SVD) +
          geom_point(mapping = aes(x = X1, y = X2)) +
          ggtitle("Top Two Singular Vectors") +
          xlab("First Singular Vector") +
          ylab("Second Singular Vector")
        }


    })

  }) # End pca_plot

  output$Variance_Explained = renderPlot({
    if (v$doPlot == FALSE) return()

    isolate({

      Components = input$Components
      if (input$Dim_Reduction == "PCA"){
        
        Components = input$Components
        pca = prcomp(originalData())
        pca = 1 - pca$sdev^2/sum(pca$sdev^2)
        pca = data.frame(var_exp = pca[1:Components])
        
        ggplot(data = pca) + 
          geom_point(mapping = aes(x = 1:Components, 
                                   y = var_exp,
                                   size = 1)
                     ) + 
          scale_x_continuous(breaks = 1:Components) + 
          scale_y_continuous(limits = c(0,1)) +
          xlab("Principal Components") + 
          ylab("Variance Explained") + 
          theme(legend.position="none")
      }
      else if (input$Dim_Reduction == "SVD"){
        
        Components = input$Components
        SVD = svd(originalData())
        SVD = 1 - SVD$d^2/sum(SVD$d^2)
        SVD = data.frame(var_exp = SVD[1:Components])
        
        ggplot(data = SVD) + 
          geom_point(mapping = aes(x = 1:Components, 
                                   y = var_exp,
                                   size = 1)
          ) + 
          scale_x_continuous(breaks = 1:Components) + 
          scale_y_continuous(limits = c(0,1)) +
          xlab("Singular Vectors") + 
          ylab("Variance Explained") + 
          theme(legend.position="none")
      }
    })

  }) # End pca_sum


  output$comparison_table <- renderDataTable({
    if (v$doPlot == FALSE) return()

    isolate({
      if (input$Clustering_Method == "K_Means" & input$Similarity_Calc == "Euclidean"){

        d.kmeans = kmeans(dist(dataInput()), centers = input$Num_Groups)
        GetGroup = d.kmeans$cluster[which(duns()$duns == duns()$duns[which(duns()$vendorname == input$Vendor)])]
        close = data.frame(duns()[which(d.kmeans$cluster == GetGroup),])
        close = close[order(close$vendorname),]

        datatable(close,options = list("pageLength" = 10))
      }else if (input$Clustering_Method == "K_Means" & input$Similarity_Calc == "Euclidean"){

        d.kmeans = kmeans(dist(dataInput()), centers = input$Num_Groups)
        GetGroup = d.kmeans$cluster[which(duns()$duns == duns()$duns[which(duns()$vendorname == input$Vendor)])]
        close = data.frame(duns()[which(d.kmeans$cluster == GetGroup),])
        close = close[order(close$vendorname),]

        datatable(close,options = list("pageLength" = 10))
      }else if (input$Clustering_Method == "K_Means" & input$Similarity_Calc == "Pearson"){

        d.kmeans = kmeans(as.dist(1 - cor(t(dataInput()), method = "pearson")), centers = input$Num_Groups)
        GetGroup = d.kmeans$cluster[which(duns()$duns == duns()$duns[which(duns()$vendorname == input$Vendor)])]
        close = data.frame(duns()[which(d.kmeans$cluster == GetGroup),])
        close = close[order(close$vendorname),]

        datatable(close,options = list("pageLength" = 10))
      }else if (input$Clustering_Method == "K_Means" & input$Similarity_Calc == "Pearson"){

        d.kmeans = kmeans(as.dist(1 - cor(t(dataInput()), method = "pearson")), centers = input$Num_Groups)
        GetGroup = d.kmeans$cluster[which(duns()$duns == duns()$duns[which(duns()$vendorname == input$Vendor)])]
        close = data.frame(duns()[which(d.kmeans$cluster == GetGroup),])
        close = close[order(close$vendorname),]

        datatable(close,options = list("pageLength" = 10))
      }else if (input$Clustering_Method == "Heirarchical" & input$Similarity_Calc == "Euclidean"){

        d.hclust = hclust(dist(dataInput()), method = tolower(input$HClust_Method))
        cut = cutree(d.hclust, k = input$HClust_NGroups)
        GetGroup = cut[which(duns()$duns == duns()$duns[which(duns()$vendorname == input$Vendor)])]
        close = data.frame(duns()[which(cut == GetGroup),])
        close = close[order(close$vendorname),]

        datatable(close,options = list("pageLength" = 10))
      }else if (input$Clustering_Method == "Heirarchical" & input$Similarity_Calc == "Euclidean"){

        d.hclust = hclust(dist(dataInput()), method = tolower(input$HClust_Method))
        cut = cutree(d.hclust, k = input$HClust_NGroups)
        GetGroup = cut[which(duns()$duns == duns()$duns[which(duns()$vendorname == input$Vendor)])]
        close = data.frame(duns()[which(cut == GetGroup),])
        close = close[order(close$vendorname),]
        close = close[order(close$vendorname),]

        datatable(close,options = list("pageLength" = 10))
      }else if (input$Clustering_Method == "Heirarchical" & input$Similarity_Calc == "Pearson"){

        d.hclust = hclust(as.dist(1 - cor(t(dataInput()), method = "pearson")), method = tolower(input$HClust_Method))
        cut = cutree(d.hclust, k = input$HClust_NGroups)
        GetGroup = cut[which(duns()$duns == duns()$duns[which(duns()$vendorname == input$Vendor)])]
        close = data.frame(duns()[which(cut == GetGroup),])
        close = close[order(close$vendorname),]

        datatable(close,options = list("pageLength" = 10))
      }else if (input$Clustering_Method == "Heirarchical" & input$Similarity_Calc == "Pearson"){

        d.hclust = hclust(as.dist(1 - cor(t(dataInput()), method = "pearson")), method = tolower(input$HClust_Method))
        cut = cutree(d.hclust, k = input$HClust_NGroups)
        GetGroup = cut[which(duns()$duns == duns()$duns[which(duns()$vendorname == input$Vendor)])]
        close = data.frame(duns()[which(cut == GetGroup),])
        close = close[order(close$vendorname),]

        datatable(close,options = list("pageLength" = 10))
      }
    })
    })# End comparison_table

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

      plot(d.hclust, labels = FALSE, xlab = "Companies", sub = "") #+ abline(h = vline, col = "blue")
    })

  }) # End hclust_plot



} # End server