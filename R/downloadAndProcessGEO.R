#' Download GEO dataset and preprocess it
#'
#' Functionality for downloading a GEO dataset and preprocess it.
#'
#' @param geo_nbr The GEO ascession number.
#' @param destdir The destination dir of the downloaded files.
#' @param ... Arguments passed to \code{\link{preprocessCELFiles}}
#' @param clean Should the strictly unnessesary files be deleted?
#' @param verbose Signal the process.
#' @note The function will overwrite existing files in the \code{destdir}.
#' @author
#'   Anders Ellern Bilgrau,
#'   Steffen Falgreen Larsen
#' @examples
#' \dontrun{
#' downloadAndProcessGEO(geo_nbr = "GSE18376")
#' }
#' @export
downloadAndProcessGEO <- function(geo_nbr,
                                  destdir = getwd(),
                                  ...,
                                  clean = FALSE,
                                  verbose = TRUE) {

  # Download CEL data
  downloadAndPrepareCELFiles(geo_nbr = geo_nbr, destdir = destdir,
                             clean = clean, verbose = verbose)

  # Preprocess CEL data by RMA
  es <- preprocessCELFiles(...)

  # Download meta data
  # ...

  # Process meta data
  # ...


  return(es)
}
