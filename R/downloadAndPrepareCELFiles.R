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
  if (verbose) message("Preparing GEO ", geo_nbr, " data")
  dl_dir <- file.path(destdir, geo_nbr)

  # Download data if nessesary
  raw_file <- paste0(file.path(dl_dir, geo_nbr), "_RAW.tar")
  if (!file.exists(raw_file)) {
    if (verbose) message("Downloading .CEL files...\n")
    dir.create(dl_dir, showWarnings = FALSE)
    getGEOSuppFiles(GEO = geo_nbr, makeDirectory = FALSE, baseDir = dl_dir)
  } else {
    if (verbose) message("Compressed .CEL files already downloaded...")
  }

  # List celfiles (if any)
  cel_files <- list.files(dl_dir, pattern = "\\.cel$",
                          ignore.case = TRUE, full.names = TRUE)

  if (identical(cel_files, character(0))) {

    # Untar the file bundle
    if (verbose) message("Untaring the RAW file...\n")
    tar_file <- list.files(path = dl_dir, pattern = "RAW.tar$", full.names = TRUE)
    untar(tarfile = tar_file, exdir = dl_dir)

    # Unzip the files
    if (verbose) message("Unzipping the .CEL files...\n")
    gz_files <- list.files(dl_dir, pattern = "\\.cel.gz$", ignore.case = TRUE,
                           full.names = TRUE)
    for (file in gz_files) {
      gunzip(file, overwrite = TRUE, remove = TRUE)
    }

    # List celfiles
    cel_files <- list.files(dl_dir, pattern = "\\.cel$",
                            ignore.case = TRUE, full.names = TRUE)
  } else {
    message("(Some) .CEL files already unpacked...\n")
  }

  # Clean-up if wanted
  if (clean) {
    if (verbose) message("Removing all non CEL files...\n")
    file.remove(setdiff(list.files(dl_dir, full.names = TRUE), cel_files))
  }

  cel_files <- normalizePath(cel_files)
  if (verbose) message("Download and preparation of CEL files done.\n")
  return(invisible(cel_files))
}
