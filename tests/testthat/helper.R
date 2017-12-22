creds <- list(a = 2, b = 3)
creds2 <- list(a = 2, b = 3)
cache_folder <- tempdir()
dbname <- "test-db"
cleanup <- function() {
  unlink(cache_folder, recursive = TRUE)
}
