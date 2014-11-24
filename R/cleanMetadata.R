#' Generic metadata cleaning function
#'
#' S3 method dispatch giving the custom functions for formatting datasets.
#' The function \code{downloadAndPrepareMetadata} adds a class \code{"GSEXXXX"}
#' of the GEO number in question.
#' The generic looks for functions of the name \code{cleanMetadata.GSEXXXX} and
#' specific for that dataset and cleans metadata using that function.
#'
#' @param meta_data Output from \code{downloadAndPrepareMetadata}.
#' @return Returns a function that will clean the given GEO dataset
#' @author Anders Ellern Bilgrau, Steffen Falgreen Larsen
#' @rdname cleanMetadata
#' @export
cleanMetadata <- function(meta_data) {
  UseMethod("cleanMetadata")
}

#' @rdname cleanMetadata
#' @export
cleanMetadata.data.frame <- function(meta_data) {
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

