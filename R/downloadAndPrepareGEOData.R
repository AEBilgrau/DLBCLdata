#' Download GEO dataset
#'
#' Function for downloading a GEO dataset. Simply a wrapper for \code{getGEO}
#' and \code{getGEOSuppFiles}.
#'
#' @param geo_nbr The GEO ascession number.
#' @param destdir The destination dir of the downloaded files.
#' @param verbose Signal the process.
#' @param clean Should the strictly unnessesary files be deleted?
#' @export
downloadAndPrepareGEOData <- function(geo_nbr,
                                      destdir = getwd(),
                                      verbose = TRUE,
                                      clean = TRUE) {
  stopifnot(require("GEOquery"))

  # Download data
  if (verbose) cat("Downloading .CEL files.\n")
  dl.dir <- file.path(destdir, geo_nbr)
  dl <- getGEOSuppFiles(GEO = geo_nbr, makeDirectory = FALSE, baseDir = dl.dir)

  # Untar the file bundle
  if (verbose) cat("Untaring the .CEL files.\n")
  tar.file <- list.files(path = dl.dir, pattern = "RAW.tar$", full.names = TRUE)
  exdir <- dl.dir
  untar(tarfile = tar.file, exdir = exdir)

  # Unzip the files
  if (verbose) cat("Unzipping the .CEL files.\n")
  gz.files <- list.files(exdir, pattern = "\\.gz$", ignore.case = TRUE,
                         full.names = TRUE)
  for (file in gz.files) {
    gunzip(file, remove = TRUE)
  }
  cel.files <- list.files(exdir, pattern = "\\.cel$",
                          ignore.case = TRUE, full.names = TRUE)

  # Clean-up if wanted
  if (clean) {
    if (verbose) cat("Removing unnessary files.\n")
    file.remove(tar.file)
    file.remove(rownames(dl))
  }

  return(invisible(data.frame(cel.files, gz.files)))
}

