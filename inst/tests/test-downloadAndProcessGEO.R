context("Download and process all DLBCL datasets")


data(DLBCL_overview)

if (deep_test) {  # deep_test is defined in ./test-all.R
  exclude <- character(0)
  for (gse in setdiff(DLBCL_overview$GSE, exclude)) {

    cat("\n\n\n\n\n\n\n\n #### ", gse, " #### \n\n\n\n")

    res <- downloadAndProcessGEO(geo_nbr = gse,
                                 cdf = "brainarray",
                                 target = "ensg",
                                 clean = FALSE)

    cat("\n", gse,  "downloaded and preprocessed successfully!\n")

    test_that(paste("downloadAndProcessGEO works for", gse), {
      expect_that(res, is_a("list"))
      expect_that(names(res), equals(c("es", "metadata", "call")))
      expect_that(res$es, is_a("list"))
      expect_that(res$metadata, is_a(gse))
      expect_that(res$metadata, is_a("data.frame"))
      expect_that(res$call, is_a("call"))

      # All expression values should not be na
      expect_that(all(sapply(res$es, inherits, "ExpressionSet")), is_true())
      expect_that(any(sapply(res$es, function(x) anyNA(exprs(x)))), is_false())
    })
  }
}

# GSE10846 OK
# GSE12195 OK
# GSE19246 OK
# GSE22895 OK
# GSE31312 OK
# GSE4475  OK
# GSE22470 OK (FIXED, PROBLEMS WITH FILENAMES vs GEONUMBERS)
# GSE34171 OK (FIXED ???) PROBLEMS WITH DOWNLOAD
# GSE11318 OK (FIXED ???)

#
# Warning messages:
#   1: In readLines(fname) :
#   incomplete final line found on 'C:/Users/Anders/Documents/GitHub/DLBCLdata/GSE19246/GSE19246_series_matrix.txt.gz'
# 2: In cleanMetadata.GSE10846(meta_data) : NAs introduced by coercion
# 3: In cleanMetadata.GSE10846(meta_data) : NAs introduced by coercion
# 4: In cleanMetadata.GSE10846(meta_data) : NAs introduced by coercion
# 5: In cleanMetadata.GSE10846(meta_data) : NAs introduced by coercion
# 6: In downloadAndProcessGEO(geo_nbr = gse, cdf = "brainarray", target = "ensg",  :
#                               Not all downloaded CEL files are in the metadata
#                             7: In downloadAndProcessGEO(geo_nbr = gse, cdf = "brainarray", target = "ensg",  :
#                                                           Not all downloaded CEL files are in the metadata
