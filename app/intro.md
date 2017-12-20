# Clustering: Finding Similar Government Contractors 
This is a web application to group similar government contractors based on different parameters that are user-defined. Grouping is done based on the number of contracts they had under a specific [NAICS](https://www.census.gov/eos/www/naics/) code for fiscal year 2016. For simplicity in this application I only used 7 NAICS codes that I was interested in personally, however this can be extended to any number of NAICS codes or other defining characteristics. 

The NAICS codes that I used were:

1. 541330: Engineering Services
2. 541380: Testing Laboratories
3. 541611: Administrative Management and General Management Consulting Services
4. 541618: Other Management Consulting Services
5. 541712: Research and Development in the Physical, Engineering, and Life Sciences (except Biotechnology)
6. 541990: All Other Professional, Scientific, and Technical Services
7. 611430: Professional and Management Development Training

The data comes from U.S. governemnt spending data found on  [USA Spending](https://www.usaspending.gov/Pages/Default.aspx). Details on how to download the data can be found [here](https://www.usaspending.gov/DownloadCenter/Pages/default.aspx) or on the [beta version](https://beta.usaspending.gov) of USA Spending that's still currently in development. 

This application uses [Hierarchical Clustering](https://en.wikipedia.org/wiki/Hierarchical_clustering) or [K-Means](https://en.wikipedia.org/wiki/K-means_clustering) to group contractors based on user input. Furthermore, the application performs [Principal Component Analysis](https://en.wikipedia.org/wiki/Principal_component_analysis) (PCA) to help visualize the data. There are four main outputs from this application:

1. Table of Similar Contractors
2. Data Distribution Plot 
3. Variance Explained Plot
4. Cluster Dendrogram

The Table of Similar Contractors lists the DUNS number and vendor name that are most similar. The Data Distribution Plot and the Variance Explained Plot are derived from performing PCA and the Cluster Dendrogram is derived from performing hierarchical clustering. 

To see the underlying code for this application, please see my [GitHub](https://github.com/nkk36). 

# Future Updates

I plan to continue making other clustering applications like this to include more NAICS codes, product service codes, company characteristics (i.e. non-profit, for-profit, etc..), and covering more years, but doing so requires different techniques. This is a simple application of clustering using a small number of features. 