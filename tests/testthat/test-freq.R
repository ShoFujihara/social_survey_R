test_that("freq returns correct structure", {
  df <- data.frame(x = c("A", "B", "A", "A", "B"))
  result <- freq(df, x, quiet = TRUE)

  expect_true(is.data.frame(result))
  expect_true("n" %in% names(result))
  expect_true("percent" %in% names(result))
})

test_that("freq calculates correct counts", {
  df <- data.frame(x = c("A", "B", "A", "A", "B"))
  result <- freq(df, x, quiet = TRUE)

  expect_equal(sum(result$n), 5)
})

test_that("freq handles NA values", {
  df <- data.frame(x = c("A", "B", NA, "A"))
  result <- freq(df, x, quiet = TRUE)

  expect_true(any(is.na(result$x)))
})

test_that("freq quiet parameter works", {
  df <- data.frame(x = c("A", "B", "A"))

  expect_output(freq(df, x, quiet = FALSE), "Variable")
  expect_silent(freq(df, x, quiet = TRUE))
})
