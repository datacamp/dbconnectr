#' @importFrom jsonlite fromJSON
get_parameter <- function(name) {
  msg <- sprintf("Fetching %s from EC2 parameter store", name)
  message(msg)
  resp <- system2("aws", args = c("ssm", "get-parameter", "--with-decryption", "--name", name), stdout = TRUE)
  fromJSON(paste(resp, collapse = "\n"))$Parameter$Value
}

#' @export
get_databases <- function() {
  dbstring <- get_parameter("/dbconnect/dbnames")
  strsplit(dbstring, split = ",")[[1]]
}

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

#' @export
get_docs <- function(dbname = "main-app", open = TRUE) {
  url <- get_parameter(sprintf("/dbconnect/%s/docs", dbname))
  message("Opening database documentation...")
  if (open) browseURL(url)
  invisible(url)
}

