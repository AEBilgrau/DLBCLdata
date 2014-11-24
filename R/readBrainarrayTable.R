#' Reads table from brainarray homepage
#'
#' @examples
#' readBrainarrayTable("ENSG", version = "17.0.0")[1:10, 1:10]
#' readBrainarrayTable("ENST", version = "18.0.0")[1:10, 1:10]
#' readBrainarrayTable("ENSE", version = "19.0.0")[1:10, 1:10]
#' readBrainarrayTable("ENSG")[1:10, 1:10]
#' @importFrom XML readHTMLTable
#' @keywords internal
readBrainarrayTable <- function(custom_cdf, version = getLatestVersion()) {
  base_url <-
    paste0("http://brainarray.mbni.med.umich.edu/Brainarray/Database/",
           "CustomCDF/", version, "/" , custom_cdf)

  brain_dat <- readHTMLTable(paste0(base_url, ".asp"), skip.rows = 1,
                             stringsAsFactors = FALSE)[[2]]

  # Remove first row if the same as rownames
  if (rownames(brain_dat) == brain_dat[, 1]) {
    brain_dat <- brain_dat[, -1]
  }
  colnames(brain_dat) <-
    c("Species", "Chip", "OriginalProbeCount", "CustomCDFName",
      "StatsOfCurrentVersionProbe%", "StatsOfCurrentVersionProbeset#",
      "StatsOfPreviousVersionProbe%","StatsOfPreviousVersionProbeset#",
      "%OfCommonProbesInVersionCurrent",
      "%OfCommonProbesInVersionPrevious",
      "%OfCommonProbesetsInVersionCurrent",
      "%OfCommonProbesetsInVersionPrevious",
      "%OfIdenticalProbesetsInVersionCurrent",
      "%OfIdenticalProbesetsInVersionPrevious",
      "RPackagesSource", "RPackagesWin32", "CDFSeqMapDesc")

  attr(brain_dat, "base_url") <- base_url
  return(brain_dat)
}


