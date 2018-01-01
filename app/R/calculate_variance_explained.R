calculate_variance_explained = function(data, features, dim_reduction_technique){
  
  # Check to see what dimension reduction technique is used and then 
  # get the data needed to calculate variance explained
  if (dim_reduction_technique == "PCA"){
    variance_explained = 1 - data$sdev^2/sum(data$sdev^2)
  }
  else if (dim_reduction_technique == "SVD"){
    variance_explained = 1 - data$d^2/sum(data$d^2)
  }
  
  variance_explained = data.frame(var_exp = variance_explained[1:features])
  
  
  # Return
  return(variance_explained)
  
}