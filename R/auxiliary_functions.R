
basenameSansCEL <- function(x) {
  return(gsub("\\.cel", "", basename(x), ignore.case = TRUE))
}

getAffyTargets <- function() {
  message("Many 'older' arrays don't use targets. ")
  return(c("core", "full", "probesets"))
}

