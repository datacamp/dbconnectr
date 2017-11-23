#' @importFrom jsonlite fromJSON
get_parameter <- function(name) {
  msg <- sprintf("Fetching %s from EC2 parameter store", name)
  message(msg)
  resp <- system2("aws", args = c("ssm", "get-parameter", "--with-decryption", "--name", name), stdout = TRUE)
  fromJSON(paste(resp, collapse = "\n"))$Parameter$Value
}

#' Get a list of all databases.
#'
#' @export
get_databases <- function() {
  dbstring <- get_parameter("/dbconnect/dbnames")
  strsplit(dbstring, split = ",")[[1]]
}

#' Create a DBI connection to a database.
#'
#' @param dbname character string specifying the database you want to connect to. Use \code{\link{get_databases}} to get a list of available databases.
#' @export
#' @importFrom DBI dbConnect
create_connection <- function(dbname = "main-app") {
  fields <- c(user = "user", password = "password", host = "endpoint", port = "port", dbname = "database", drv = "type")
  creds <- lapply(fields, function(field) {
    name <- sprintf("/dbconnect/%s/%s", dbname, field)
    get_parameter(name)
  })
  creds[["port"]] <- as.numeric(creds[["port"]])
  creds[["drv"]] <- if(creds[["drv"]] == "mysql") RMySQL::MySQL() else RPostgres::Postgres()
  do.call(DBI::dbConnect, creds)
}

#' Open up the documentation of a database
#'
#' @param dbname character string specifying the database you want to connect to. Use \code{\link{get_databases}} to get a list of available databases.
#' @param open boolean denoting whether or not to open the URL.
#' @return The database documentation URL (invisibly).
#' @export
#' @importFrom utils browseURL
get_docs <- function(dbname = "main-app", open = TRUE) {
  url <- get_parameter(sprintf("/dbconnect/%s/docs", dbname))
  message("Opening database documentation...")
  if (open) browseURL(url)
  invisible(url)
}

