#' Generic metadata cleaning function
#'
#' S3 method dispatch giving the custom functions for formatting datasets.
#'
#' @param meta_data Output from \code{downloadAndPrepareMetadata}.
#' @param geo_nbr A \code{character} giving the GEO number.
#' @return Returns a function that will clean the given GEO dataset.
#' @keywords internal
cleanMetadata <- function(meta_data, ...) {
  UseMethod("cleanMetadata")
}

#' @export
cleanMetadata.default <- function(meta_data) {
  message("No specific cleaning function was found for ", class(meta_data)[1],
          ". No cleanup was done!", sep = "")
  return(meta_data)
}

# ALTERNATIVE SYSTEM:
# cleanMetadata <- function(meta_data, geo_nbr, list_of_extra_args) {
#    do.call(geo_nbr, c(list(meta_data), list_of_extra_args))
# }
#
# GSEXXX <- function(meta_data) {
#   message("GSEXXX")
# }

