context("Read all DLBCL classifications")
data(DLBCL_overview)

test_that("readDACData returns data.frame", {
  for (gse in DLBCL_overview$GSE[-9]) {
    expect_that(is.data.frame(readDACData(gse)), is_true())
  }
})
