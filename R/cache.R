cache_ttl_hours <- 24

get_cache_file <- function(cache_folder, dbname) {
  file.path(cache_folder, paste0(dbname, ".yml"))
}

get_cached_creds <- function(cache_folder, dbname, ttl_sec = cache_ttl_hours * 60 * 60) {
  res <- read_cache_file(cache_folder, dbname)
  if(is.null(res)) {
    return(NULL)
  }
  if(as.integer(Sys.time()) - res$timestamp > ttl_sec) {
    return(NULL)
  }
  res["timestamp"] <- NULL
  return(res)
}

#' @importFrom yaml yaml.load_file
read_cache_file <- function(cache_folder, dbname) {
  if (!dir.exists(cache_folder)) {
    return(NULL)
  }
  cache_file <- get_cache_file(cache_folder, dbname)
  if (!file.exists(cache_file)) {
    return(NULL)
  }
  return(yaml::yaml.load_file(cache_file))
}

#' @importFrom yaml as.yaml
cache_creds <- function(creds, cache_folder, dbname) {
  creds$timestamp <- Sys.time()
  dir.create(cache_folder, showWarnings = FALSE)
  write(yaml::as.yaml(creds), file = get_cache_file(cache_folder, dbname))
}
