test_that("varlist returns correct structure", {
  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  result <- varlist(df)

  expect_s3_class(result, "varlist")
  expect_equal(nrow(result), 2)
  expect_equal(result$variable, c("x", "y"))
})

test_that("varlist extracts labels", {
  df <- data.frame(x = 1:3)
  attr(df$x, "label") <- "Test Label"
  result <- varlist(df)

  expect_equal(unname(result$label[1]), "Test Label")
})

test_that("varlist includes value_labels when requested", {
  df <- data.frame(x = 1:3)
  # Set labels as named numeric vector (like haven format)
  labels_vec <- c(1, 3)
  names(labels_vec) <- c("Low", "High")
  attr(df$x, "labels") <- labels_vec

  result_without <- varlist(df, value_labels = FALSE)
  result_with <- varlist(df, value_labels = TRUE)

  expect_false("value_labels" %in% names(result_without))
  expect_true("value_labels" %in% names(result_with))
})

test_that("varlist errors for non-data.frame", {
  expect_error(varlist(1:10), "data frame")
})
