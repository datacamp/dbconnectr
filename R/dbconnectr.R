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
  creds <- get_creds(dbname)
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

#' Get credentials from AWS
#'
#' @param dbname character string specifying the database you want to get the credentials for. Use \code{\link{get_databases}} to get a list of available databases.
#'
#' @return list with credentials for specified database
#' @export
get_creds <- function(dbname = "main-app") {
  fields <- c(user = "user", password = "password", host = "endpoint", port = "port", dbname = "database", drv = "type")
  creds <- lapply(fields, function(field) {
    name <- sprintf("/dbconnect/%s/%s", dbname, field)
    get_parameter(name)
  })
  creds[["port"]] <- as.integer(creds[["port"]])
  creds
}

#' Save credentials as yaml for a database
#'
#' @param creds \code{\link{get_creds}} to get a list of credentials to save
#' @param dbname Use \code{\link{get_databases}} to get a list of available databases to pick one from
#' @param path Specify the path to save the credentials to
#'
#' @return
#' @export
save_creds_yml <- function(creds, dbname = "main-app", path = "~/") {
  file_name <- paste0(dbname, ".yml")
  write(yaml::as.yaml(creds), file.path(path, file_name))
}

#' Update all local credential files, useful when things need to go fast.
#'
#' Run daily to ensure up-to-date credentials (Old credentials will be valid 48h after rotation).
#'
#' @param path character string specifying the (safe) location for storing the credential files
#' @export
update_cred_yamls <- function(path = "~/") {
  databases <- as.list(get_databases())
  invisible(
    lapply(databases, function(database) {
      creds <- get_creds(dbname = database)
      save_creds_yml(creds = creds, dbname = database, path)
    })
  )
}

