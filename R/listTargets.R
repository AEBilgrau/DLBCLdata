#' List available targets
#'
#' This function lists available targets for a given \code{cdf} argument.
#' @param cdf A character. Either \code{"affy"} or \code{"brainarray"}.
#' @param version A character giving the brainarray version.
#'   See \code{listVersions()}. Ignored if \code{cdf == "affy"}.
#' @return A character vector of the available targets.
#' @examples
#' listTargets("affy")
#' listTargets("brainarray", version = "18.0.0")
#' listTargets("brainarray", version = "17.1.0")
#' listTargets("brainarray", version = "15.0.0")
#' @export
listTargets <- function(cdf, version = getLatestVersion()) {
  if (cdf == "affy") {
    message("Listing 'affy' targets is not fully implemented yet!")
    return(getAffyTargets())
  } else if (cdf == "brainarray") {
    return(getBrainarrayTargets(version))
  } else {
    stop("The argument cdf must equal either 'affy' or 'brainrray'.")
  }
}
