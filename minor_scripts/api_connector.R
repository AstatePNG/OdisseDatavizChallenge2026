library(dplyr)
library(httr2)
library(jsonlite)

api_list <- read.csv("data/api_list.csv")

####
# Search the api's url by its name
# input: api_name, the name of the api in the api_list
# output: the api's url
####
get_url_of <- function(api_name) {
  api_list |> 
    filter(API_NAME == api_name) |> 
    slice_head() |> 
    pull(URL)
}

####
# Get the data from an api and return it as a data frame
# input: api_request, the api request to execute
# output: the api request's result, formatted as a data frame
####
get_data_from <- function(api_request) {
  tryCatch({
    api_res <- api_request |> 
      request() |> 
      req_perform()

    resp_body_string(api_res) |> 
      fromJSON(simplifyVector = TRUE, flatten = TRUE) |> 
      as_tibble() |> 
      mutate(
        across(where(is.character), factor)
      )
  },
  error = function(e) {
    message("Erreur lors de la tentative d'accès à l'URL ", api_request)
  })
}
