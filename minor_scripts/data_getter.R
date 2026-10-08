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

simplified_frailty_prevalence <- frailty_prevalence |> 
  group_by(Année,Sexe,Âge) |> 
  filter(Âge!="55 ans et plus") |> 
  filter(Sexe!="Hommes et Femmes") |> 
  droplevels()

EDI_data <- edi_2021 |> 
  mutate(EDI = as.numeric(EDI))

EDI_data <- city_api_data |> 
  inner_join(data_temporary, join_by(codeDepartement == departement_code, code == Commune.Code))

EDI_range <- range(EDI_data$EDI, na.rm = TRUE)

APL_data <- apl_2023 |> 
  mutate(apl_mg_hmep = as.numeric(apl_mg_hmep)) |> 
  select(-an)

APL_data <- city_api_data |> 
  inner_join(APL_data, join_by(code == codgeo))

APL_range <- range(APL_data$apl_mg_hmep, na.rm = TRUE)
