# Clustering: Finding Similar Government Contractors

## Introduction
This is a web application to group similar government contractors based on different parameters that are user-defined. Grouping is done based on the number of contracts companies listed under a specific [NAICS](https://www.census.gov/eos/www/naics/) code for fiscal year 2016. North American Industry Classification System (NAICS) codes classify companies by the types of work they are primarily engaged in. They are used for analyzing and understanding data about the U.S. economy. 

## NAICS Codes
For simplicity in this application I only used 10 NAICS codes randomly chosen from the list of NAICS codes my employer (Booz Allen Hamilton) listed for their contracts in FY16. The NAICS codes that I used were:

1. 333319: Other Commercial and Service Industry Machinery Manufacturing
2. 511210: Software Publishers
3. 531120: Lessors of Nonresidential Buildings
4. 541219: Other Accounting Services
5. 541611: Administrative Management and General Management Consulting Services
6. 541620: Environmental Consulting Services
7. 561621: Security Systems Services
8. 611430: Professional and Management Development Training
9. 811310: Commercial and Industrial Machinery and Equipment Repair and Maintenance
10. 926130:  Regulation and Administration of Communications, Electric, Gas, and Other Utilities

## Data
The data comes from U.S. governemnt spending data found on  [USA Spending](https://www.usaspending.gov/Pages/Default.aspx). Details on how to download the data can be found [here](https://www.usaspending.gov/DownloadCenter/Pages/default.aspx) or on the [beta version](https://beta.usaspending.gov) of USA Spending that's still currently in development.

## Methodology and Inputs/Outputs
This application uses [Hierarchical Clustering](https://en.wikipedia.org/wiki/Hierarchical_clustering) or [K-Means](https://en.wikipedia.org/wiki/K-means_clustering) to group contractors based on user input. There are two types of user input:

1. Pre-Processing Inputs
2. Clustering Inputs

The pre-processing inputs are used transform the data before applying the clustering methods. The clustering inputs are parameters that are needed to run the algorithms. Feel free to play around with setting different parameters and comparing the results.  

The application also performs [Principal Component Analysis](https://en.wikipedia.org/wiki/Principal_component_analysis) (PCA) and [Singular Value Decomposition](https://en.wikipedia.org/wiki/Singular-value_decomposition) to help visualize the data. Depending on the inputs you select you'll get a different set of outputs from this application on the Dashboard tab. However, there are a total of four outputs from this application:

1. Table of Similar Contractors
2. Data Distribution Plot
3. Variance Explained Plot
4. Cluster Dendrogram

The Table of Similar Contractors lists the DUNS number and vendor name that are most similar. The Data Distribution Plot and the Variance Explained Plot are derived from performing PCA/SVD and the Cluster Dendrogram is derived from performing hierarchical clustering.

## Code
To see the underlying code for this application, please see the [GitHub repo](https://github.com/nkk36/Clustering-Government-Contractors-App).

## Limitations and Future Updates
This is a simple application of clustering using a subset of the data and a smaller number of features. **This application is not intended to produce meaningful results and should only be viewed as an educational tool for unsupervised exploration of data.** I am always looking for ways to improve this app so if you have any suggestions feel free to email me at <nkallfa36@gmail.com>.

