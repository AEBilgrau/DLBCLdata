#' @rdname cleanMetadata
#' @details
#'    GSE31312:\cr
#'    This function makes the samples GSM776068 and GSM776149 to be left
#'    out of the downsteam preprocessing due to bad array quality.
#' @export
cleanMetadata.GSE31312 <- function (meta_data) {
  message("Cleaning GSE31312!")
  stopifnot(inherits(meta_data, "data.frame"))

  # Generic clean
  suppressMessages(meta_data <- cleanMetadata.data.frame(meta_data))

  # Added factor describing the batches and CEL files
  exclude <- c("GSM776068", "GSM776149", "GSM776462")
  meta_data$Batch <-
    factor(ifelse(rownames(meta_data) %in% exclude, NA, "Batch1"))
  meta_data$CEL <- rownames(meta_data)
  meta_data$GSM <- as.character(meta_data$geo_accession)

  return(meta_data)
}


# meta_data$Array.Data.File <-
#   as.character(
#     meta_data_old[as.character(meta_data$GEO.Depository..31312),
#                      "Array.Data.File" ])
#
# meta_data <- meta_data[!is.na(meta_data$Array.Data.File),]
#
# meta_data$WrightClass2 <-
#   meta_data$GEP.Classification
# meta_data$WrightClass <- as.character(meta_data$WrightClass2)
# meta_data$WrightClass <-
#   as.factor(gsub("UC", "Unclassified", meta_data$WrightClass))
#
#   # Creating survival objects
#
#   meta_data$OS  <- meta_data$OS  / 12
#   meta_data$PFS <- meta_data$PFS / 12
#
# meta_data$OScensor <- ifelse(meta_data$OScensor == 1, 0, 1)
# meta_data$PFScensor <- ifelse(meta_data$PFScensor == 1, 0, 1)
#
# meta_data$OS<- Surv(as.numeric(meta_data$OS), meta_data$OScensor)
#
# os5  <- ifelse(meta_data$OS[,1] > 5, 5, meta_data$OS[,1])
# ios5 <- pmin(ifelse(meta_data$OS[,1] > 5, 0, 1), meta_data$OS[,2])
#
# meta_data$OS5 <- Surv(as.numeric(os5), ios5)
#
# meta_data$PFS<- Surv(as.numeric(meta_data$PFS), meta_data$PFScensor)
#
# PFS5  <- ifelse(meta_data$PFS[,1] > 5, 5, meta_data$PFS[,1])
# iPFS5 <- pmin(ifelse(meta_data$PFS[,1] > 5, 0, 1), meta_data$PFS[,2])
#
# meta_data$PFS5 <- Surv(as.numeric(PFS5), iPFS5)
# @
#
#   <<>>=
#   meta_data$ipi.hl <- NA
# meta_data$ipi.hl[meta_data$IPI.score %in% c(0,1)] <- "0-1"
# meta_data$ipi.hl[meta_data$IPI.score %in% c(2,3)] <- "2-3"
# meta_data$ipi.hl[meta_data$IPI.score %in% c(4,5)] <- "4-5"
# meta_data$ipi.hl <- as.factor(meta_data$ipi.hl)
# table(meta_data$ipi.hl, meta_data$IPI.score)
#
# meta_data$age <- meta_data$Age
