#' RMA preprocess CEL files
#'
#' General function for RMA processing microarray data. Automatically downloads
#' custom Brainarray chip definition files (cdf) if wanted.
#'
#' @param cel_files
#' @param cdf
#' @param target
#' @param version
#' @param backgroud
#' @param normalize
#' @return An expression set object.
#' @importFrom affy read.affybatch
#' @importFrom affyio read.celfile.header
#' @export
preprocessCELFiles <- function(cel_files = list.files(path, pattern="\\CEL$"),
                               cdf = "affy",
                               target = c("core", "full", "feature"),
                               version = getLatestVersion(),
                               background = TRUE,
                               normalize = TRUE,
                               path = getwd()) {
  stopifnot(require("affyio"))
  cel_files <- normalizePath(cel_files)
  array_type <- read.celfile.header(cel_files[1])$cdfName

  if (tolower(cdf) == "affy") {
    stopifnot(require("oligo"))
    target <- match.arg(target)

    # Load expression set
    es <- oligo::read.celfiles(cel_files)

    # RMA normalize
    if (class(es) %in% c("ExonFeatureSet","HTAFeatureSet","GeneFeatureSet")) {
      es_rma <- oligo::rma(es, background = background,
                           normalize = normalize, target = target)
    } else {
      es_rma <- oligo::rma(es, background = background,
                           normalize = normalize)
    }

  } else {
    stopifnot(require("affy"))
    req <- requireBrainarray(array_type = array_type, custom_cdf = cdf,
                             version = version)
    es_rma <- justRMA(filenames = cel_files, verbose = TRUE,
                      cdfname = getCustomCDFName(req$brain_dat, array_type))
  }
  return(es_rma)
}
