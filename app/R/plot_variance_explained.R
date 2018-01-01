plot_variance_explained = function(data, features, dim_reduction_technique){
  
  if (dim_reduction_technique == "PCA"){
    
    ggplot(data = data) + 
      geom_point(mapping = aes(x = 1:features, 
                               y = var_exp,
                               size = 1)
      ) + 
      scale_x_continuous(breaks = 1:features) + 
      scale_y_continuous(limits = c(0,1)) +
      xlab("Principal Components") + 
      ylab("Variance Explained") + 
      theme(legend.position="none")
    
  }
  else if (dim_reduction_technique == "SVD"){
    
    ggplot(data = data) + 
      geom_point(mapping = aes(x = 1:features, 
                               y = var_exp,
                               size = 1)
      ) + 
      scale_x_continuous(breaks = 1:features) + 
      scale_y_continuous(limits = c(0,1)) +
      xlab("Singular Vectors") + 
      ylab("Variance Explained") + 
      theme(legend.position="none")
    
  }
  
}