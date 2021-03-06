#' RMA preprocess CEL files
#'
#' General function for RMA processing microarray data. Automatically downloads
#' custom Brainarray chip definition files (cdf) if wanted.
#'
#' @param cel_files A character vector of .CEL files.
#' @param cdf A character specifying the CDF type to use. Should be either
#'   \code{"brainarray"} or \code{"affy"}.
#' @param target Specifies the "target" CDF to use depending on \code{cdf}.
#'   If \code{cdf} is \code{"affy"} then \code{target} is e.g. \code{"core"}.
#'   If \code{cdf} is \code{"brainarray"} then \code{target} is
#'   e.g. \code{"ensg"}, \code{"entrez"}.
#'   See \code{listTargets()} to list the available targets.
#' @param version A character giving the brainarray version to be used.
#'   Only used if \code{cdf} is \code{"brainarray"}. See \code{listVersions()}.
#' @param background boolean. Should RMA background correction be performed?
#' @param normalize boolean. Should RMA normalization be performed?
#' @return An expression set object.
#' @importFrom affy read.affybatch just.rma
#' @importFrom affyio read.celfile.header
#' @importFrom oligo rma
#' @export
preprocessCELFiles <- function(cel_files,
                               cdf = c("affy", "brainarray"),
                               target,
                               version = getLatestVersion(),
                               background = TRUE,
                               normalize = TRUE) {
  getCDF <- function(file) {
    return(read.celfile.header(file)$cdfName)
  }
  array_type <- sapply(cel_files, getCDF)
  array_types <- unique(array_type)
  if (length(array_types) != 1) {
    stop("The CEL files are from more that one array platform. The unique ",
         "platforms are: ", paste(array_types, collapse = ", "),
         ". The arrays should be preprocessed in batches of array platforms.")
  }
  array_type <- array_type[1]
  cel_files <- normalizePath(cel_files)
  cdf <- match.arg(cdf)

  if (tolower(cdf) == "affy") {
    # Load expression set
    es <- oligo::read.celfiles(cel_files)

    # RMA normalize
    if (class(es) %in% c("ExonFeatureSet","HTAFeatureSet","GeneFeatureSet")) {
      if (missing(target)) stop("No target provided.")
      es_rma <- oligo::rma(es, background = background,
                           normalize = normalize, target = target)
      attr(es_rma, "target") <- target
    } else {
      es_rma <- oligo::rma(es, background = background,
                           normalize = normalize)
      attr(es_rma, "target") <- NULL
    }

  } else if (tolower(cdf) == "brainarray") {

    if (missing(target)) stop("No target provided.")

    req <- requireBrainarray(array_type = array_type,
                             custom_cdf = target,
                             version = version)
    suppressWarnings({
      es_rma <- just.rma(filenames = cel_files,
                         verbose = TRUE,
                         cdfname = getCustomCDFName(req$brain_dat, array_type))
    })
    attr(es_rma, "target") <- target

  } else {
    stop("cdf == '", cdf,
         "' not supported. Should be either 'affy' or 'brainarray'")
  }

  # Add attributes
  attr(es_rma, "cdf") <- cdf
  attr(es_rma, "version") <- version
  attr(es_rma, "background") <- background
  attr(es_rma, "normalize") <- normalize

  return(es_rma)
}
