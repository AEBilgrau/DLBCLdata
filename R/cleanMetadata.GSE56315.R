#' @rdname cleanMetadata
#' @details
#'    GSE56315:\cr
#'    The cleanup of GSE56315 (CHEPRETRO) adds two batches corresponding to each
#'    clinical samples and normal sorted tissues both on platform
#'    HG-U133 plus 2.
#' @export
cleanMetadata.GSE56315 <- function(meta_data) {
  message("Cleaning GSE56315 (CHEPRETRO)!")

  # Generic clean
  suppressMessages(meta_data <- cleanMetadata.data.frame(meta_data))

  # Added factor describing the batches and CEL files
  tmp <- as.character(meta_data$characteristics_ch1)
  tmp <- ifelse(tmp == "tissue: human healthy tonsils", "tonsil", "DLBCL")
  meta_data$Batch <- factor(tmp)
  meta_data$CEL <-
    gsub("^.+/(GSM[0-9]+)\\..+$", "\\1", meta_data$supplementary_file)
  meta_data$GSM <- as.character(meta_data$geo_accession)
  # rownames(meta_data) <- meta_data$CEL

  return(meta_data)
}
