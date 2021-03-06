% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/DLBCLdata-package.R
\docType{data}
\name{DLBCL_overview}
\alias{DLBCL_overview}
\title{Overview of available DLBCL data}
\format{A \code{data.frame} giving information about the DLBCL studies with the
following columns:\cr
\describe{
  \item{\code{GSE}}{The accession number}
  \item{\code{Study}}{A name or abbreviation of the study.}
  \item{\code{FullName}}{The full name of the study.}
  \item{\code{Author}}{The first author of the study.}
  \item{\code{ArrayTypes}}{The array type(s) used for the gene expression profiles.}
  \item{\code{Citationv}}{Citation information. Please double check the information
    if the data is used.}
}}
\description{
A \code{data.frame} of the manually checked and curated DLBCL datasets in
the \pkg{DLBCLdata}-package.
The \code{data.frame} gives information on the GEO number, a study
acronym, the expanded acronym, the principal author, the arraytypes
present in the study, and a full citation.
}
\examples{
print(DLBCL_overview[,-6])
#View(DLBCL_overview)
}
\keyword{data}
\keyword{datasets,}

