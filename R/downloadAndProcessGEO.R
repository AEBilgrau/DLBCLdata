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
#' @return
#'   Creates a folder with the downloaded and processed files.
#'   The processed files are saved as an \code{.Rds} object named
#'   after the used parameters.
#'   Invisibly returns the saved object.
#' @note The function will overwrite existing files in the \code{destdir}.
#' @author
#'   Anders Ellern Bilgrau,
#'   Steffen Falgreen Larsen
#' @examples
#' \dontrun{
#' data(DLBCL_overview)
#' geo_nbr <-  DLBCL_overview[4,1]
#' res <- downloadAndProcessGEO(geo_nbr = geo_nbr, cdf = "brainarray",
#'                              target = "ENSG", clean = FALSE)
#' head(exprs(res$es$Batch1))
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

  GSM <- gsub("\\.cel$", "", rownames(clean_meta_data), ignore.case = TRUE)

  # Add filenames to cleaned data
  clean_meta_data$file <- cel_files[match(GSM, basenameSansCEL(cel_files))]
  stopifnot(all(basenameSansCEL(clean_meta_data$file) == clean_meta_data$GSM))

  # Checks and warnings
  if (nrow(clean_meta_data) != length(cel_files)) {
    warning("In ", geo_nbr, ". ",
            "The number of subjects in the metadata (", nrow(clean_meta_data),
            ") does not equal the number of cel files (",
            length(cel_files), ")")
  }
  if (!all(basenameSansCEL(cel_files) %in% GSM)) {
    warning("Not all downloaded CEL files are in the metadata")
  }
  if (!all(GSM %in% basenameSansCEL(cel_files))) {
    warning("Not all GSM numbers in the metadata have CEL files")
  }

  # Preprocess array data by RMA for each batch
  if (is.null(clean_meta_data$Batch)) {
    es <- preprocessCELFiles(cel_files, ...)
  } else {
    if (verbose) {
      message("Batches detected. RMA normalizing each of the batches: ",
              paste0(levels(clean_meta_data$Batch), collapse = " "))
    }
    batch_list <- with(clean_meta_data, split(file, Batch))
    es <- lapply(batch_list, preprocessCELFiles, ...)
  }

  # Save Rds file
  a <- attributes(es)
  file_name <- paste0(geo_nbr, "_", a$cdf,
                      ifelse(is.null(a$target), "", paste0("_", a$target)),
                      ifelse(a$cdf=="affy", "", paste0("_", a$version)), ".Rds")
  output <- list(es = es, metadata = clean_meta_data, call = match.call())
  saveRDS(output, file = file.path(destdir, geo_nbr, file_name))

  # Clean if wanted
  if (clean) file.remove(cel_files)
  if (verbose) cat("done.\n")

  return(invisible(output))
}


