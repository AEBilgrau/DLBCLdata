context("Read all DLBCL classifications")
data(DLBCL_overview)

test_that("readDACData returns a data.frame", {
  for (gse in DLBCL_overview$GSE) {
    if (gse == "GSE11318") {
      next
    }
    expect_true(is.data.frame(readDACData(gse)))
  }
})

test_that("readDACData returns null GSE11318 and other names ", {
  expect_null(readDACData("GSE11318"))
  expect_null(readDACData("someothername"))
})
