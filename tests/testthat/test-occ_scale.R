test_that("occ_scale adds .sei and .ssi columns for SSM codes", {
  df <- data.frame(ssm = c(501, 502, 503))
  result <- occ_scale(df, ssm, type = "ssm", quiet = TRUE)

  expect_true(".sei" %in% names(result))
  expect_true(".ssi" %in% names(result))
  expect_equal(nrow(result), 3)
  expect_false(any(is.na(result$.sei)))
  expect_false(any(is.na(result$.ssi)))
})

test_that("occ_scale adds .sei and .ssi columns for JESS codes", {
  df <- data.frame(occ = c(1, 2, 3))
  result <- occ_scale(df, occ, type = "jess", quiet = TRUE)

  expect_true(".sei" %in% names(result))
  expect_true(".ssi" %in% names(result))
  expect_false(any(is.na(result$.sei)))
})

test_that("occ_scale returns NA for unmatched codes", {
  df <- data.frame(ssm = c(501, 99999))
  result <- occ_scale(df, ssm, type = "ssm", quiet = TRUE)

  expect_false(is.na(result$.sei[1]))
  expect_true(is.na(result$.sei[2]))
  expect_true(is.na(result$.ssi[2]))
})

test_that("occ_scale messages about unmatched codes when quiet = FALSE", {
  df <- data.frame(ssm = c(501, 99999))
  expect_message(occ_scale(df, ssm, type = "ssm"), "unmatched")
})

test_that("occ_scale handles NA in codes", {
  df <- data.frame(ssm = c(501, NA, 502))
  result <- occ_scale(df, ssm, type = "ssm", quiet = TRUE)

  expect_false(is.na(result$.sei[1]))
  expect_true(is.na(result$.sei[2]))
  expect_false(is.na(result$.sei[3]))
})

test_that("occ_scale errors for missing column", {
  df <- data.frame(x = 1:3)
  expect_error(occ_scale(df, nonexistent, type = "ssm"), "not found")
})

test_that("occ_scale returns tibble", {
  df <- data.frame(ssm = c(501))
  result <- occ_scale(df, ssm, type = "ssm", quiet = TRUE)
  expect_true(tibble::is_tibble(result))
})

test_that("check_occ_scale finds unmatched codes", {
  df <- data.frame(ssm = c(501, 99999, 99999, 88888))
  result <- check_occ_scale(df, ssm, type = "ssm")

  expect_equal(nrow(result), 2)
  expect_true(99999 %in% result$code)
  expect_true(88888 %in% result$code)
})

test_that("check_occ_scale returns empty tibble when all match", {
  df <- data.frame(ssm = c(501, 502))
  expect_message(result <- check_occ_scale(df, ssm, type = "ssm"), "All codes matched")
  expect_equal(nrow(result), 0)
})

test_that("check_occ_scale ignores NA values", {
  df <- data.frame(ssm = c(501, NA))
  expect_message(result <- check_occ_scale(df, ssm, type = "ssm"), "All codes matched")
  expect_equal(nrow(result), 0)
})
