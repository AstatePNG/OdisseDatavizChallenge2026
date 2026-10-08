mortalite_catsociopro = read.table("data/CS_detaillee.csv",sep=";",dec=",",
                                    header=TRUE,stringsAsFactors = TRUE,
                                    fileEncoding = "Latin1")


mortalite_diplome = read.table("data/DIP.csv",sep=";",dec=",",header=TRUE,
                              stringsAsFactors = TRUE,fileEncoding = "UTF-8")


f_edi = read.table("data/f_edi_2021_par_commune.csv",sep=",",header=TRUE,
                  stringsAsFactors = TRUE,fill=TRUE)

apl_mg = read.table("data/Accessibilite_potentielle_localisee_mg_2023.txt",
                    sep="\t",dec=",",header=TRUE,stringsAsFactors = TRUE)

fragilite_prevalence = read.table("data/fragilite_prevalence_france.csv", sep=",",
                                  header=TRUE,stringsAsFactors = TRUE)

cause_deces = read.table("data/cause_deces.csv",sep=";",dec=",",header=TRUE,
                        stringsAsFactors = TRUE,fileEncoding = "Latin1")
