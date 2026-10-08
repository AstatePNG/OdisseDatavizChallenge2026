source("api_connector.R")

city_api <- get_url_of("city_code_info")
city_api_data <- get_data_from(city_api)
