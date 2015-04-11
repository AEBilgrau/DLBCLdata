context("Download and process all DLBCL datasets")


data(DLBCL_overview)

if (deep_test) {  # deep_test is defined in ./test-all.R
  exclude <- character(0)
  for (geo_nbr in setdiff(DLBCL_overview$GSE, exclude)) {

    cat("\n\n\n\n\n\n\n\n #### ", geo_nbr, " #### \n\n\n\n")

    res <- downloadAndProcessGEO(geo_nbr = geo_nbr,
                                 cdf = "brainarray",
                                 target = "ensg",
                                 clean = FALSE)

    cat("\n", geo_nbr,  "downloaded and preprocessed successfully!\n")

    test_that(paste("downloadAndProcessGEO works for", geo_nbr), {
      expect_that(res, is_a("list"))
      expect_that(names(res), equals(c("es", "metadata", "call")))
      expect_that(res$es, is_a("list"))
      expect_that(res$metadata, is_a(geo_nbr))
      expect_that(res$metadata, is_a("data.frame"))
      expect_that(res$call, is_a("call"))

      # All expression values should not be na
      expect_that(all(sapply(res$es, inherits, "ExpressionSet")), is_true())
      expect_that(any(sapply(res$es, function(x) anyNA(exprs(x)))), is_false())
    })
  }
}

# GSE19246 downloaded and preprocessed successfully!
# GSE12195 downloaded and preprocessed successfully!
# GSE22895 downloaded and preprocessed successfully!
# GSE31312 downloaded and preprocessed successfully!
# GSE10846 downloaded and preprocessed successfully!
# GSE34171 downloaded and preprocessed successfully!
# GSE22470 downloaded and preprocessed successfully!
# GSE4475  downloaded and preprocessed successfully!
# GSE11318 downloaded and preprocessed successfully!
