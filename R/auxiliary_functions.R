
#' Get file basename and remove .CEL extension
#'
#' Functions as \code{\link{basename}} but also remove any \code{.CEL}
#' or \code{.CEL.gz} extension. The function is not case sensitive of toward
#' the extension.
#'
#' @param x A \code{character} vector of file names.
#' @return A \code{character} vector of the same length as \code{x} with the
#'   basenames and no \code{.CEL} extension.
#' @seealso \code{\link{basename}}
#' @export
basenameSansCEL <- function(x) {
  return(gsub("\\.cel$|\\.cel.gz$", "", basename(x), ignore.case = TRUE))
}

getAffyTargets <- function() {
  message("Many 'older' arrays don't use targets.")
  return(c("core", "full", "probesets"))
}

