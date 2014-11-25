#' @rdname cleanMetadata
#' @details
#'    GSE10846:\cr
#'    The cleanup of GSE10846 (LLMPP) adds two batches corresponding to each
#'    the CHOP and the R-CHOP cohort.
#' @export
cleanMetadata.GSE10846 <- function(meta_data) {
  message("Cleaning GSE10846 (LLMPP)!")

  stopifnot(require(survival))

  # Helper functions
  wo.na <- function(x) sum(x[!is.na(x)])
  n.is.na <- function(x) sum(is.na(x))
  IPI <- function(age, ECOG, stage, No.Extra.Nodal, LDH) {
    a <- ifelse(age            >  60, 1, 0)
    b <- ifelse(ECOG           >   1, 1, 0)
    c <- ifelse(No.Extra.Nodal >=  2, 1, 0)
    d <- ifelse(stage          >   2, 1, 0)
    e <- ifelse(LDH            >   1, 1, 0)

    ipi <- data.frame(a = a, b = b, c = c, d = d, e = e)
    score  <- apply(ipi, 1, sum)
    score2 <- apply(ipi, 1, wo.na)
    n.NA   <- apply(ipi, 1, n.is.na) == 1
    n.NA2  <- apply(ipi, 1, n.is.na) == 2

    ipi.hl <- rep(NA, length(n.NA))
    ipi.hl[score %in% c(0, 1, 2)] <- 0
    ipi.hl[score %in% c(3, 4, 5)] <- 1


    ipi.hl2 <- rep(NA, length(n.NA))
    ipi.hl2[score2 %in% c(0, 1, 2)] <- 0
    ipi.hl2[score2 %in% c(3, 4, 5)] <- 1


    ipi.hl[n.NA & score2 %in% c(0, 1, 3, 4) ] <-
      ipi.hl2[n.NA & score2 %in% c(0, 1, 3, 4) ]

    ipi.hl[n.NA2 & score2 %in% c(0, 3) ] <-
      ipi.hl2[n.NA2 & score2 %in% c(0, 3) ]

    return(list(ipi = score, ipi.hl = ipi.hl, na.1 = n.NA, ipi.na = score2))
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

  No.Extra.Nodal <- gsub("Clinical info: Number of extranodal sites: ",
                         "", meta_data$characteristics_ch1.13)


  metadataLLMPP <- data.frame(id, GEO.ID, gender, as.numeric(age), status,
                              FU, chemo, tissue,
                              disease.state, Submitting.diagnosis,
                              microarray.diagnosis, ECOG, stage, LDH,
                              No.Extra.Nodal = No.Extra.Nodal)

  colnames(metadataLLMPP) <- c("id", "GEO.ID", "gender", "age",
                               "survival.status", "FU", "chemo", "tissue",
                               "disease.state", "Submitting.diagnosis",
                               "microarray.diagnosis", "ECOG", "stage",
                               "LDH", "No.Extra.Nodal")

  metadataLLMPP$FU <- as.numeric(as.character(metadataLLMPP$FU))
  metadataLLMPP$stage <- as.numeric(as.character(metadataLLMPP$stage))
  metadataLLMPP$age   <- as.numeric(as.character(metadataLLMPP$age))
  metadataLLMPP$No.Extra.Nodal <- as.numeric(as.character(metadataLLMPP$No.Extra.Nodal))
  metadataLLMPP$ECOG <- as.numeric(as.character(metadataLLMPP$ECOG))
  metadataLLMPP$LDH  <- as.numeric(as.character(metadataLLMPP$LDH))
  ipi <- IPI(metadataLLMPP$age,   metadataLLMPP$ECOG,
             metadataLLMPP$stage, metadataLLMPP$No.Extra.Nodal,
             metadataLLMPP$LDH)

  metadataLLMPP$ipi    <- as.factor(ipi$ipi)
  metadataLLMPP$ipi.hl <- as.factor(ipi$ipi.hl)

  metadataLLMPP$ipi.hl <- as.character(metadataLLMPP$ipi)
  metadataLLMPP$ipi.hl[metadataLLMPP$ipi %in% c(0, 1)] <- "0-1"
  metadataLLMPP$ipi.hl[metadataLLMPP$ipi %in% c(2, 3)] <- "2-3"
  metadataLLMPP$ipi.hl[metadataLLMPP$ipi %in% c(4, 5)] <- "4-5"

  metadataLLMPP$ipi.hl2 <- metadataLLMPP$ipi.hl

  metadataLLMPP$ipi.hl2[ipi$ipi.na == 0 & ipi$na.1] <- "0-1"
  metadataLLMPP$ipi.hl2[ipi$ipi.na == 2 & ipi$na.1] <- "2-3"
  metadataLLMPP$ipi.hl2[ipi$ipi.na == 4 & ipi$na.1] <- "4-5"

  # Creating survival objects
  metadataLLMPP$OS <- Surv(metadataLLMPP$FU,
                            metadataLLMPP$survival.status == "DEAD")

  os5  <- ifelse(metadataLLMPP$FU > 5, 5, metadataLLMPP$FU)
  ios5 <- pmin(ifelse(metadataLLMPP$FU > 5, 0, 1), metadataLLMPP$OS[,2])

  metadataLLMPP$OS5  <- Surv(as.numeric(os5), ios5)

  metadataLLMPP$WrightClass  <- metadataLLMPP$microarray.diagnosis
  metadataLLMPP$WrightClass2 <- as.character(metadataLLMPP$WrightClass)
  metadataLLMPP$WrightClass2 <-
    as.factor(gsub("Unclassified", "UC", metadataLLMPP$WrightClass2))

  rownames(metadataLLMPP) <- paste(metadataLLMPP$GEO.ID, ".CEL",sep = "")

  # Added factor describing the batches and CEL files
  metadataLLMPP$Batch <- as.factor(metadataLLMPP$chemo)
  metadataLLMPP$CEL   <- rownames(metadataLLMPP)
  metadataLLMPP$GSM   <- as.character(metadataLLMPP$GEO.ID)

  return(metadataLLMPP)
}
