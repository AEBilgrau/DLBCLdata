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
#'
#'   Arguments after \code{\dots} must be named.
#' @author
#'   Anders Ellern Bilgrau,
#'   Steffen Falgreen Larsen
#' @examples
#' \dontrun{
#' print(DLBCL_overview)
#' geo_nbr <- DLBCL_overview[6,1]
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
  GSM_met <- basenameSansCEL(rownames(clean_meta_data))
  stopifnot(all(GSM_met == clean_meta_data$GSM))

  # Download array data
  cel_files <- downloadAndPrepareCELFiles(geo_nbr = geo_nbr, destdir = destdir,
                                          clean = clean, verbose = verbose)
  GSM_cel <- gsub("(GSM[0-9]+).*$", "\\1", basenameSansCEL(cel_files))

  # Add local filenames to cleaned data
  clean_meta_data$file <- cel_files[pmatch(GSM_met, GSM_cel)]

  # Checks and warnings
  if (!all(GSM_cel %in% GSM_met)) {
    warning("Not all downloaded CEL files are in the metadata")
  }
  if (!all(GSM_met %in% GSM_cel)) {
    warning("Not all GSM numbers in the metadata have CEL files")
  }

  # Preprocess array data by RMA for each batch
  if (is.null(clean_meta_data$Batch)) {
    es <- preprocessCELFiles(cel_files, ...)
  } else {
    if (verbose) {
      message("Batches detected. RMA normalizing each of the batches: ",
              paste0(unique(clean_meta_data$Batch), collapse = ", "))
    }
    batch_list <- with(clean_meta_data, split(file, Batch))
    es <- lapply(batch_list, preprocessCELFiles, ...)
  }

  # Save Rds file
  a         <- list()
  a$cdf     <- tolower(finfo(es, "cdf"))
  a$target  <- finfo(es, "target")
  a$version <- finfo(es, "version")
  file_name <-
    paste0(geo_nbr, "_", a$cdf,
           ifelse(a$target != "", "_", ""),
           tolower(a$target),
           ifelse(a$cdf == "affy", "", paste0("_", a$version)),
           ".Rds")
  output <- list(es = es, metadata = clean_meta_data, call = match.call())
  saveRDS(output, file = file.path(destdir, geo_nbr, file_name))

  # Clean if wanted
  if (clean) file.remove(cel_files)
  if (verbose) message("done.\n")

  return(invisible(output))
}

finfo <- function(x, y) {
  if (!is.list(x)) {
    x <- list(x)
  }
  info <- unique(unlist(lapply(x, function(e) attributes(e)[[y]])))
  ans <- paste(info, collapse = "-")
  return(ans)
}
