DLBCLdata
=========

Automated and reproducible download and preprocessing of Gene Expression Profile (GEP) studies of Diffuse Large B-Cell Lymphoma (DLBCL) using standard or custom Brainarray chip definition (CDF) files.


## Installation
To install the latest version of **DLBCLdata** directly from the master branch here at GitHub, run

```R
#install.packages("devtools")
devtools::install_github("AEBilgrau/DLBCLdata")
```

Note, that this version is in development and as such, it may be unstable. Be sure that you have the [package development prerequisites](http://www.rstudio.com/ide/docs/packages/prerequisites) if you wish to install the package from the source.

For previous versions of **DLBCLdata**, visit the old [releases at GitHub](https://github.com/AEBilgrau/DLBCLdata/releases).

## Usage
The package works with many NCBI GEO repositories. However, the package is tailored specifically to some DLBCL GEO accession numbers. To get an overview of the "supported" GEO numbers, see

```R
data(DLBCO_overview)
View(DLBCL_overview)
````

To download and process as specific GEO number, simply run

```R
res <- downloadAndProcessGEO("GSE19246", cdf = "brainarray", target = "ensg")
```

This downloads the `.CEL` files and pre-processes the data directly to Ensembl gene identifiers (ENSG) using RMA normalization and custom Brainarray CDFs.
