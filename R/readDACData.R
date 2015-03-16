#' Read DLBCL class files
#'
#' Functions to read the internal data files of classified CEL files using
#' the DLBCL Automatic Classifier (DAC). These were manually supplied to the
#' DAC Windows interface.
#'
#' @param geo_nbr A \code{character} string giving the GSE number.
#' @return A \code{data.frame} of the predicted classes and the class
#'   probabilities.
#' @examples
#' head(readDACData("GSE19246"))
#' @keywords internal
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
