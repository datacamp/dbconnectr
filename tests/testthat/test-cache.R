context("cache")

test_that("storing list in cache works", {
  cache_creds(creds, cache_folder, dbname)
  cache_file <- get_cache_file(cache_folder, dbname)
  expect_true(file.exists(get_cache_file(cache_folder, dbname)))
  cached_creds <- yaml::yaml.load_file(get_cache_file(cache_folder, dbname))
  expect_equal(creds$a, cached_creds$a)
  expect_equal(creds$b, cached_creds$b)
  expect_true("timestamp" %in% names(cached_creds))
  cleanup()
})

test_that("get_cached_creds returns NULL if no cache, creds if cache", {
  cached_creds <- get_cached_creds(cache_folder, dbname)
  expect_true(is.null(cached_creds))
  dir.create(cache_folder)
  cached_creds <- get_cached_creds(cache_folder, dbname)
  expect_true(is.null(cached_creds))
  cache_creds(creds, cache_folder, dbname)
  cached_creds <- get_cached_creds(cache_folder, dbname)
  expect_equal(creds, cached_creds)
  cached_creds <- get_cached_creds(cache_folder, dbname, ttl_sec = -1)
  expect_true(is.null(cached_creds))
  cleanup()
})

