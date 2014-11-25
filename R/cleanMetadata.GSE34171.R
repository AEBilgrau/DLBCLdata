#' @rdname cleanMetadata
#' @details
#'    GSE34171:\cr
#'    The cleanup of GSE34171 (MDFCI) adds three batches corresponding to each
#'    platform (HG-U133 plus 2, HG-U133A, HG-U133B).
#' @export
cleanMetadata.GSE34171 <- function(meta_data) {
  message("Cleaning GSE34171 (MDFCI)!")
  stopifnot(inherits(meta_data, "data.frame"))

  # Generic clean
  suppressMessages(meta_data <- cleanMetadata.data.frame(meta_data))

  # Added factor describing the batches and CEL files
  exclude <- c("GSM776068", "GSM776149")
  meta_data$Batch <-
    factor(ifelse(rownames(meta_data) %in% exclude, NA, "Batch1"))
  meta_data$CEL <- rownames(meta_data)
  meta_data$GSM <- as.character(meta_data$geo_accession)

  return(meta_data)
}


#   meta_data_Clinical <-
#     read.table(file=file.path(MDFCI.ext.dir, "../RawData", "Metadata",
#                               "GSE34171_clinical_info.txt"),
#                header = TRUE, stringsAsFactors = FALSE)
#
#   meta_data_Outcome <-
#     read.table(file=file.path(MDFCI.ext.dir, "../RawData", "Metadata",
#                               "GSE34171_outcome_data.txt"),
#                skip = 2, stringsAsFactors = FALSE)
#   colnames(meta_data_Outcome) <- c("Title", "Class", "os", "Followup")
#
#   meta_data_Sample <-
#     read.csv(file=file.path(MDFCI.ext.dir, "../RawData", "Metadata",
#                             "sample.csv"),
#              stringsAsFactors = FALSE)
#
#   meta_data <- merge(merge(meta_data_Sample,
#                                meta_data_Outcome, all.x=TRUE, all.y=TRUE),
#                          meta_data_Clinical, all.x=TRUE)
#
#   table(meta_data$Title, meta_data$Platform)
#
#   xx <- meta_data_Sample[meta_data_Sample$Title %in% meta_data$Title &
#                                meta_data_Sample$Platform == "GPL570" , c(1, 2)]
#
#   colnames(xx)[1] <- "HGU133Plus2"
#   meta_data <- merge(meta_data, xx, all.x = TRUE)
#
#   xx <- meta_data_Sample[meta_data_Sample$Title %in% meta_data$Title &
#                                meta_data_Sample$Platform == "GPL6801" , c(1, 2)]
#
#   colnames(xx)[1] <- "GenomeWideSNP6"
#   meta_data <- merge(meta_data, xx, all.x = TRUE)
#
#
#   xx <- meta_data_Sample[meta_data_Sample$Title %in% meta_data$Title &
#                                meta_data_Sample$Platform == "GPL96" , c(1, 2)]
#
#   colnames(xx)[1] <- "HGU133A"
#   meta_data <- merge(meta_data, xx, all.x = TRUE)
#
#   xx <- meta_data_Sample[meta_data_Sample$Title %in% meta_data$Title &
#                                meta_data_Sample$Platform == "GPL97" , c(1, 2)]
#
#   colnames(xx)[1] <- "HGU133B"
#   meta_data <- merge(meta_data, xx, all.x = TRUE)
#
#
#
#
#   meta_data <- meta_data[!duplicated(meta_data$Title),]
#
#   meta_data$IPI <- as.factor(as.numeric(meta_data$IPI))
#
#   meta_data$ipi.hl <- ifelse(is.na(meta_data$IPI), NA, "0-1")
#   meta_data$ipi.hl[meta_data$IPI %in% c(2, 3)] <- "2-3"
#   meta_data$ipi.hl[meta_data$IPI %in% c(4, 5)] <- "4-5"
#
#   table(meta_data[, c("IPI", "ipi.hl")])
#
#   Monti.Suppl5 <-
#     read.delim("../Litterature/Monti_Suppl5_NIHMS398769-supplement-06(1).txt",
#                stringsAsFactors = FALSE)
#
#   rownames(Monti.Suppl5) <- Monti.Suppl5$CaseID
#
#   colnames(Monti.Suppl5)[5] <- "WrightClass"
#
#
#
#   meta_data <- merge(meta_data, Monti.Suppl5,
#                          by.x = "Title", all.x=TRUE,
#                          by.y = "CaseID")
#
#
#   meta_data$TP53.mut[meta_data$TP53.mut == "na"] <- NA
#
#
#
#
#
#   ABCGCBclass <- read.delim(file.path(MDFCI.ext.dir,
#                                       "../ABCGCBclassification",
#                                       "ABCGCBclass.txt"))
#   meta_data$WrightClass_own <-
#     ABCGCBclass[meta_data$Title,2]
#
#   ABCGCBclass[paste(meta_data$GPL570, ".CEL", sep = ""),2]
#
#
#   meta_data$OS <- Surv(meta_data$os/365.25, meta_data$Followup)
#
#   os5  <- ifelse(meta_data$os/365.25 > 5, 5, meta_data$os/365.25)
#   ios5 <- pmin(ifelse(meta_data$os/365.25 > 5, 0, 1), meta_data$Followup)
#
#   meta_data$OS5 <- Surv(as.numeric(os5), ios5)
#
#
#   meta_data$HGU133Plus2[meta_data$HGU133Plus2 == "GSM844275"] <- NA
#
#   meta_data <- meta_data[, c(
#     "Title", "Class", "os", "Followup", "Type", "Entity", "Primary",
#     "IPI", "HGU133Plus2", "GenomeWideSNP6", "HGU133A", "HGU133B", "ipi.hl",
#     "SNP.ScanID", "GEP.SampleID", "CCC..Best.10.13.", "WrightClass",
#     "WrightClass_own", "TP53.mut")]

