#' Read DLBCL class files
#'
#' Functions to read the internal data files of classified CEL files using
#' the DLBCL Automatic Classifier (DAC) [1]. These were manually supplied to the
#' DAC Windows interface.
#'
#' @param geo_nbr A \code{character} string giving the GSE number.
#' @return A \code{data.frame} of the predicted classes and the class
#'   probabilities. Returns \code{NULL} if \code{geo_nbr} is not found.
#' @author
#'   Anders Ellern Bilgrau \cr
#'   Steffen Falgreen
#' @references
#'   [1] Care, M. A., Barrans, S., Worrillow, L., Jack, A., Westhead, D. R., &
#'       Tooze, R. M. (2013). A microarray platform-independent classification
#'       tool for cell of origin class allows comparative analysis of gene
#'       expression in diffuse large B-cell lymphoma.
#'       PloS One, 8(2), e55895. doi:10.1371/journal.pone.0055895
#' @note
#' The GSE11318 dataset was not classified using the DAC.
#' @examples
#' data(DLBCL_overview)
#' head(DLBCL_overview[, -c(3,4,6)])
#'
#' head(readDACData("GSE19246"))
#'
#' readDACData("UNSUPPORTED_STUDY")
#' @export
readDACData <- function(geo_nbr) {
  extdir <- system.file("extdata", package = "DLBCLdata")
  files <- list.files(extdir, pattern = "^predictions-.+\\.txt$",
                      full.names = TRUE)
  file <- grep(geo_nbr, files, value = TRUE)
  dat <- lapply(file, read.table, header = TRUE)
  names(dat) <- gsub("predictions-|\\.txt$", "", basename(file))
  ans <- do.call(rbind, dat)
  return(ans)
}
