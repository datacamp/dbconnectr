context("creds")

test_that("get_creds works without caching", {
  with_mock(
    fetch_creds = function(dbname) creds,
    expect_equal(get_creds(dbname), creds),
    .env = "dbconnectr"
  )
  with_mock(
    fetch_creds = function(dbname) creds2,
    expect_equal(get_creds(dbname), creds2),
    .env = "dbconnectr"
  )
})

test_that("get_creds works with caching", {
  with_mock(
    fetch_creds = function(dbname) creds,
    expect_equal(get_creds(dbname, cache_folder = cache_folder, cache = TRUE), creds),
    .env = "dbconnectr"
  )
  with_mock(
    fetch_creds = function(dbname) creds2,
    expect_equal(get_creds(dbname, cache_folder = cache_folder, cache = TRUE), creds),
    .env = "dbconnectr"
  )
  cleanup()
})

