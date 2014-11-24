
cleanMetadata.GSE34171 <- function(meta_data) {
  message("Cleaning GSE34171")

  metadataMDFCI_Clinical <-
    read.table(file=file.path(MDFCI.ext.dir, "../RawData", "Metadata",
                              "GSE34171_clinical_info.txt"),
               header = TRUE, stringsAsFactors = FALSE)

  metadataMDFCI_Outcome <-
    read.table(file=file.path(MDFCI.ext.dir, "../RawData", "Metadata",
                              "GSE34171_outcome_data.txt"),
               skip = 2, stringsAsFactors = FALSE)
  colnames(metadataMDFCI_Outcome) <- c("Title", "Class", "os", "Followup")

  metadataMDFCI_Sample <-
    read.csv(file=file.path(MDFCI.ext.dir, "../RawData", "Metadata",
                            "sample.csv"),
             stringsAsFactors = FALSE)

  metadataMDFCI <- merge(merge(metadataMDFCI_Sample,
                               metadataMDFCI_Outcome, all.x=TRUE, all.y=TRUE),
                         metadataMDFCI_Clinical, all.x=TRUE)

  table(metadataMDFCI$Title, metadataMDFCI$Platform)

  xx <- metadataMDFCI_Sample[metadataMDFCI_Sample$Title %in% metadataMDFCI$Title &
                               metadataMDFCI_Sample$Platform == "GPL570" , c(1, 2)]

  colnames(xx)[1] <- "HGU133Plus2"
  metadataMDFCI <- merge(metadataMDFCI, xx, all.x = TRUE)

  xx <- metadataMDFCI_Sample[metadataMDFCI_Sample$Title %in% metadataMDFCI$Title &
                               metadataMDFCI_Sample$Platform == "GPL6801" , c(1, 2)]

  colnames(xx)[1] <- "GenomeWideSNP6"
  metadataMDFCI <- merge(metadataMDFCI, xx, all.x = TRUE)


  xx <- metadataMDFCI_Sample[metadataMDFCI_Sample$Title %in% metadataMDFCI$Title &
                               metadataMDFCI_Sample$Platform == "GPL96" , c(1, 2)]

  colnames(xx)[1] <- "HGU133A"
  metadataMDFCI <- merge(metadataMDFCI, xx, all.x = TRUE)

  xx <- metadataMDFCI_Sample[metadataMDFCI_Sample$Title %in% metadataMDFCI$Title &
                               metadataMDFCI_Sample$Platform == "GPL97" , c(1, 2)]

  colnames(xx)[1] <- "HGU133B"
  metadataMDFCI <- merge(metadataMDFCI, xx, all.x = TRUE)




  metadataMDFCI <- metadataMDFCI[!duplicated(metadataMDFCI$Title),]

  metadataMDFCI$IPI <- as.factor(as.numeric(metadataMDFCI$IPI))

  metadataMDFCI$ipi.hl <- ifelse(is.na(metadataMDFCI$IPI), NA, "0-1")
  metadataMDFCI$ipi.hl[metadataMDFCI$IPI %in% c(2, 3)] <- "2-3"
  metadataMDFCI$ipi.hl[metadataMDFCI$IPI %in% c(4, 5)] <- "4-5"

  table(metadataMDFCI[, c("IPI", "ipi.hl")])

  Monti.Suppl5 <-
    read.delim("../Litterature/Monti_Suppl5_NIHMS398769-supplement-06(1).txt",
               stringsAsFactors = FALSE)

  rownames(Monti.Suppl5) <- Monti.Suppl5$CaseID

  colnames(Monti.Suppl5)[5] <- "WrightClass"



  metadataMDFCI <- merge(metadataMDFCI, Monti.Suppl5,
                         by.x = "Title", all.x=TRUE,
                         by.y = "CaseID")


  metadataMDFCI$TP53.mut[metadataMDFCI$TP53.mut == "na"] <- NA





  ABCGCBclass <- read.delim(file.path(MDFCI.ext.dir,
                                      "../ABCGCBclassification",
                                      "ABCGCBclass.txt"))
  metadataMDFCI$WrightClass_own <-
    ABCGCBclass[metadataMDFCI$Title,2]

  ABCGCBclass[paste(metadataMDFCI$GPL570, ".CEL", sep = ""),2]


  metadataMDFCI$OS <- Surv(metadataMDFCI$os/365.25, metadataMDFCI$Followup)

  os5  <- ifelse(metadataMDFCI$os/365.25 > 5, 5, metadataMDFCI$os/365.25)
  ios5 <- pmin(ifelse(metadataMDFCI$os/365.25 > 5, 0, 1), metadataMDFCI$Followup)

  metadataMDFCI$OS5 <- Surv(as.numeric(os5), ios5)


  metadataMDFCI$HGU133Plus2[metadataMDFCI$HGU133Plus2 == "GSM844275"] <- NA

  metadataMDFCI <- metadataMDFCI[, c(
    "Title", "Class", "os", "Followup", "Type", "Entity", "Primary",
    "IPI", "HGU133Plus2", "GenomeWideSNP6", "HGU133A", "HGU133B", "ipi.hl",
    "SNP.ScanID", "GEP.SampleID", "CCC..Best.10.13.", "WrightClass",
    "WrightClass_own", "TP53.mut")]

  return()
}
