
#' @keywords internal
readBrainarrayTable <- function(custom_cdf, version = getLatestVersion()) {
  stopifnot(require("XML"))

  base_url <-
    paste0("http://brainarray.mbni.med.umich.edu/Brainarray/Database/",
           "CustomCDF/", version, "/" , custom_cdf)

  brain_dat <- readHTMLTable(paste0(base_url, ".asp"), skip.rows = 1,
                             stringsAsFactors = FALSE)[[2]]
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


