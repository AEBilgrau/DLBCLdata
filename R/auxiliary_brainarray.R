#' @keywords internal
cleanName <- function(array_type) {
  gsub("[-_]", "", tolower(array_type))
}

#' @keywords internal
arrayToBrainarrayName <- function(array_type) {
  ans <- switch(array_type,
                "HuGene-1_0-st-v1" = "hugene10st",
                cleanName(array_type))
  return(ans)
}

#' @keywords internal
getCustomCDFName <- function(brain_dat, array_type) {
  custom_cdf_name <-
    with(brain_dat,
         CustomCDFName[match(arrayToBrainarrayName(array_type), tolower(Chip))])
  return(custom_cdf_name)
}

#' @keywords internal
getBrainarrayPackages <- function(brain_dat, array_type) {
  custom_cdf_name <- getCustomCDFName(brain_dat, array_type)
  r_packages <-
    paste0(cleanName(custom_cdf_name), c("cdf", "probe"))
  return(r_packages)
}




