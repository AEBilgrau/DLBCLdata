
basenameSansCEL <- function(x) {
  gsub("\\.cel", "", basename(x), ignore.case = TRUE)
}

