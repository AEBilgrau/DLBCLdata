#' Get latest brainarray version number
#'
#' Currently a very hacky implementation. To be updated later. The function
#' currently reads the tables available at
#' \url{http://brainarray.mbni.med.umich.edu/Brainarray/Database/CustomCDF/CDF_download.asp}
#' to determine the latest version
#'
#' @return Returns a string on the form X.Y.Z giving the latest version.
#' @examples
#' getLatestVersion()
#' @export
getLatestVersion <- function() {
  base_url <-
    paste0("http://brainarray.mbni.med.umich.edu/Brainarray/",
           "Database/CustomCDF/CDF_download.asp")

  brain_dat <- readHTMLTable(base_url, stringsAsFactors = FALSE)
  brain_dat <- brain_dat[sapply(brain_dat, is.list)][-(1:2)]

  vX.0.0 <- length(brain_dat)
  tmp <- brain_dat[[vX.0.0]]
  v0.X.0 <- sum(grepl("Click", tmp[nrow(tmp),])) - 1
  v0.0.X <- 0

  return(paste(vX.0.0, v0.X.0, v0.0.X, sep = "."))
}


