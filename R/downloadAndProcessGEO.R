#' Download GEO dataset and preprocess it
#'
#' Functionality for automatically downloading, RMA preprocessing the array
#' data and formatting the phenotype data, and saving the results in a
#' \code{.Rds} file.
#'
#' @param geo_nbr The GEO ascession number.
#' @param destdir The destination dir of the downloaded files.
#' @param ... Arguments passed to \code{\link{preprocessCELFiles}}
#' @param clean Should the strictly unnessesary files be deleted?
#' @param verbose Signal the process.
#' @return Does not return anything. Creates a folder with the downloaded and
#'   processed files.
#' @note The function will overwrite existing files in the \code{destdir}.
#' @author
#'   Anders Ellern Bilgrau,
#'   Steffen Falgreen Larsen
#' @examples
#' \dontrun{
#' res <- downloadAndProcessGEO(geo_nbr = "GSE18376")
#' }
#' @export
downloadAndProcessGEO <- function(geo_nbr,
                                  destdir = getwd(),
                                  ...,
                                  clean = FALSE,
                                  verbose = TRUE) {
  # Download metadata
  meta_data <- downloadAndPrepareMetadata(geo_nbr = geo_nbr, destdir = destdir,
                                          clean = clean, verbose = verbose)

  # Process metadata
  clean_meta_data <- cleanMetadata(meta_data)

  # Download array data
  cel_files <- downloadAndPrepareCELFiles(geo_nbr = geo_nbr, destdir = destdir,
                                          clean = clean, verbose = verbose)

  # Preprocess array data by RMA
  es <- preprocessCELFiles(cel_files, ...)

  # Save Rds file
  a <- attributes(es)
  file_name <- paste0(geo_nbr, "_", a$cdf,
                      ifelse(is.null(a$target), "", paste0("_", a$target)),
                      ifelse(a$cdf=="affy", "", paste0("_", version)), ".Rds")
  output <- list(es = es, metadata = clean_meta_data, call = match.call())
  saveRDS(output, file = file.path(destdir, geo_nbr, file_name))

  # Clean if wanted
  if (clean) rm(cel_files)
  if (verbose) cat("done.\n")
  return(invisible(output))
}
