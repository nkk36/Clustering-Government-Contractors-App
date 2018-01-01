get_table_kmeans = function(data_for_clustering, duns_vendor_names, distance_definition, num_groups, vendor){
  
  if (distance_definition == "Euclidean"){
    
    d.kmeans = kmeans(dist(data_for_clustering), centers = num_groups)
    GetGroup = d.kmeans$cluster[which(duns_vendor_names$duns == duns_vendor_names$duns[which(duns_vendor_names$vendorname == vendor)])]
    close = data.frame(duns_vendor_names[which(d.kmeans$cluster == GetGroup),])
    close = close[order(close$vendorname),]
    
    datatable(close,options = list("pageLength" = 10))
  }else if (distance_definition == "Euclidean"){
    
    d.kmeans = kmeans(dist(data_for_clustering), centers = num_groups)
    GetGroup = d.kmeans$cluster[which(duns_vendor_names$duns == duns_vendor_names$duns[which(duns_vendor_names$vendorname == vendor)])]
    close = data.frame(duns_vendor_names[which(d.kmeans$cluster == GetGroup),])
    close = close[order(close$vendorname),]
    
    datatable(close,options = list("pageLength" = 10))
  }else if (distance_definition == "Pearson"){
    
    d.kmeans = kmeans(as.dist(1 - cor(t(data_for_clustering), method = "pearson")), centers = num_groups)
    GetGroup = d.kmeans$cluster[which(duns_vendor_names$duns == duns_vendor_names$duns[which(duns_vendor_names$vendorname == vendor)])]
    close = data.frame(duns_vendor_names[which(d.kmeans$cluster == GetGroup),])
    close = close[order(close$vendorname),]
    
    datatable(close,options = list("pageLength" = 10))
  }else if (distance_definition == "Pearson"){
    
    d.kmeans = kmeans(as.dist(1 - cor(t(data_for_clustering), method = "pearson")), centers = num_groups)
    GetGroup = d.kmeans$cluster[which(duns_vendor_names$duns == duns_vendor_names$duns[which(duns_vendor_names$vendorname == vendor)])]
    close = data.frame(duns_vendor_names[which(d.kmeans$cluster == GetGroup),])
    close = close[order(close$vendorname),]
    
    datatable(close,options = list("pageLength" = 10))
  }
  
}