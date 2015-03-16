#' Installs brainarray CDF and probe information packages
#'
#' This package downloads, installs, and/or loads the brainarray CDF and probe
#' enviroments from the Brainarray website.
#'
#' @param array_type A character of length 1 giving the giving the name of the'
#'   array. (Preferably as returned by \code{affyio::read.celfile.header})
#' @param custom_cdf A charcter giving the annotation type.
#' @param version A character of length 1 giving the version to download.
#' @return Invisibly returns a list of the locations of the saved files.
#' @author
#'   Steffen Falgreen
#'   Anders Ellern Bilgrau <abilgrau (at) math.aau.dk
#' @seealso \code{\link{tempdir}}, \code{\link{install.packages}}
#' @references
#'   See \url{http://brainarray.mbni.med.umich.edu}.
#' @examples
#' tmp.path <- requireBrainarray("hgu133a", custom_cdf = "enst",
#'                               version = "18.0.0")
#' print(tmp.path)
#' tmp.path2 <- requireBrainarray("hgu133a", custom_cdf = "enst")
#' print(tmp.path2)
#' @import AnnotationDbi
#' @export
requireBrainarray <- function(array_type,
                              custom_cdf = "enst",
                              version = getLatestVersion()) {
  output <- list()
  brain_dat <- output[["brain_dat"]] <-
    readBrainarrayTable(custom_cdf = custom_cdf, version = version)

  base_url <- attributes(brain_dat)$base_url
  if (getSubversion(version) >= 19) {
    base_url <- paste0("http://mbni.org/customcdf/", version, "/",
                       tolower(custom_cdf))
  }

  pkgs <- getBrainarrayPackages(brain_dat, array_type = array_type)

  for (pkg in pkgs) {
    loaded <- suppressWarnings(require(pkg, character.only = TRUE))
    if (!loaded || packageVersion(pkg) != version) {
      if (loaded) {
         message("Installed package version is not ", version,
                 ". Overwriting installed package.", sep = "")
      }
      file.pkg <- paste0(pkg, "_", version, ".tar.gz")

      # Construct url and download package
      pkg_url <- file.path(paste0(base_url, ".download"), file.pkg)
      pkg_dest <- output[[pkg]] <- file.path(tempdir(), file.pkg)
      download.file(url = pkg_url, destfile = pkg_dest)

      # Install and load package
      install.packages(pkgs = pkg_dest, repos = NULL, type = "source")
      require(pkg, character.only = TRUE)
    }
  }

  return(invisible(output))
}
