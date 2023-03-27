#' Get credentials
#'
#' @param dbname character string specifying the database you want to get the credentials for. Use \code{\link{get_databases}} to get a list of available databases.
#' @param cache boolean that specifies whether or not to fetch and store the credentials in a local cache.
#' @param cache_folder if caching is enabled, where to store and fetch the credentials
#' @param ... Extra arguments passed to aws, such as \code{profile} or \code{region}
#'
#' @return list with credentials for specified database
#' @export
get_creds <- function(dbname = "main-app", cache = FALSE, cache_folder = "~/.datacamp", ...) {
  creds <- NULL
  if (cache) {
    creds <- get_cached_creds(cache_folder, dbname)
  }
  if (is.null(creds)) {
    creds <- fetch_creds(dbname, ...)
    # only cache when not cached before
    if (cache) {
      cache_creds(creds, cache_folder, dbname)
    }
  }
  return(creds)
}

cred_fields <- c(user = "user", password = "password", host = "endpoint", port = "port", drv = "type")

fetch_creds <- function(dbname = "main-app", ...) {
  print("Fetching credentials...")
  # athena needs a different set of parameters
  # May be worth having a database-level parameter that lists all the parameters

  if (stringr::str_detect(dbname, "athena")) {
    fields <- c(cred_fields, s3_staging = "s3-staging")
  } else {
    fields <- c(cred_fields, dbname = "database")
  }

  names <- paste("/dbconnect", dbname, fields, sep = "/")

  creds <- get_parameters(names, ...)[["Parameters"]]

  if (length(creds) == 0) {
    stop("Credentials for DB ", dbname, " not found")
  }

  # return as a list, named according to the above fields
  field_values <- as.list(creds$Value[match(names, creds$Name)])
  names(field_values) <- names(fields)

  if (Sys.getenv("DOCKER_DASHBOARDS") == "1"){
    print("Running Dashboards, so using global creds")
    field_values

  } else if (Sys.getenv("SHINY_SERVER") == "" && Sys.getenv("AIRFLOW") == ""){
    print("Running locally, so using personal creds")
    creds_user <- aws_get_credentials()
    field_values$user <- creds_user$DbUser
    field_values$password <- creds_user$DbPassword
  }

  field_values
}

get_env_overwrite <- function(key, value) {
  # Don't overwrite the "drv" field
  if (key == "drv") {
    return(value)
  }

  # Use cred_fields list to create environment variable (e.g. DBCONNECT_ENDPOINT)
  env_variable <- tryCatch(
    paste0("DBCONNECT_", toupper(cred_fields[[key]])),
    error=function(...) NULL
  )
  if (is.null(env_variable)) {
    return(value)
  }

  # Get the environment variable, fallback on value
  Sys.getenv(env_variable, value)
}

transform_creds <- function(creds) {
  creds[["port"]] <- as.integer(creds[["port"]])

  if (creds[["drv"]] == "awsathena") {
    creds <- list(drv = creds[["drv"]],
                  driver = "Simba Athena ODBC Driver",
                  UID = creds[["user"]],
                  PWD = creds[["password"]],
                  AwsRegion = stringr::str_split(creds[["host"]], "\\.")[[1]][2],
                  S3OutputLocation = creds[["s3_staging"]])
  }

  if (creds[["drv"]] == "mysql") {
    creds[["username"]] <- creds[["user"]]
  }

  drv <- switch(creds[["drv"]],
                mysql = RMariaDB::MariaDB(),
                postgresql = RPostgres::Postgres(),
                redshift = RPostgres::Postgres(),
                awsathena = odbc::odbc(),
                NULL)

  if (is.null(drv)) {
    stop("Unknown driver:", drv)
  }

  creds[["drv"]] <- drv

  mapply(get_env_overwrite, names(creds), creds)
}
