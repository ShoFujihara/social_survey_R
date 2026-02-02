test_that("quantile_group creates correct number of groups", {
  x <- 1:100
  result <- quantile_group(x, 4)

  expect_length(result, 100)
  expect_equal(sort(unique(result)), 1:4)
})

test_that("quantile_group handles NA values", {
  x <- c(1, 2, NA, 4, 5)
  result <- quantile_group(x)

  expect_true(is.na(result[3]))
  expect_false(any(is.na(result[-3])))
})

test_that("quantile_group warns for identical values", {
  x <- rep(5, 10)

  expect_warning(result <- quantile_group(x), "identical")
  expect_true(all(result == 1))
})

test_that("quantile_group errors for non-numeric input", {
  x <- c("a", "b", "c")

  expect_error(quantile_group(x), "numeric")
})

test_that("quantile_group errors for n < 2", {
  x <- 1:10

  expect_error(quantile_group(x, 1), "at least 2")
})
