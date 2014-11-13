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
#'   A \code{data.frame} giving information about the DLBCL studies:\cr\cr
#'   \code{'data.frame':  9 obs. of  6 variables:}\cr
#'   \code{$ GSE       : chr  "GSE19246" "GSE12195" "GSE22895" "GSE31312" ...}\cr
#'   \code{$ Study     : chr  "BCCA" "CUICG" "HMRC" "IDRC" ...}\cr
#'   \code{$ FullName  : chr  "British Columbia Cancer Agency" "Columbia University, Institute for Cancer Genetics" "Hematologic Malignancies Research Consortium" "International DLBCL Rituximap Consortium, MD Anderson Project" ...}\cr
#'   \code{$ Author    : chr  "Williams et. al." "Pasqualucci et. al." "Jima et. al." "Visco et. al." ...}\cr
#'   \code{$ ArrayTypes: chr  "hgu133plus2" "hgu133plus2" "hugene10st" "hgu133plus2" ...}\cr
#'   \code{$ Citation  : chr  "Williams PM, Li R"| __truncated__ "Pasqualucci L"| __truncated__ "Jima DD, Zhang J"| __truncated__ "Visco C, Li Y,"| __truncated__ ...}\cr
#' @keywords datasets, data
#' @examples
#' data(DLBCL_overview)
#' print(DLBCL_overview[,-6])
#' #View(DLBCL_overview)
NULL
