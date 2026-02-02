test_that("prank works with basic input", {
  x <- c(10, 20, 20, 30, 40)
  result <- prank(x)

  expect_length(result, 5)
  expect_equal(result[1], 0)
  expect_equal(result[2], result[3])  # Ties get same rank
  expect_true(all(result >= 0 & result <= 1))
})

test_that("prank works with weights", {
  x <- c(10, 20, 20, 30, 40)
  w <- c(1, 2, 1, 3, 1)
  result <- prank(x, w)

  expect_length(result, 5)
  expect_equal(result[1], 0)
  expect_equal(result[2], result[3])  # Ties get same rank
})

test_that("prank handles NA values", {
  x <- c(10, NA, 20, 30)
  result <- prank(x)

  expect_true(is.na(result[2]))
  expect_false(is.na(result[1]))
  expect_false(is.na(result[3]))
})

test_that("prank returns NA when all weights are zero", {
  x <- c(10, 20, 30)
  w <- c(0, 0, 0)

  expect_warning(result <- prank(x, w), "Total weight is zero")
  expect_true(all(is.na(result)))
})

test_that("prank errors when lengths don't match", {
  x <- c(10, 20, 30)
  w <- c(1, 2)

  expect_error(prank(x, w), "same length")
})
