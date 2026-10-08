##### Odisse Dataviz Challenge
# Analyse de donnees 
# Auteur : Aurelien R
#####

# Chargement des packages
library(dplyr)
library(ggplot2)
library(rstatix)


# Chargement des jeux de donnees
mortalite_catsociopro = read.table("CS_detaillee.csv",sep=";",dec=",",
                                    header=TRUE,stringsAsFactors = TRUE,
                                    fileEncoding = "Latin1")
# Source : https://www.insee.fr/fr/statistiques/8220688?sommaire=8208818

mortalite_diplome = read.table("DIP.csv",sep=";",dec=",",header=TRUE,
                              stringsAsFactors = TRUE,fileEncoding = "UTF-8")
# Source : https://www.insee.fr/fr/statistiques/8220688?sommaire=8208818

f_edi = read.table("f_edi_2021_par_commune.csv",sep=",",header=TRUE,
                  stringsAsFactors = TRUE,fill=TRUE)
# https://www.data.gouv.fr/datasets/indice-de-defavorisation-sociale-edi-european-deprivation-index-pour-la-france-metropolitaine-version-2021

apl_mg = read.table("Accessibilite_potentielle_localisee_mg_2023.txt",
                    sep="\t",dec=",",header=TRUE,stringsAsFactors = TRUE)
# https://www.observatoire-des-territoires.gouv.fr/accessibilite-potentielle-localisee-apl-aux-medecins-generalistes

fragilite_prevalence = read.table("fragilite_prevalence_france.csv", sep=",",
                                  header=TRUE,stringsAsFactors = TRUE)
# https://odisse.santepubliquefrance.fr/explore/assets/fragilite-prevalence-france/export/



# Fusion de jeux de donnees

f_edi = f_edi |> 
  rename_at("Commune.Code",~"code_commune")

apl_mg = apl_mg |> 
  rename_at("codgeo",~"code_commune")

masterdata_communes = inner_join(f_edi,apl_mg,by="code_commune")


# Cartes

communes = read_sf("Geo_Contours_Communes_2026.geojson")
# https://data-interne.ademe.fr/datasets/geo-contours-communes

  
# Interpretation des donnees

str(masterdata_communes)

masterdata_communes$EDI = as.numeric(masterdata_communes$EDI)
masterdata_communes$Quintile.natonal = as.numeric(masterdata_communes$Quintile.natonal)

masterdata_communes |> 
  ggplot(aes(x=EDI))+
  geom_histogram()+
  labs(title="Répartition de l'Indice de Défavorisation Européen",
      subtitle="f-edi",
      caption="data-gouv.fr",
      x="Indice de Défavorisation Européen",
      y="Effectifs")

masterdata_communes |> 
  ggplot(aes(x=Quintile.natonal))+
  geom_boxplot()+
  coord_flip()+
  labs(title="Distribution des quintiles de \n l'Indice de Défavorisation Européen",
      subtitle="f-edi, quintiles",
      caption="data-gouv.fr",
      y="Quintiles",
      x="Effectifs")

masterdata_communes$Commune[which(masterdata_communes$Quintile.natonal<10)]
# [1] LÉtang-Vergy,-1.832396371,entre 21 et 40%,2021,Côte-dOr            
# [2] Kermoroch,0.326964451,entre 41 et 60%,2021,Côtes-dArmor            
# [3] Saint-Jouan-de-lIsle,-0.105239418,entre 41 et 60%,2021,Côtes-dArmor
# [4] Les Hauts-Talican                                                  
# [5] Sainte-Florence  

masterdata_communes |> 
  ggplot(aes(x=apl_mg_hmep))+
  geom_histogram()

masterdata_communes |> 
  group_by(Région) |> 
  ggplot(aes(x=apl_mg_hmep,na.rm=TRUE))+
  geom_boxplot()+
  coord_flip()

masterdata_communes$Commune[which(masterdata_communes$apl_mg_hmep>10)]
# [1] Cargèse         Ersa            Abriès-Ristolas Vars            Île-de-Sein    
# [6] Englos          Vendeville 

vars_num = c("Quintile.natonal","EDI","apl_mg_hmep")


cor_multpl = cor(masterdata_communes[,num_vars],use="complete.obs")

cor_test(Quintile.natonal,apl_mg_hmep,data=masterdata_communes)
# Corrélation négative assez faible mais significative entre 
# l'indice de défavorisation et l'accès aux médecins généralistes.

cor_entiere = as.data.frame(cor_multpl)
names(cor_entiere) = c("Var1","Var2","Correlation")

cor_plot = ggplot(cor_entiere,aes(x=Var1,y=Var2,fill=Correlation))+
  geom_tile(color="white",linewidth=0.8)+
  scale_fill_viridis_b()+
  labs(title="Matrice de corrélation",
      subtitle = "f-EDI,quintiles f-EDI,apl mg",
      x=NULL,
      y=NULL)+
  theme_bw()

cor_plot

