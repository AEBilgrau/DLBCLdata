#' @rdname cleanMetadata
#' @details
#'    GSE11318:\cr
#'    The cleanup of GSE11318 (NCI) adds the batch corresponding to
#'    platform GPL570 (HG-U133 plus 2) and excludes the GPL6400 samples.
#' @export
cleanMetadata.GSE11318 <- function(meta_data) {
  message("Cleaning GSE34171 (NCI)!")

  # Generic clean
  suppressMessages(meta_data <- cleanMetadata.data.frame(meta_data))

  # Added factor describing the batches and CEL files
  meta_data$Batch <- factor(meta_data$platform_id,
                            levels = c("GPL570", NA))
  meta_data$CEL <-
    gsub("^.+/(GSM[0-9]+)\\..+$", "\\1", meta_data$supplementary_file)
  meta_data$GSM <- as.character(meta_data$geo_accession)
  rownames(meta_data) <- meta_data$CEL

  return(meta_data)
}
