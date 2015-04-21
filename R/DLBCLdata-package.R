#' \pkg{DLBCLdata}: Diffuse Large B-cell Lymphoma data
#'
#' An R-package for reproducible and easily available datasets in DLBCL.
#' @author
#'   Anders Ellern Bilgrau <abilgrau (at) math.aau.dk> \cr
#'   Steffen Falgreen Larsen <sfl (at) rn.dk>
#' @docType package
#' @name DLBCLdata-package
#' @aliases DLBCLdata-package DLBCLdata dlbcldata dlbcl DLBCL
#' @examples
#' # Overview of the curated available data:
#' data(DLBCL_overview)
#' print(DLBCL_overview)
NULL

#' Overview of available DLBCL data
#'
#' A \code{data.frame} of the manually checked and curated DLBCL datasets in
#' the \pkg{DLBCLdata}-package.
#' The \code{data.frame} gives information on the GEO number, a study
#' acronym, the expanded acronym, the principal author, the arraytypes
#' present in the study, and a full citation.
#'
#' @docType data
#' @name DLBCL_overview
#' @format
#' A \code{data.frame} giving information about the DLBCL studies with the
#' following columns:\cr
#' \describe{
#'   \item{GSE}{The accession number}
#'   \item{Study}{A name or abbreviation of the study.}
#'   \item{FullName}{The full name of the study.}
#'   \item{Author}{The first author of the study.}
#'   \item{ArrayTypes}{The array type(s) used for the gene expression profiles.}
#'   \item{Citation}{Citation information. Please double check the information
#'     if the data is used.}
#' }
#' @keywords datasets, data
#' @examples
#' data(DLBCL_overview)
#' print(DLBCL_overview[,-6])
#' #View(DLBCL_overview)
NULL
