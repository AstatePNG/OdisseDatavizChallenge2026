###### Odisse Dataviz Challenge #####
### Fichier d'integration des donnees ###
# Date : 08/10/26
# Auteur : Aurelien R
#####

# Chargement des jeux de donnees
mortalite_catsociopro = read.table("CS_detaillee.csv",sep=";",dec=",",
                                    header=TRUE,stringsAsFactors = TRUE,
                                    fileEncoding = "Latin1")


mortalite_diplome = read.table("DIP.csv",sep=";",dec=",",header=TRUE,
                              stringsAsFactors = TRUE,fileEncoding = "UTF-8")


f_edi = read.table("f_edi_2021_par_commune.csv",sep=",",header=TRUE,
                  stringsAsFactors = TRUE,fill=TRUE)

apl_mg = read.table("Accessibilite_potentielle_localisee_mg_2023.txt",
                    sep="\t",dec=",",header=TRUE,stringsAsFactors = TRUE)

fragilite_prevalence = read.table("fragilite_prevalence_france.csv", sep=",",
                                  header=TRUE,stringsAsFactors = TRUE)

cause_deces = read.table("cause_deces.csv",sep=";",dec=",",header=TRUE,
                        stringsAsFactors = TRUE,fileEncoding = "Latin1")