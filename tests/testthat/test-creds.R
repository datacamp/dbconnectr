context("creds")

test_that("get_creds works without caching", {
  testthat::with_mock(
    fetch_creds = function(dbname) creds,
    expect_equal(get_creds(dbname), creds)
  )
  testthat::with_mock(
    fetch_creds = function(dbname) creds2,
    expect_equal(get_creds(dbname), creds2)
  )
})

test_that("get_creds works with caching", {
  testthat::with_mock(
    fetch_creds = function(dbname) creds,
    expect_equal(get_creds(dbname, cache_folder = cache_folder, cache = TRUE), creds)
  )
  testthat::with_mock(
    fetch_creds = function(dbname) creds2,
    expect_equal(get_creds(dbname, cache_folder = cache_folder, cache = TRUE), creds)
  )
  cleanup()
})

