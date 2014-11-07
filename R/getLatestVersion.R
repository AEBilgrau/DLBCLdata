# For future versions of DLBCLdata
# Currently a very hacky implementation
# @examples
# getLatestVersion()
getLatestVersion <- function() {
  base_url <-
    paste0("http://brainarray.mbni.med.umich.edu/Brainarray/",
           "Database/CustomCDF/CDF_download.asp")

  brain_dat <- readHTMLTable(base_url, stringsAsFactors = FALSE)
  brain_dat <- brain_dat[sapply(brain_dat, is.list)][-(1:2)]

  vX.0.0 <- length(brain_dat)
  v0.X.0 <- sum(grepl("Click", brain_dat[[vX.0.0]][1,])) - 1
  v0.0.X <- 0

  return(paste(vX.0.0, v0.X.0, v0.0.X, sep = "."))
}


