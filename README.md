# OdisseDatavizChallenge2026
## The project
This project was made by bio-informatics students in the context of the OdisseDataviz Challenge made by Santé Publique France. The subject is inequalities in access to healthcare in France. This project is aimed to be reviewed by our professor.
### Data source
#### Raw files
[Cause de décès selon le sexe (cause_deces.csv)](https://www.insee.fr/fr/statistiques/2385258)\
[Tables de mortalité par catégorie sociale et par diplôme jusqu’en 2020-2022 (CS.csv, CS_detaillee.csv & DIP.csv)](https://www.insee.fr/fr/statistiques/8208816?sommaire=8208818)\
[Indice de défavorisation européen adapté à la France (f_edi_par_commune.csv)](https://odisse.santepubliquefrance.fr/explore/assets/french-european-deprivation-index-f-edi-2021-par-commune/)\
[Prévalence de l'état de fragilité chez les personnes âgées (fragilite_prevalence_france.csv)](https://odisse.santepubliquefrance.fr/explore/assets/fragilite-prevalence-france/export/)\
[Accessibilité potentielle localisée aux médecins généralistes (Accessibilite_potentielle_localisee_mg_2023.txt)](https://www.observatoire-des-territoires.gouv.fr/accessibilite-potentielle-localisee-apl-aux-medecins-generalistes)\
[Indicateurs de contexte sociaux (indicateurs_de_contexte.csv)](https://drees2-sgsocialgouv.opendatasoft.com/explore/dataset/601_indicateurs-de-contexte/)\
[Les bénéficiaires de l'aide sociale départementale aux personnes âgées ou handicapées (PAPH.csv)](https://drees2-sgsocialgouv.opendatasoft.com/explore/dataset/les-beneficiaires-de-l-aide-sociale-departementale-aux-personnes-agees-ou-handic/information/)

### API
[Découpage administratif des communes françaises (Etalab)](https://geo.api.gouv.fr/communes)\
[France Geojson](https://github.com/gregoiredavid/france-geojson)

### Statistical tests and analysis
f-EDI and APL-mg : 

Acronyms definitions : f-EDI for french-European Defavorisation Index
and Accessibilité Potentielle Localisée aux Médecins Généralistes, or Localized potential accessibility to general practitioners.

Tests : 
Shapiro-Wilk's test could not be done on R due to the size of the dataset (>5000), a visual examination of normality has thus been done instead.
f-EDI's data seem to have a normal distribution.
APL-mg's data also seem to have a normal distribution to the exception of extreme values.
To be safe, we did a non-parametric correlation test of Spearman.
HO : f-EDI and APL-mg are not correlated.
H1 : f-EDI et APL-mg are correlated.

Correlation test result :
var1  var2         cor	 statistic      p 	method  
   
EDI   apl_mg_hmep -0.023   7.14e12 0.0000257 Spearman

The p-value (p-value=0.0000257) is inferior to the risk alpha of 5%, we can thus reject H0 and admit that f-EDI and APL-mg are correlated.
Even if the p-value is significative, the correlation is very weak (-0.023).

Frailty prevalence in the senior population :

A Shapiro-Wilk's test has been done on the prevalence data :

H0 : the data follow a normal distribution.
H1 : the data do not follow a normal distribution.

Shapiro-Wilk normality test

data:  fragilite_prevalence$Prévalence
W = 0.82001, p-value = 2.676e-12
The p-value being inferior to the risk alpha of 5% (p-value = 2.67e-12), we can reject H0 and admit that the data do ont follow a normal distribution.
We will do Kruskal-Wallis tests.

In terms of age levels : 

H0 : frailty prevalence does not differ according to age levels.
H1 : there is a significative difference in frailty prevalence according to age levels.
Kruskal-Wallis rank sum test

data:  fragilite_prevalence$Prévalence by fragilite_prevalence$Âge
Kruskal-Wallis chi-squared = 139.45, df = 6, p-value < 2.2e-16

The p-value (p-value = 2.2e-16) is inferior to alpha at the risk alpha of 5%. We can hence reject H0 and admit that frailty prevalence differs depending on age levels.

In terms of gender :

H0 : frailty prevalence does not differ according to gender.
H1 : there is a significative difference in frailty prevalence according to gender.
Kruskal-Wallis rank sum test

data:  fragilite_prevalence$Prévalence by fragilite_prevalence$Sexe
Kruskal-Wallis chi-squared = 7.2068, df = 2, p-value = 0.02723

The p-value is inferior to alpha at the risk alpha of 5% (p-value = 0.02723), we can hence reject H0 and admit that frailty prevalence differs depending on gender. 

Life expetancy according to study levels : 

A Kruskal-Wallis test for life expetancy at age x according to study level has been done.

H0 : life expectancy does not differ according to study level.
H1 : there is a significative difference in life expectancy according to study level.

Kruskal-Wallis rank sum test

data:  mortalite_diplome$Espérance.de.vie.à.l.âge.x by mortalite_diplome$Diplôme
Kruskal-Wallis chi-squared = 26.233, df = 5, p-value = 8.042e-05

The p-value (8.042e-05) is inferior to alpha at risk alpha of 5%. The life expectancy depends on study level.


### Difficulties we encountered

The datasets provided by Santé Publique France as well as the datasets provided by different official sources were not made to be loaded and read in R. Due to that, we previously had a certain number of errors in data analysis. We had to make a certain number of data transformations, which took a substantiate amount of time. 
Understanding how to do interactive map graphs also took us time.
