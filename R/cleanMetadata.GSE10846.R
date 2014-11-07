#' Specific function for cleaning GSE10846
#' @param meta_data A \code{data.frame} as returned by
#'   \code{\link{downloadAndPreparemeta_data}}.
#' @param A clean \code{data.frame}.
#' @export
cleanMetadata.GSE10846 <- function(meta_data) {
  message("Cleaning GSE10846!")

  # Helper function
  cleanUp <- function(x){
    x <- as.character(x)
    x.list <- strsplit(x, ":")
    l <- length(x.list[[1]])
    x.mat <- t(do.call(cbind, x.list))
    gsub(" ", "", x.mat)[, l]
  }

  meta_data <- apply(meta_data, 2, as.character)
  meta_data <- as.data.frame(meta_data[1:414, ], stringsAsFactors = FALSE)

  GEO.ID <- meta_data$geo_accession
  id     <- gsub("Individual: ", "", meta_data$source_name_ch1)
  gender <- gsub("Gender: ",     "", meta_data$characteristics_ch1)
  age    <- gsub("Age: ",        "", meta_data$characteristics_ch1.1)
  tissue <- gsub("Tissue: ",     "", meta_data$characteristics_ch1.2)

  disease.state        <- gsub("Disease state: ",
                               "", meta_data$characteristics_ch1.3)
  Submitting.diagnosis <- gsub("Clinical info: Submitting diagnosis: ",
                               "", meta_data$characteristics_ch1.5)
  microarray.diagnosis <- gsub("Clinical info: Final microarray diagnosis: ",
                               "", meta_data$characteristics_ch1.6)
  microarray.diagnosis <- gsub(" DLBCL", "", microarray.diagnosis)

  status <- gsub("Clinical info: Follow up status: ",
                 "", meta_data$characteristics_ch1.7)
  FU     <- gsub("Clinical info: Follow up years: ",
                 "", meta_data$characteristics_ch1.8)
  chemo  <- gsub("Clinical info: Chemotherapy: ",
                 "", meta_data$characteristics_ch1.9)

  chemo  <- gsub("-Like Regimen", "", chemo)

  ECOG   <- gsub("Clinical info: ECOG performance status: ",
                 "", meta_data$characteristics_ch1.10)
  stage  <- gsub("Clinical info: Stage: ",
                 "", meta_data$characteristics_ch1.11)
  LDH    <- gsub("Clinical info: LDH ratio: ",
                 "", meta_data$characteristics_ch1.12)

  No.Extra.Nodal       <- gsub("Clinical info: Number of extranodal sites: ",
                               "", meta_data$characteristics_ch1.13)


  meta_dataLLMPP <- data.frame(id, GEO.ID, gender, as.numeric(age), status,
                              FU, chemo, tissue,
                              disease.state, Submitting.diagnosis,
                              microarray.diagnosis, ECOG, stage, LDH,
                              No.Extra.Nodal = No.Extra.Nodal)

  colnames(meta_dataLLMPP) <- c("id", "GEO.ID", "gender", "age",
                               "survival.status", "FU", "chemo", "tissue",
                               "disease.state", "Submitting.diagnosis",
                               "microarray.diagnosis", "ECOG", "stage",
                               "LDH", "No.Extra.Nodal")

  meta_dataLLMPP$FU <- as.numeric(as.character(meta_dataLLMPP$FU))
  meta_dataLLMPP$stage <- as.numeric(as.character(meta_dataLLMPP$stage))
  meta_dataLLMPP$age   <- as.numeric(as.character(meta_dataLLMPP$age))
  meta_dataLLMPP$No.Extra.Nodal <- as.numeric(as.character(meta_dataLLMPP$No.Extra.Nodal))
  meta_dataLLMPP$ECOG <- as.numeric(as.character(meta_dataLLMPP$ECOG))
  meta_dataLLMPP$LDH  <- as.numeric(as.character(meta_dataLLMPP$LDH))
  ipi <- IPI(meta_dataLLMPP$age,   meta_dataLLMPP$ECOG,
             meta_dataLLMPP$stage, meta_dataLLMPP$No.Extra.Nodal,
             meta_dataLLMPP$LDH)

  meta_dataLLMPP$ipi    <- as.factor(ipi$ipi)
  meta_dataLLMPP$ipi.hl <- as.factor(ipi$ipi.hl)

  meta_dataLLMPP$ipi.hl <- as.character(meta_dataLLMPP$ipi)
  meta_dataLLMPP$ipi.hl[meta_dataLLMPP$ipi %in% c(0, 1)] <- "0-1"
  meta_dataLLMPP$ipi.hl[meta_dataLLMPP$ipi %in% c(2, 3)] <- "2-3"
  meta_dataLLMPP$ipi.hl[meta_dataLLMPP$ipi %in% c(4, 5)] <- "4-5"

  meta_dataLLMPP$ipi.hl2 <- meta_dataLLMPP$ipi.hl

  meta_dataLLMPP$ipi.hl2[ipi$ipi.na == 0 & ipi$na.1] <- "0-1"
  meta_dataLLMPP$ipi.hl2[ipi$ipi.na == 2 & ipi$na.1] <- "2-3"
  meta_dataLLMPP$ipi.hl2[ipi$ipi.na == 4 & ipi$na.1] <- "4-5"


  table(w.na = meta_dataLLMPP$ipi.hl2, wo.na = meta_dataLLMPP$ipi.hl, useNA="ifany")


  # Creating survival objects
  meta_dataLLMPP$OS <- Surv(meta_dataLLMPP$FU,
                           meta_dataLLMPP$survival.status == "DEAD")

  os5  <- ifelse(meta_dataLLMPP$FU > 5, 5, meta_dataLLMPP$FU)
  ios5 <- pmin(ifelse(meta_dataLLMPP$FU > 5, 0, 1), meta_dataLLMPP$OS[,2])

  meta_dataLLMPP$OS5  <- Surv(as.numeric(os5), ios5)

  meta_dataLLMPP$WrightClass  <- meta_dataLLMPP$microarray.diagnosis
  meta_dataLLMPP$WrightClass2 <- as.character(meta_dataLLMPP$WrightClass)
  meta_dataLLMPP$WrightClass2 <-
    as.factor(gsub("Unclassified", "UC", meta_dataLLMPP$WrightClass2))


  row.names(meta_dataLLMPP) <- paste(meta_dataLLMPP$GEO.ID, ".CEL",sep = "")

  clean_meta_data <- meta_dataLLMPP

  return(clean_meta_data)
}
