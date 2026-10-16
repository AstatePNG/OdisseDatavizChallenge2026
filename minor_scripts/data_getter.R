library(data.table)
source("minor_scripts/api_connector.R")

city_api_data <- get_url_of("city_code_info") |>
  get_data_from()

death_rate_per_categories <- read.table("data/CS_detaillee.csv", sep = ";", dec = ",",
                                    header = TRUE, stringsAsFactors = TRUE,
                                    fileEncoding = "Latin1", strip.white = TRUE, quote = "")

death_rate_per_diploma <- read.table("data/DIP.csv", sep = ";", dec = ",", header = TRUE,
                              stringsAsFactors = TRUE, fileEncoding = "UTF-8", strip.white = TRUE, quote = "",
                              na.strings = "-")

death_cause <- read.table("data/cause_deces.csv", sep = ";", dec = ",", header = TRUE,
                        stringsAsFactors = TRUE, fileEncoding = "Latin1", strip.white = TRUE, quote = "")

frailty_prevalence <- read.table("data/fragilite_prevalence_france.csv", sep = ",",
                                header = TRUE, stringsAsFactors = TRUE, strip.white = TRUE, quote = "")

edi_2021 <- read.table("data/f_edi_2021_par_commune.csv", sep = ",", header = TRUE,
                  stringsAsFactors = TRUE, fill = TRUE, strip.white = TRUE, quote = "")

apl_2023 <- read.table("data/Accessibilite_potentielle_localisee_mg_2023.txt",
                    sep = "\t", dec = ",", header = TRUE, stringsAsFactors = TRUE, quote = "")

PAPH <- read.table("data/PAPH.csv", sep = ";", dec = ",", header = TRUE, stringsAsFactors = TRUE,
                      fileEncoding = "Latin1", fill = TRUE, strip.white = TRUE, quote = "")

simplified_frailty_prevalence <- frailty_prevalence |> 
  group_by(Année,Sexe,Âge) |> 
  filter(Âge!="55 ans et plus") |> 
  filter(Sexe!="Hommes et Femmes") |> 
  droplevels()

EDI_data <- edi_2021 |> 
  mutate(
    Commune.Code = case_when(
      Commune %like% "Paris.*Arrondissement" ~ "75056",
      TRUE ~ Commune.Code
    )
  )

EDI_data <- city_api_data |> 
  inner_join(EDI_data, join_by(codeDepartement == departement_code, code == Commune.Code))

EDI_range <- range(EDI_data$EDI, na.rm = TRUE)

APL_data <- apl_2023 |> 
  select(-an)

APL_data <- city_api_data |> 
  inner_join(APL_data, join_by(code == codgeo))

DIP_data <- death_rate_per_diploma |> 
  filter(Diplôme != "Ensemble")

PAPH_data <- PAPH |> 
  mutate(
    codeRegion = Code.région |> 
      as.character() |> 
      as.factor(),
    codeDepartement = Code.département |> 
      as.character() |> 
      as.factor()
  ) |> 
  select(-Code.région, -Code.département)

APL_range <- range(APL_data$apl_mg_hmep, na.rm = TRUE)

DIP_age_range <- range(DIP_data$Âge, na.rm = TRUE)

PAPH_years_range <- range(PAPH$Année)
