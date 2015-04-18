#' Download and process all curated DLBCL datasets
#'
#' Automatically download and process all support curated DLBCL datasets.
#' Simply loops over all datasets in \code{data(dlbcl_overview)}.
#'
#' @param \dots Arguments passed to \link{\code{downloadAndProcessGEO}}.
#' @return Returns a \code{list} of the output of
#'   \link{\code{downloadAndProcessGEO}}.
#' @author
#'   Anders Ellern Bilgrau <abilgrau (at) math.aau.dk> \cr
#'   Steffen Falgreen Larsen <sfl (at) rn.dk>
#' @examples
#' listTargets("brainarray")
#' \dontrun{
#' # Preprocess with brainarray "Entrez" gene ids
#' res <- downloadAndProcessDLBCL(cdf = "brainarray", target = "ENTREZG",
#'                                clean = FALSE)
#'
#' # Preprocess with brainarray "Ensembl" gene ids
#' res2 <- downloadAndProcessDLBCL(cdf = "brainarray", target = "ENSG",
#'                                 clean = TRUE)
#'
#' # Preprocess with affy's probesets
#' res3 <- downloadAndProcessDLBCL()  #= downloadAndProcessDLBCL(cdf = "affy")
#' }
#' @export
downloadAndProcessDLBCL <- function(...) {
  st <- proc.time()
  cat("\nDownloading and processing all DLBCL dataset\n")

  data(DLBCL_overview)  # Load data overview

  res <- list()
  for (i in 1:nrow(DLBCL_overview)) {
    geo_nbr <- DLBCL_overview$GSE[i]
    stdy    <- DLBCL_overview$Study[i]

    cat(rep("\n", 4), "#### ", geo_nbr, " (", stdy,") ####",
        rep("\n", 3), sep = "")
    t <- system.time({
      res[[i]] <- downloadAndProcessGEO(geo_nbr = geo_nbr, ...)
    })

    cat("\n", geo_nbr,  " downloaded and preprocessed successfully in ",
        t[3] %/% 60, " minutes.\n", sep = "")
  }

  cat("\nFinished  in", (proc.time()-st)[3] %/% 60, "minutes.\n")
  return(res)
}
