#' Download and process all curated DLBCL datasets
#'
#' Automatically download and process all support curated DLBCL datasets.
#' Simply loops over all datasets in \code{data(dlbcl_overview)}.
#'
#' @param \dots Arguments passed to \code{\link{downloadAndProcessGEO}}.
#' @return Saves a \code{list} of the processed datasets in the working
#'   directory named "dlbcl_data.Rds".
#'   Invisibly returns a \code{list} of the output of
#'   \code{\link{downloadAndProcessGEO}}.
#' @author
#'   Anders Ellern Bilgrau <abilgrau (at) math.aau.dk> \cr
#'   Steffen Falgreen Larsen <sfl (at) rn.dk>
#' @examples
#' listTargets("brainarray")
#' \dontrun{
#' # Warning, very long processing times if data is not downloaded.
#'
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
  message("\nDownloading and processing all DLBCL datasets\n")

  data(DLBCL_overview)  # Load data overview

  res <- list()
  for (i in 1:nrow(DLBCL_overview)) {
    geo_nbr <- as.character(DLBCL_overview$GSE[i])
    stdy    <- as.character(DLBCL_overview$Study[i])

    message(sprintf("\n\n\n\n #### %s (%s) ####\n\n\n", geo_nbr, stdy))

    t <- system.time({
      res[[i]] <- downloadAndProcessGEO(geo_nbr = geo_nbr, ...)
    })

    message(sprintf("\n %s finished successfully in %s minutes.\n",
                    geo_nbr, t[3] %/% 60))
  }

  names(res) <- as.character(DLBCL_overview$GSE)

  message("Saving all processed DLBCL data")
  saveRDS(res, file = file.path(getwd(), "dlbcl_data.Rds"))

  message("\nFinished  in ", (proc.time()-st)[3] %/% 60, " minutes.\n")
  return(invisible(res))
}
