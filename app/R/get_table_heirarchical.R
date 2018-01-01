get_table_heirarchical = function(data_for_clustering, 
                                  duns_vendor_names, distance_definition, num_groups, vendor, hclust_method){
  
  if (distance_definition == "Euclidean"){
    
    d.hclust = hclust(dist(data_for_clustering), method = tolower(hclust_method))
    cut = cutree(d.hclust, k = num_groups)
    GetGroup = cut[which(duns_vendor_names$duns == duns_vendor_names$duns[which(duns_vendor_names$vendorname == vendor)])]
    close = data.frame(duns_vendor_names[which(cut == GetGroup),])
    close = close[order(close$vendorname),]
    
    datatable(close,options = list("pageLength" = 10))
  }else if (distance_definition == "Euclidean"){
    
    d.hclust = hclust(dist(data_for_clustering), method = tolower(hclust_method))
    cut = cutree(d.hclust, k = num_groups)
    GetGroup = cut[which(duns_vendor_names$duns == duns_vendor_names$duns[which(duns_vendor_names$vendorname == vendor)])]
    close = data.frame(duns_vendor_names[which(cut == GetGroup),])
    close = close[order(close$vendorname),]
    close = close[order(close$vendorname),]
    
    datatable(close,options = list("pageLength" = 10))
  }else if (distance_definition == "Pearson"){
    
    d.hclust = hclust(as.dist(1 - cor(t(data_for_clustering), method = "pearson")), method = tolower(hclust_method))
    cut = cutree(d.hclust, k = num_groups)
    GetGroup = cut[which(duns_vendor_names$duns == duns_vendor_names$duns[which(duns_vendor_names$vendorname == vendor)])]
    close = data.frame(duns_vendor_names[which(cut == GetGroup),])
    close = close[order(close$vendorname),]
    
    datatable(close,options = list("pageLength" = 10))
  }else if (distance_definition == "Pearson"){
    
    d.hclust = hclust(as.dist(1 - cor(t(data_for_clustering), method = "pearson")), method = tolower(hclust_method))
    cut = cutree(d.hclust, k = num_groups)
    GetGroup = cut[which(duns_vendor_names$duns == duns_vendor_names$duns[which(duns_vendor_names$vendorname == vendor)])]
    close = data.frame(duns_vendor_names[which(cut == GetGroup),])
    close = close[order(close$vendorname),]
    
    datatable(close,options = list("pageLength" = 10))
  }
  
  
  
}