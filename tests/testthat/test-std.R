test_that("std creates z-scores by default", {
  x <- c(10, 20, 30, 40, 50)
  result <- std(x)

  expect_equal(mean(result), 0, tolerance = 1e-10)
  expect_equal(sd(result), 1, tolerance = 1e-10)
})

test_that("std creates T-scores when specified", {
  x <- c(10, 20, 30, 40, 50)
  result <- std(x, mean = 50, sd = 10)

  expect_equal(mean(result), 50, tolerance = 1e-10)
  expect_equal(sd(result), 10, tolerance = 1e-10)
})

test_that("std handles NA values", {
  x <- c(10, 20, NA, 40, 50)
  result <- std(x)

  expect_true(is.na(result[3]))
  expect_false(any(is.na(result[-3])))
})

test_that("std warns for zero variance", {
  x <- rep(5, 10)

  expect_warning(result <- std(x), "zero")
  expect_true(all(is.na(result)))
})

test_that("std errors for non-numeric input", {
  x <- c("a", "b", "c")

  expect_error(std(x), "numeric")
})
