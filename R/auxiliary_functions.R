
#' Get file basename and remove .CEL extension
#'
#' Functions as \code{\link{basename}} but also remove any \code{.CEL}
#' or \code{.CEL.gz} extension. The function is not case sensitive of toward
#' the extension.
#'
#' @param x A \code{character} vector of filenames and possibly with path.
#' @return A \code{character} vector of the same length as \code{x} with the
#'   file basename without the path and \code{.CEL} extension.
#' @seealso \code{\link{basename}}
#' @examples
#' x <- c("C:/test/mycelfile.cel", "myothercelfile.cel")
#' basenameSansCEL(x)
#' @export
basenameSansCEL <- function(x) {
  return(gsub("\\.cel$|\\.cel.gz$", "", basename(x), ignore.case = TRUE))
}

getAffyTargets <- function() {
  message("Many 'older' arrays don't use targets.")
  return(c("core", "full", "probesets"))
}

gpl2affy <- function(gpl) {
  affy <- gpl
  affy <- gsub("GPL570", "hgu133plus2", affy)
  affy <- gsub("GPL96", "hgu133a", affy)
  affy <- gsub("GPL97", "hgu133b", affy)
  affy <- gsub("GPL5175", "huex10st", affy)
  affy <- gsub("GPL5175", "huex10st", affy)
  affy <- gsub("GPL6244", "hugene10st", affy)
  return(affy)
}
