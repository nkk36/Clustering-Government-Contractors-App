# Clustering Government Contractors

This is a repository for a Shiny application that clusters government contractors according to government spending data. This application is intended to be educational as it allows the user to set various parameters for clustering on a small subset of the data. The user can choose between using K-Means and Hierarchical clustering. There are options for dimensionality reduction (PCA, SVD) and scaling/centering data as well. The application was created using R Shiny.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development purposes. Since I store the data that uses this app remotely you'll need to edit some lines in ui.R and server.R with the appropriate data sets which you can find in the data directory.

1. In ui.R you will need to read *vendornames_for_clustering_app.csv* into *duns_vendor_names_orig* in the first block of code
2. In server.R you will need to read in vendornames_for_clustering_app.csv into *duns_vendor_names_orig* and *data_for_clustering_app.csv* into *naics_activity*
3. Also you should **comment out any line that with load_data.R** since this function is not saved in the repo

### Prerequisites

Here is a list of packages which you will need to run the application. You will also need all of their package dependencies as well. **This application was created using R 3.4.3.**

| Packages        | Version |
| --------------- |:-------:|
| dplyr           | 0.7.4   |
| DT              | 0.2     |
| ggfortify       | 0.4.1   |
| markdown        | 0.8     |
| shiny           | 1.0.5   |
| shinydashboard  | 0.6.1   |


```
Give examples
```

### Installing

A step by step series of examples that tell you have to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc
