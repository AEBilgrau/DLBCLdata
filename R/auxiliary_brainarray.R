cleanName <- function(array_type) {
  gsub("[-_]", "", tolower(array_type))
}

#' @export
listVersions <- function() {
  c("19.0.0", "18.0.0", "17.1.0", "17.0.0", "16.0.0", "15.1.0", "15.0.0",
    "14.1.0", "14.0.0", "13.0.0")
}

getSubversion <- function(version, n = 1) {
  return(as.numeric(unlist(strsplit(version, "\\.")))[n])
}

arrayToBrainarrayName <- function(array_type) {
  ans <- switch(array_type,
                "HuGene-1_0-st-v1" = "hugene10st",
                cleanName(array_type))
  return(ans)
}

getCustomCDFName <- function(brain_dat, array_type) {
  custom_cdf_name <-
    with(brain_dat, CustomCDFName[match(arrayToBrainarrayName(array_type),
                                        tolower(Chip))])
  return(custom_cdf_name)
}

getBrainarrayPackages <- function(brain_dat, array_type) {
  custom_cdf_name <- getCustomCDFName(brain_dat, array_type)
  r_packages <- paste0(cleanName(custom_cdf_name), c("cdf", "probe"))
  return(r_packages)
}

#' @importFrom XML readHTMLTable
getBrainarrayTargets <- function(version) {
  base_url <- paste0("http://brainarray.mbni.med.umich.edu/Brainarray/",
                     "Database/CustomCDF/CDF_download.asp")

  brain_dat <- readHTMLTable(base_url, stringsAsFactors = FALSE)
  brain_dat <- brain_dat[sapply(brain_dat, is.data.frame)]
  brain_dat <- brain_dat[-(1:2)]

  if (missing(version)) {
    ans <- as.character(brain_dat[[length(brain_dat)]][["Custom CDF"]])
  } else {
    v <- getSubversion(version, n = 1)
    ans <- as.character(brain_dat[[v]][["Custom CDF"]])
  }
  return(ans)
}


