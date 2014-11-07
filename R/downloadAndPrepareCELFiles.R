#' Download GEO .CEL files
#'
#' Function for downloading the CEL files of a GEO dataset and prepare it for
#' preprocessing.
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
#' downloadAndPrepareCELFiles(geo_nbr = "GSE18376",
#'                           destdir = tempdir())
#' }
#' @importFrom GEOquery getGEOSuppFiles gunzip
#' @keywords internal
#' @export
downloadAndPrepareCELFiles <- function(geo_nbr,
                                       destdir = getwd(),
                                       clean = FALSE,
                                       verbose = TRUE) {
  if (verbose) cat("Preparing GEO", geo_nbr, "data\n")
  dl.dir <- file.path(destdir, geo_nbr)

  # Download data if nessesary
  raw_file <- paste0(file.path(dl.dir, geo_nbr), "_RAW.tar")
  if (!file.exists(raw_file)) {
    if (verbose) cat("Downloading .CEL files...\n")
    dir.create(dl.dir, showWarnings = FALSE)
    getGEOSuppFiles(GEO = geo_nbr, makeDirectory = FALSE, baseDir = dl.dir)
  } else {
    if (verbose) cat("Compressed .CEL files already downloaded...\n")
  }

  # List celfiles (if any)
  cel_files <- list.files(dl.dir, pattern = "\\.cel$",
                          ignore.case = TRUE, full.names = TRUE)

  if (identical(cel_files, character(0))) {

    # Untar the file bundle
    if (verbose) cat("Untaring the RAW file...\n")
    tar.file <- list.files(path = dl.dir, pattern = "RAW.tar$", full.names = TRUE)
    untar(tarfile = tar.file, exdir = dl.dir)

    # Unzip the files
    if (verbose) cat("Unzipping the .CEL files...\n")
    gz_files <- list.files(dl.dir, pattern = "\\.cel.gz$", ignore.case = TRUE,
                           full.names = TRUE)
    for (file in gz_files) {
      gunzip(file, overwrite = TRUE, remove = TRUE)
    }

    # List celfiles
    cel_files <- list.files(dl.dir, pattern = "\\.cel$",
                            ignore.case = TRUE, full.names = TRUE)
  } else {
    cat(".CEL files already unpacked...\n")
  }

  # Clean-up if wanted
  if (clean) {
    if (verbose) cat("Removing all non CEL files...\n")
    file.remove(setdiff(list.files(dl.dir, full.names = TRUE), cel_files))
  }

  cel_files <- normalizePath(cel_files)
  if (verbose) cat("Download and preparation of CEL files done.\n")
  return(invisible(cel_files))
}
