library(dplyr)
library(httr2)
library(jsonlite)

api_list <- read.csv("data/api_list.csv")

get_url_of <- function(api_name) {
  api_list |> 
    filter(API_NAME == api_name) |> 
    slice_head() |> 
    pull(URL)
}

get_data_from <- function(api_request) {
  tryCatch({
    api_res <- api_request |> 
      request() |> 
      req_perform()

    resp_body_string(api_res) |> 
      fromJSON(simplifyVector = TRUE, flatten = TRUE) |> 
      as_tibble()
  },
  error = function(e) {
    message("Erreur lors de la tentative d'accès à l'URL ", api_request)
  })
}
