source("minor_scripts/packages_installer.R")
library(shiny)
source("minor_scripts/data_getter.R")
source("minor_scripts/map_creator.R")

regs <- load_map_sections("regions")
deps <- load_map_sections("departements")
coms <- load_map_sections("communes")

get_sections <- function(type) {
  switch(type,
    regs = regs,
    deps = deps,
    coms
  )
}

get_code_col <- function(type) {
  switch(type,
    regs = "codeRegion",
    deps = "codeDepartement",
    coms = "code"
  )
}

ui <- fluidPage(
  h1("Les inégalités sociales dans l'accès à la santé en France"),

  h2("Observation de différents indices à travers les graphiques."),

  tabsetPanel(id = "tabs",
    tabPanel(
      "Carte de l'indice de défavorisation sociale en 2021",
      value = "tab1",
      sidebarLayout(
        sidebarPanel(
          h3("Filtres :"),

          radioButtons("first_sections_type", "Découper la carte selon les :",
            choices = c("Régions" = "regs", "Départements" = "deps", "Communes" = "coms"),
            selected = "deps"),
          sliderInput("first_slider", "Valeurs d'EDI acceptée :", min = floor(EDI_range[1]), 
            max = ceiling(EDI_range[2]), value = EDI_range, step = 1),
          
          radioButtons("first_display_type", "Observer :", choices = c("La valeur médiane" = "median", "L'écart-type" = "sd")),
          
          h3("Analyses :"),

          p(
            "Le",
            strong("f-EDI"),
            "(raccourci en", 
            strong("EDI"), 
            "ici), pour", 
            strong("french-European Deprivation Index"), 
            "— ou Facteur de Défavorisation sociale Européen adapté à la France — est",
            "un indicateur permettant d'évaluer le niveau de défavorisation d'une commune.",
            "Un EDI plus élevé indique une commune plus défavorisée."
          ),
          
          br(),

          p(
            "En observant les", 
            strong(tags$i("valeurs médianes les plus importantes par départements,")), 
            "on peut voir que les départements les plus défavorisés sont la", 
            strong("Seine Saint Denis"), 
            "— dont la valeur médiane est largement supérieure aux autres départements —, le",
            strong("Val de Marne"),
            "et", 
            strong("Paris.")
          ),
          p(
            "En dehors de l'ïle-de-France, on voit que l'", 
            strong(tags$i("écart-type")),
            "est particulièrement importants dans le",
            strong("Nord,"),
            "ce qui révèle une grande disparité sur le niveau de défavorisation entre les différentes communes de ce département."
          ),
          p(
            "Plus généralement, en jouant sur les différents facteurs d'observation",
            "on constate qu'en dehors des régions du Nord Ouest du Pays (Bretagne, Normandie & Pays de la Loire),",
            "l'EDI est particulièrement variable et/ou élevé en France."
          )
        ),
        mainPanel(
          leafletOutput("first_map", height = "80vh"),
          a(
            "Odissé (Santé Publique France) - F-EDI",
            target = "_blank",
            href = "https://odisse.santepubliquefrance.fr/explore/assets/french-european-deprivation-index-f-edi-2021-par-commune/"
          )
        )
      )
    ),
    tabPanel(
      "Carte de l'accessibilité potentielle aux médecins généralistes en 2023",
      value = "tab2",
      sidebarLayout(
        sidebarPanel(
          h3("Filtres :"),
          
          radioButtons("second_sections_type", "Découper la carte selon les :",
            choices = c("Régions" = "regs", "Départements" = "deps", "Communes" = "coms"),
            selected = "deps"),
          sliderInput("second_slider", "Valeurs d'accessibilité potentielle aux médecins généralistes acceptée :", 
            min = APL_range[1], max = APL_range[2], value = APL_range, step = 1),
          
          radioButtons("second_display_type", "Observer :", choices = c("La valeur médiane" = "median", "L'écart-type" = "sd")),
          
          h3("Analyses :"),

          p(
            "L'",
            strong("accessibilité potentielle localisée aux médecins généralistes"),
            "(raccourcie en", 
            strong("accessibilité potentielle aux médecins généralistes"), 
            "ici), abbregée en", 
            strong("APL MG"), 
            "est un indicateur permettant d'évaluer le niveau d'adéquation entre",
            "l'offre de médecins généraliste et la demande de patients.",
            "Une valeur d'APL MG plus élevée indique une meilleure offre en médecins généralistes."
          ),
          
          br(),

          p(
            "En observant les", 
            strong(tags$i("valeurs médianes les plus faibles")),
            "par départements, on peut voir que les départements",
            "ayant le plus de difficultés a accédé à des médecins généralistes sont la Haute Corse — dont la valeur médiane est",
            "largement inférieure aux autres départements —, et la Corse du Sud."
          ),
          p(
            "On voit que l'",
            strong(tags$i("écart-type")),
            "est particulièrement important dans les",
            strong("Hautes Alpes.")
          )
        ),
        mainPanel(
          leafletOutput("second_map", height = "80vh"),
          a(
            "Observatoire des territoires - Accessibilité potentielle localisée aux médecins généralistes",
            target = "_blank",
            href = "https://www.observatoire-des-territoires.gouv.fr/accessibilite-potentielle-localisee-apl-aux-medecins-generalistes"
          )
        )
      )
    ),
    tabPanel(
      "Carte de l'aide sociale aux personnes en situation de handicap en fonction de la période",
      value = "tab3",
      sidebarLayout(
        sidebarPanel(
          h3("Filtres :"),
          radioButtons("third_sections_type", "Découper la carte selon les :",
            choices = c("Régions" = "regs", "Départements" = "deps"),
            selected = "regs"),
          sliderInput("third_slider", "Période de temps observée :", min = PAPH_years_range[1], 
            max = PAPH_years_range[2], value = PAPH_years_range, step = 1),
          
          radioButtons("third_display_type", "Observer :", choices = c("La valeur médiane" = "median", "L'écart-type" = "sd")),
          
          h3("Analyses :"),

          p(
            "L'",
            strong("aide sociale aux personnes en situation de handicap"), 
            "abbregée en", 
            strong("ASPH"), 
            "comptabilise le nombre d'individus ayant demandé l'aide départementale."
          ),
          
          br(),

          p(
            "La région Île-de-France a la plus haute valeur médiane de personnes en",
            "situation de handicap touchant des aides sociales entre 2000 et 2024.",
            "L'Occitanie et la Bourgogne-Franche-Comté ont la médiane la plus faible."
          ),
          p(
            "Les Hauts-de-France ont l'écart-type le plus élevé entre 2000 et 2024.",
            "La Corse a l'écart-type le plus faible."
          )
        ),
        mainPanel(
          leafletOutput("third_map", height = "80vh"),
          a(
            "DREES - Les bénéficiaires de l'aide sociale départementale",
            target = "_blank",
            href = "https://drees2-sgsocialgouv.opendatasoft.com/explore/dataset/les-beneficiaires-de-l-aide-sociale-departementale-aux-personnes-agees-ou-handic/information/"
          )
        )
      )
    ),
    tabPanel(
      "Carte de l'aide sociale aux personnes âgées en fonction de la période",
      value = "tab4",
      sidebarLayout(
        sidebarPanel(
          h3("Filtres :"),
          radioButtons("fourth_sections_type", "Découper la carte selon les :",
            choices = c("Régions" = "regs", "Départements" = "deps"),
            selected = "regs"),
          sliderInput("fourth_slider", "Période de temps observée :", min = PAPH_years_range[1], 
            max = PAPH_years_range[2], value = PAPH_years_range, step = 1),
          
          radioButtons("fourth_display_type", "Observer :", choices = c("La valeur médiane" = "median", "L'écart-type" = "sd")),
          
          h3("Analyses :"),

          p(
            "L'",
            strong("aide sociale aux personnes âgées"), 
            "abbregée en", 
            strong("ASPA"), 
            "comptabilise le nombre d'individus ayant demandé l'aide départementale."
          ),
          
          br(),

          p(
            "On peut observer que de 2000 à 2024, la Bretagne a la plus haute valeur",
            "médiane de personnes âgées touchant des aides sociales, suivie par", 
            "l'Île-de-France.",
            "La Bourgogne-Franche-Comté et le Centre-Val de Loire ont la valeur médiane la plus faible."
          ),
          p(
            "Les Hauts-de-France ont l'écart-type le plus élevé entre 2000 et 2024.",
            "La Corse a l'écart-type le plus faible."
          )
        ),
        mainPanel(
          leafletOutput("fourth_map", height = "80vh"),
          a(
            "DREES - Les bénéficiaires de l'aide sociale départementale",
            target = "_blank",
            href = "https://drees2-sgsocialgouv.opendatasoft.com/explore/dataset/les-beneficiaires-de-l-aide-sociale-departementale-aux-personnes-agees-ou-handic/information/"
          )
        )
      )
    ),
    tabPanel(
      "Fragilité en fonction de l'âge et du sexe",
      value = "tab5",
      sidebarLayout(
        sidebarPanel(
          h3("Filtres :"),
          
          radioButtons("gender_filter", "Sexe :", choices = c("Tout" = "all", unique(as.character(simplified_frailty_prevalence$Sexe)))),
          checkboxGroupInput("age_filter", "Catégorie d'âge :", choices = unique(as.character(simplified_frailty_prevalence$Âge)), 
            selected = unique(as.character(simplified_frailty_prevalence$Âge))),
          
          h3("Analyses :"),

          p(
            "La prévalence du syndrome de fragilité augmente avec l'âge.",
            "On peut aussi voir que les femmes, à tous âges, ont plus de prévalence",
            "du syndrome de fragilité que les hommes."
          ),
          p(
            "Pour une même catégorie d'âge, plus l'âge est important,",
            "plus l'écart entre les hommes et les femmes se creuse."
          )
        ),
        mainPanel(
          plotOutput("first_graph", height = "80vh"),
          a(
            "Odissée (Santé Publique France) - Fragilité : Prévalence",
            target = "_blank",
            href = "https://odisse.santepubliquefrance.fr/explore/assets/fragilite-prevalence-france/export/"
          )
        )
      )
    ),
    tabPanel(
      "Espérance de vie en fonction du diplôme",
      value = "tab6",
      sidebarLayout(
        sidebarPanel(
          h3("Filtres :"),
          
          checkboxGroupInput("diploma_filter", "Diplôme :", choices = unique(as.character(DIP_data$Diplôme)), selected = unique(as.character(DIP_data$Diplôme))),
          sliderInput("age_slider", "Âge :", min = DIP_age_range[1], max = DIP_age_range[2], value = DIP_age_range, step = 1),
          
          h3("Analyses :"),

          p(
            "On peut voir que, peu importe l'âge choisi, les diplômés supérieur au",
            "baccalauréat ont la plus longue espérance de vie, tandis que les sans diplôme ont",
            "la plus faible."
          ),

          p(
            "De plus, on observe que pour les sans diplôme, il y a une plus",
            "forte concentration des effectifs vers une faible espérance de vie",
            "que pour les diplômés."
          ),

          p(
            "De manière générale, l'espérance de vie semble positivement liée aux",
            "niveaux des diplômes."
          )
        ),
        mainPanel(
          plotOutput("second_graph", height = "80vh"),
          a(
            "INSEE - mortalité par catégorie sociale et par diplôme jusqu’en 2020-2022",
            target = "_blank",
            href = "https://www.insee.fr/fr/statistiques/8208816?sommaire=8208818"
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  first_sections <- reactive(get_sections(input$first_sections_type))
  second_sections <- reactive(get_sections(input$second_sections_type))
  third_sections <- reactive(get_sections(input$third_sections_type))
  fourth_sections <- reactive(get_sections(input$fourth_sections_type))

  first_type <- reactive({input$first_sections_type})
  second_type <- reactive({input$second_sections_type})
  third_type <- reactive({input$third_sections_type})
  fourth_type <- reactive({input$fourth_sections_type})

  data_first_map <- reactive({
    df <- EDI_data |> 
      mutate(
        code = .data[[get_code_col(input$first_sections_type)]]
      ) |>
      filter(EDI >= input$first_slider[1] & EDI <= input$first_slider[2]) |> 
      group_by(code)
    
    if(input$first_display_type == "median") {
      df <- df |> 
        summarise(EDI = median(EDI, na.rm = TRUE))
    } else {
      df <- df |> 
        summarise(EDI = sd(EDI, na.rm = TRUE))
    }
    df |> 
      filter(!is.na(EDI))
  })
  data_second_map <- reactive({
    df <- APL_data |> 
      mutate(
        code = .data[[get_code_col(input$second_sections_type)]]
      ) |>
      filter(apl_mg_hmep >= input$second_slider[1] & apl_mg_hmep <= input$second_slider[2]) |> 
      group_by(code)
    
    if(input$second_display_type == "median") {
      df <- df |> 
        summarise(APL_MG = median(apl_mg_hmep, na.rm = TRUE))
    } else {
      df <- df |> 
        summarise(APL_MG = sd(apl_mg_hmep, na.rm = TRUE))
    }
      df |> 
        filter(!is.na(APL_MG))
  })
  data_third_map <- reactive({
    df <- PAPH_data |> 
      mutate(
        code = .data[[get_code_col(input$third_sections_type)]]
      ) |> 
      filter(Année >= input$third_slider[1] & Année <= input$third_slider[2]) |> 
      group_by(code)
    
    if(input$third_display_type == "median") {
      df <- df |> 
        summarise(ASPH = median(Total.des.aides.sociales.aux.personnes.handicapées..depuis.2000, na.rm = TRUE))
    } else {
      df <- df |> 
        summarise(ASPH = sd(Total.des.aides.sociales.aux.personnes.handicapées..depuis.2000, na.rm = TRUE))
    }
      df |> 
        filter(!is.na(ASPH))
  })
  data_fourth_map <- reactive({
    df <- PAPH_data |> 
      mutate(
        code = .data[[get_code_col(input$fourth_sections_type)]]
      ) |> 
      filter(Année >= input$fourth_slider[1] & Année <= input$fourth_slider[2]) |> 
      group_by(code)
    
    if(input$fourth_display_type == "median") {
      df <- df |> 
        summarise(ASPA = median(Aides.sociales.aux.personnes.âgées.depuis.2000..en.décembre, na.rm = TRUE))
    } else {
      df <- df |> 
        summarise(ASPA = sd(Aides.sociales.aux.personnes.âgées.depuis.2000..en.décembre, na.rm = TRUE))
    }
      df |> 
        filter(!is.na(ASPA))
  })

  output$first_map  <- renderLeaflet(base_map(first_sections()))
  output$second_map <- renderLeaflet(base_map(second_sections()))
  output$third_map <- renderLeaflet(base_map(third_sections()))
  output$fourth_map <- renderLeaflet(base_map(fourth_sections()))

  observe({
    req(input$tabs == "tab1")
    df <- data_first_map()
    req(df, nrow(df) > 0)

    sectionned_map(
      data = df, var = "EDI", col_code = "code",
      sections = first_sections(),
      map = leafletProxy("first_map"),
      domain = range(df$EDI),
      title = "EDI",
      reverse = TRUE
    )
  })

  observe({
    req(input$tabs == "tab2")
    df <- data_second_map()
    req(df, nrow(df) > 0)

    sectionned_map(
      data = df, var = "APL_MG", col_code = "code",
      sections = second_sections(),
      map = leafletProxy("second_map"),
      domain = range(df$APL_MG),
      title = "APL MG",
      reverse = (input$second_display_type == "sd")
    )
  })

  observe({
    req(input$tabs == "tab3")
    df <- data_third_map()
    req(df, nrow(df) > 0)

    sectionned_map(
      data = df, var = "ASPH", col_code = "code",
      sections = third_sections(),
      map = leafletProxy("third_map"),
      domain = range(df$ASPH),
      title = "ASPH",
      reverse = (input$third_display_type == "sd")
    )
  })

  observe({
    req(input$tabs == "tab4")
    df <- data_fourth_map()
    req(df, nrow(df) > 0)

    sectionned_map(
      data = df, var = "ASPA", col_code = "code",
      sections = fourth_sections(),
      map = leafletProxy("fourth_map"),
      domain = range(df$ASPA),
      title = "ASPA",
      reverse = (input$fourth_display_type == "sd")
    )
  })

  data_first_graph <- reactive({
    df <- simplified_frailty_prevalence
    if(input$gender_filter != "all") {
      df <- df |> 
        filter(Sexe == input$gender_filter)
    }
    df |> 
      filter(Âge %in% input$age_filter)
  })
  data_second_graph <- reactive({
    DIP_data |> 
      filter(Diplôme %in% input$diploma_filter) |> 
      filter(Âge >= input$age_slider[1] & Âge <= input$age_slider[2]) |> 
      filter(!is.na(Espérance.de.vie.à.l.âge.x))
  })

  output$first_graph <- renderPlot({
    data_first_graph() |> 
      ggplot(aes(x=Prévalence,y=Sexe))+
      geom_boxplot(aes(fill=Sexe),alpha = 0.5)+
      geom_jitter(aes(col=Âge))+
      labs(
        x = "Prévalence de la fagilité"
      )+
      theme_bw() +
      coord_flip()
  })

  output$second_graph <- renderPlot({
    data_second_graph() |> 
      ggplot(aes(y=Espérance.de.vie.à.l.âge.x,x=Diplôme))+
      geom_violin(aes(fill=Diplôme), alpha = 0.3, col = "transparent")+
      geom_boxplot(aes(col=Diplôme), alpha = 0.5, fill = "white", width = 0.3)+
      labs(
        y = "Espérance de vie"
      )+
      scale_color_brewer(palette = "Set2") +
      scale_fill_brewer(palette = "Set2") +
      theme_bw() +
      coord_flip()
  })
}

shinyApp(ui = ui, server = server)
