# OdisseDatavizChallenge2026
## The project
This project was made by bio-informatics students in the context of the OdisseDataviz Challenge made by Santé Publique France and as part of the Dataviz course.
The subject is inequalities in access to healthcare in France.

## Access the Dataviz
### Website deployment
Go to the [dataviz website](https://xkyfmp-astate0png.shinyapps.io/odissedatavizchallenge2026/)

### Run Locally
Download the [latest release](https://github.com/AstatePNG/OdisseDatavizChallenge2026/releases/tag/1.3)

Unzip the folder

Run the shiny app (app.R)

## Difficulties we encountered

Our raw dataset were made to be easily readable for non informaticians, making them unreadable with R.
Due to that, we had to cleanse our data through Excel Power Query, which took a substantiate amount of time.
Understanding how to do interactive map graphs also took us time.

## Known issue

The first time a map graph is displayed, the sections aren't loaded. Changing the filters or switching tab resolve the issue. 

## Authors
- @[AstatePNG](https://github.com/AstatePNG)
- @[aurumALR](https://github.com/aurumALR)

## Data source
### Raw files
[Tables de mortalité par diplôme jusqu’en 2020-2022 (DIP.csv)](https://www.insee.fr/fr/statistiques/8208816?sommaire=8208818)\
[Indice de défavorisation européen adapté à la France (f_edi_par_commune.csv)](https://odisse.santepubliquefrance.fr/explore/assets/french-european-deprivation-index-f-edi-2021-par-commune/)\
[Prévalence de l'état de fragilité chez les personnes âgées (fragilite_prevalence_france.csv)](https://odisse.santepubliquefrance.fr/explore/assets/fragilite-prevalence-france/export/)\
[Accessibilité potentielle localisée aux médecins généralistes (Accessibilite_potentielle_localisee_mg_2023.txt)](https://www.observatoire-des-territoires.gouv.fr/accessibilite-potentielle-localisee-apl-aux-medecins-generalistes)\
[Les bénéficiaires de l'aide sociale départementale aux personnes âgées ou handicapées (PAPH.csv)](https://drees2-sgsocialgouv.opendatasoft.com/explore/dataset/les-beneficiaires-de-l-aide-sociale-departementale-aux-personnes-agees-ou-handic/information/)

### API
[Découpage administratif des communes françaises (Etalab)](https://geo.api.gouv.fr/communes)\
[France Geojson](https://github.com/gregoiredavid/france-geojson)

