#' Download GEO dataset
#'
#' Function for downloading a GEO dataset and prepare it for preprocessing.
#' The function uses \code{getGEOSuppFiles} which downloads the data. The
#' function then unzips the data files in the GEO series.
#'
#' @param geo_nbr The GEO ascession number.
#' @param destdir The destination dir of the downloaded files.
#' @param clean Should the strictly unnessesary files be deleted?
#' @param verbose Signal the process.
#' @note The function will overwrite existing files in the \code{destdir}.
#' @author
#'   Anders Ellern Bilgrau,
#'   Steffen Falgreen Larsen
#' @examples
#' \dontrun{
#' downloadAndPrepareGEOData(geo_nbr = "GSE18376",
#'                           destdir = tempdir())
#' }
#' @export
downloadAndPrepareGEOData <- function(geo_nbr,
                                      destdir = getwd(),
                                      clean = TRUE,
                                      verbose = TRUE) {
  stopifnot(require("GEOquery"))
  if (verbose) cat("Preparing GEO", geo_nbr, "data\n")

  # Download data
  if (verbose) cat("Downloading .CEL files...\n")
  dl.dir <- file.path(destdir, geo_nbr)
  dir.create(dl.dir)
  dl <- getGEOSuppFiles(GEO = geo_nbr, makeDirectory = FALSE, baseDir = dl.dir)

  # Untar the file bundle
  if (verbose) cat("Untaring the RAW file...\n")
  tar.file <- list.files(path = dl.dir, pattern = "RAW.tar$", full.names = TRUE)
  exdir <- dl.dir
  untar(tarfile = tar.file, exdir = exdir)

  # Unzip the files
  if (verbose) cat("Unzipping the .CEL files...\n")
  gz.files <- list.files(exdir, pattern = "\\.gz$", ignore.case = TRUE,
                         full.names = TRUE)
  for (file in gz.files) {
    gunzip(file, overwrite = TRUE, remove = TRUE)
  }
  cel.files <- list.files(exdir, pattern = "\\.cel$",
                          ignore.case = TRUE, full.names = TRUE)

  # Clean-up if wanted
  if (clean) {
    if (verbose) cat("Removing unnessary files...\n")
    file.remove(rownames(dl))
  }

  if (verbose) cat("Done.")
  return(invisible(data.frame(cel.files, gz.files)))
}
