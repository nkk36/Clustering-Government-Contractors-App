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
source("R/load_data.R")
source("R/calculate_variance_explained.R")
source("R/plot_variance_explained.R")
source("R/get_table_kmeans.R")
source("R/get_table_heirarchical.R")


# Load data
all_data = load_data(TRUE)
naics_activity = all_data[[1]]
duns_vendor_names_orig = all_data[[2]]

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

  data_for_clustering <- eventReactive(input$update, {

    # Convert to percentage
    if (input$total_percent_binary == "Percent"){
      naics_activity = sweep(naics_activity, 1, rowSums(naics_activity), FUN="/")
    }
    
    if (input$scale_variable_binary == TRUE){
      naics_activity = scale(naics_activity)
    }
    
    if (input$dim_reduction_technique == "PCA"){
      naics_activity = data.frame(prcomp(naics_activity)$x[,1:input$n_dim_reduction])
    }
    else if (input$dim_reduction_technique == "SVD"){
      SVD = svd(naics_activity)
      naics_activity = data.frame(SVD$u[,1:input$n_dim_reduction])
    }
    
    # Take only columns that have a non-zero column sum
    naics_activity = naics_activity[,which(colSums(naics_activity) != 0)]

    # Return data
    naics_activity
  })

  data_before_dim_reduction <- eventReactive(input$update, {

    # Convert to percentage
    if (input$total_percent_binary == "Percent"){
      naics_activity = sweep(naics_activity, 1, rowSums(naics_activity), FUN="/")
    }

    if (input$scale_variable_binary == TRUE){
      naics_activity = scale(naics_activity)
    }

    # Take only columns that have a non-zero column sum
    naics_activity = naics_activity[,which(colSums(naics_activity) !=0)]

    # Return data
    naics_activity
  })

  duns_vendor_names <- eventReactive(input$update, {
    duns_vendor_names_orig
  })

  #################################################################
  #                                                               #
  #                         OUTPUTS                               #
  #                                                               #
  #################################################################

  output$dim_reduction_component_plot = renderPlot({
    if (v$doPlot == FALSE) return()

    isolate({

      if (input$dim_reduction_technique == "PCA"){
        autoplot(prcomp(data_before_dim_reduction()))
      }
      else if (input$dim_reduction_technique == "SVD"){
        SVD = data.frame(svd(data_before_dim_reduction())$u)
        
        ggplot(data = SVD) +
          geom_point(mapping = aes(x = X1, y = X2)) +
          ggtitle("Top Two Singular Vectors") +
          xlab("First Singular Vector") +
          ylab("Second Singular Vector")
        }


    })

  }) # End dim_reduction_component_plot

  output$variance_explained_plot = renderPlot({
    if (v$doPlot == FALSE) return()

    isolate({

      n_reduced_features = input$n_dim_reduction
      if (input$dim_reduction_technique == "PCA"){
        
        pca = prcomp(data_before_dim_reduction())
        pca = calculate_variance_explained(data = pca, features =  n_reduced_features, dim_reduction_technique ="PCA")
        plot_variance_explained(data = pca, features = n_reduced_features, dim_reduction_technique = "PCA")
        
      }
      else if (input$dim_reduction_technique == "SVD"){
        
        SVD = svd(data_before_dim_reduction())
        SVD = calculate_variance_explained(data = SVD, features =  n_reduced_features, dim_reduction_technique ="SVD")
        plot_variance_explained(data = SVD, features = n_reduced_features, dim_reduction_technique = "SVD")
        
      }
    })

  }) # End variance_explained_plot


  output$comparison_table <- renderDataTable({
    if (v$doPlot == FALSE) return()

    isolate({
      
      if (input$clustering_method == "K_Means"){
        get_table_kmeans(data_for_clustering = data_for_clustering(), 
                         duns_vendor_names = duns_vendor_names(), 
                         distance_definition = input$distance_definition, 
                         num_groups = input$num_groups_kmeans, 
                         vendor = input$vendor)
      }
      else if (input$clustering_method == "Heirarchical"){
        get_table_heirarchical(data_for_clustering = data_for_clustering(), 
                               duns_vendor_names = duns_vendor_names(), 
                               distance_definition = input$distance_definition, 
                               num_groups = input$num_groups_hclust, 
                               vendor = input$vendor, 
                               hclust_method = input$hclust_method)
      }
    })
    })# End comparison_table

  output$dendrogram_plot <- renderPlot({
    if (v$doPlot == FALSE) return()

    isolate({
      if (input$distance_definition == "Euclidean"){
        d.hclust = hclust(dist(data_for_clustering()), method = tolower(input$hclust_method))
      }
      else if (input$distance_definition == "Pearson"){
        d.hclust = hclust(as.dist(1 - cor(t(data_for_clustering()),
                                          method = tolower(input$distance_definition))),
                          method = tolower(input$hclust_method)
                          )
      }

      plot(d.hclust, labels = FALSE, xlab = "Companies", sub = "") #+ abline(h = vline, col = "blue")
    })

  }) # End dendrogram_plot



} # End server