#' Get credentials
#'
#' @param dbname character string specifying the database you want to get the credentials for. Use \code{\link{get_databases}} to get a list of available databases.
#' @param cache boolean that specifies whether or not to fetch and store the credentials in a local cache.
#' @param cache_folder if caching is enabled, where to store and fetch the credentials
#'
#' @return list with credentials for specified database
#' @export
get_creds <- function(dbname = "main-app", cache = FALSE, cache_folder = "~/.datacamp") {
  creds <- NULL
  if (cache) {
    creds <- get_cached_creds(cache_folder, dbname)
  }
  if (is.null(creds)) {
    creds <- fetch_creds(dbname)
    # only cache when not cached before
    if (cache) {
      cache_creds(creds, cache_folder, dbname)
    }
  }
  return(creds)
}

fetch_creds <- function(dbname = "main-app") {
  fields <- c(user = "user", password = "password", host = "endpoint", port = "port", dbname = "database", drv = "type")
  creds <- lapply(fields, function(field) {
    name <- sprintf("/dbconnect/%s/%s", dbname, field)
    get_parameter(name)
  })
}

transform_creds <- function(creds) {
  creds[["port"]] <- as.integer(creds[["port"]])
  creds[["drv"]] <- if (creds[["drv"]] == "mysql") RMySQL::MySQL() else RPostgres::Postgres()
  creds
}
