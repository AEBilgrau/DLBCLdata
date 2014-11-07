#' Download GEO dataset and preprocess it
#'
#' Functionality for automatically downloading, RMA preprocessing the array
#' data and formatting the phenotype data, and saving the results in a
#' \code{.RData} file.
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

  # Download array data
  cel_data <- downloadAndPrepareCELFiles(geo_nbr = geo_nbr, destdir = destdir,
                                         clean = clean, verbose = verbose)

  # Preprocess array data by RMA
  es <- preprocessCELFiles(cel_data$cel_files, ...)

  # Download metadata
  meta_data <- downloadAndPrepareMetadata(geo_nbr = geo_nbr, destdir = destdir,
                                          clean = clean, verbose = verbose)

  # Process metadata
  clean_meta_data <- cleanMetadata(meta_Data)


  return(list(metadata = clean_meta_data, expressiondata = cel_data))
}
