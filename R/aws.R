#' @importFrom jsonlite fromJSON
get_parameter <- function(name) {
  msg <- sprintf("Fetching %s from EC2 parameter store", name)
  message(msg)
  resp <- system2("aws", args = c("ssm", "get-parameter", "--with-decryption", "--name", name), stdout = TRUE)
  fromJSON(paste(resp, collapse = "\n"))$Parameter$Value
}

#' @importFrom jsonlite fromJSON
get_parameters <- function(names) {
  msg <- sprintf("Fetching %s... from EC2 parameter store", names[1])

  n <- paste0('"', names, '"', collapse = " ")

  message(msg)
  resp <- system2("aws", args = c("ssm", "get-parameters", "--with-decryption", "--names", names), stdout = TRUE)
  fromJSON(paste(resp, collapse = "\n"))
}
