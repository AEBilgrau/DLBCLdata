#' Generic metadata cleaning function
#'
#' S3 method dispatch giving the custom functions for formatting datasets.
#' The function \code{downloadAndPrepareMetadata} adds a class \code{"GSEXXXX"}
#' of the GEO number in question.
#' The generic looks for functions of the name \code{cleanMetadata.GSEXXXX} and
#' specific for that dataset and cleans metadata using that function.
#'
#' @param meta_data Output from \code{downloadAndPrepareMetadata}.
#' @return
#'   Returns a specfically cleaned \code{data.frame} for the GEO dataset.
#' @author Anders Ellern Bilgrau, Steffen Falgreen Larsen
#' @rdname cleanMetadata
#' @export
cleanMetadata <- function(meta_data) {
  UseMethod("cleanMetadata")
}

#' @rdname cleanMetadata
#' @export
cleanMetadata.data.frame <- function(meta_data) {

  message("No specific cleaning function was found for ",
          class(meta_data)[1], ". No specific cleanup was done!", sep = "")

  meta_data$Batch <- "Batch1"
  meta_data$CEL   <- rownames(meta_data)
  meta_data$GSM   <- as.character(meta_data$geo_accession)

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

