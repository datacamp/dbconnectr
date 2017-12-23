creds <- list(a = 2, b = 3)
creds2 <- list(a = 2, b = 3)
cache_folder <- "~/.datacamp-test"
dbname <- "test-db"
cleanup <- function() {
  unlink(cache_folder, recursive = TRUE)
}
