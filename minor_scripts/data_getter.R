source("minor_scripts/api_connector.R")

city_api_data <- get_url_of("city_code_info") |>
  get_data_from()

death_rate_per_categories <- read.table("data/CS_detaillee.csv", sep = ";", dec = ",",
                                    header = TRUE, stringsAsFactors = TRUE,
                                    fileEncoding = "Latin1", strip.white = TRUE)

death_rate_per_diploma <- read.table("data/DIP.csv", sep = ";", dec = ",", header = TRUE,
                              stringsAsFactors = TRUE, fileEncoding = "UTF-8", strip.white = TRUE)

death_cause <- read.table("data/cause_deces.csv", sep = ";", dec = ",", header = TRUE,
                        stringsAsFactors = TRUE, fileEncoding = "Latin1", strip.white = TRUE)

frailty_prevalence <- read.table("data/fragilite_prevalence_france.csv", sep = ",",
                                header = TRUE, stringsAsFactors = TRUE, strip.white = TRUE)

edi_2021 <- read.table("data/f_edi_2021_par_commune.csv", sep = ",", header = TRUE,
                  stringsAsFactors = TRUE, fill = TRUE, strip.white = TRUE)

apl_2023 <- read.table("data/Accessibilite_potentielle_localisee_mg_2023.txt",
                    sep = "\t", dec = ",", header = TRUE, stringsAsFactors = TRUE)