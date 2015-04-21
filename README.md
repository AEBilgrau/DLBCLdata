DLBCLdata
=========

Automated and reproducible download and preprocessing of Gene Expression Profile (GEP) studies of Diffuse Large B-Cell Lymphoma (DLBCL) using manufacturer's or custom Brainarray chip definition files (CDF) in **R**.

## Installation
To install the latest version of **DLBCLdata** directly from the master branch here at GitHub, run

```R
#install.packages("devtools")
devtools::install_github("AEBilgrau/DLBCLdata")
```

Note, that this version is in development and as such, it may be unstable. Be sure that you have the [package development prerequisites](http://www.rstudio.com/ide/docs/packages/prerequisites) if you wish to install the package from the source.

For previous versions of **DLBCLdata**, visit the old [releases at GitHub](https://github.com/AEBilgrau/DLBCLdata/releases).

## Usage
The package works with many NCBI GEO repositories. However, the package is tailored specifically to some DLBCL GEO accession numbers. To get an overview of the directly supported GEO numbers, see

```R
data(DLBCL_overview)
View(DLBCL_overview)
```

To download and process as specific GEO number, simply run

```R
res_gse19246 <- downloadAndProcessGEO("GSE19246", cdf = "brainarray", target = "ensg")
```

This downloads the `.CEL` files and pre-processes the data directly to Ensembl gene identifiers (ENSG) using RMA normalization and custom Brainarray CDFs [1].

To download and preprocesses *all* datasets featured in **DLBCLdata** (show with `DLBCL_overview`) using, say, brainarray to Entrez gene identifiers the following line will do so.

```R
dlbcl_data <- downloadAndProcessDLBCL(cdf = "brainarray", target = "ENTREZG")
```

This function creates the file `dlbcl_data.Rds` in the working directory which can later be read into **R** with `readRDS`.

## References

 1. Manhong Dai, Pinglang Wang, Andrew D. Boyd, Georgi Kostov, Brian Athey, Edward G. Jones, William E. Bunney, Richard M. Myer, Terry P. Speed, Huda Akil, Stanley J. Watson and Fan Meng. (2005) "Evolving Gene/Transcript Definitions Significantly Alter the Interpretation of GeneChip Data." Nucleic Acid Research 33 (20), e175 [(http://brainarray.mbni.med.umich.edu)](http://brainarray.mbni.med.umich.edu/Brainarray/Database/CustomCDF/genomic_curated_CDF.asp)
