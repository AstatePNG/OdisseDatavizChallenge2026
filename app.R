library(shiny)
source("minor_scripts/data_getter.R")
source("minor_scripts/map_creator.R")

regs <- load_map_sections("regions")
deps <- load_map_sections("departements")

get_sections <- function(type) {
  switch(type,
    regs = regs,
    deps
  )
}

get_code_col <- function(type) {
  switch(type,
    regs = "codeRegion",
    deps = "codeDepartement"
  )
}

ui <- fluidPage(
  titlePanel("Quels sont les principaux critères sociaux et géographiques influançant l'accès à la santé ?"),

  p("Explorer les données."),

  tabsetPanel(
    tabPanel(
      "Carte de l'indice de défavorisation sociale médian en 2021",
      sidebarLayout(
        sidebarPanel(
          radioButtons("first_sections_type", "Découper la carte selon les :",
            choices = c("Régions" = "regs", "Départements" = "deps"),
            selected = "deps"),
          sliderInput("first_slider", "Valeurs d'EDI acceptée :", min = EDI_range[1], max = EDI_range[2], value = EDI_range)
        ),
        mainPanel(
          p("Carte de l'indice de défavorisation sociale (EDI) en 2021"),
          leafletOutput("first_map")
        )
      )
    ),
    tabPanel(
      "Carte de l'accessibilité potentielle aux médecins généralistes médianne en 2023",
      sidebarLayout(
        sidebarPanel(
          radioButtons("second_sections_type", "Découper la carte selon les :",
            choices = c("Régions" = "regs", "Départements" = "deps"),
            selected = "deps"),
          sliderInput("second_slider", "Valeurs d'accessibilité potentielle aux médecins généralistes acceptée :", min = APL_range[1], max = APL_range[2], value = c(0,4))
        ),
        mainPanel(
          p("Carte de l'accessibilité potentielle localisée aux médecins généraliste (APL MG) en 2023"),
          leafletOutput("second_map")
        )
      )
    ),
    tabPanel(
      "Fragilité en fonction de l'âge et du sexe",
      sidebarLayout(
        sidebarPanel(
          radioButtons("gender_filter", "Sexe :", choices = c("Tout" = "all", unique(as.character(simplified_frailty_prevalence$Sexe)))),
          checkboxGroupInput("age_filter", "Catégorie d'âge :", choices = unique(as.character(simplified_frailty_prevalence$Âge)), selected = unique(as.character(simplified_frailty_prevalence$Âge)))
        ),
        mainPanel(
          p("Distribution de la prévalence de la fragilité en fonction de l'âge et du sexe"),
          plotOutput("first_graph")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  output$first_text <- renderText({paste("Carte 1 : ", input$first_sections_type)})
  output$second_text <- renderText({paste("Carte 2 : ", input$second_slider)})
  output$third_text <- renderText({paste("Graphique 1 : ", input$third_slider)})
  output$fourth_text <- renderText({paste("Graphique 2 : ", input$fourth_slider)})

  first_sections <- reactive(get_sections(input$first_sections_type))
  second_sections <- reactive(get_sections(input$second_sections_type))

  first_type <- reactive({input$first_sections_type})
  second_type <- reactive({input$second_sections_type})

  data_first_map <- reactive({
    EDI_data |> 
      mutate(
        code = .data[[get_code_col(input$first_sections_type)]]
      ) |> 
      group_by(code) |> 
      summarise(indicateur = median(EDI, na.rm = TRUE)) |>
      filter(indicateur >= input$first_slider[1] & indicateur <= input$first_slider[2])
  })
  data_second_map <- reactive({
    APL_data |> 
      mutate(
        code = .data[[get_code_col(input$second_sections_type)]]
      ) |> 
      group_by(code) |> 
      summarise(indicateur = median(apl_mg_hmep, na.rm = TRUE)) |>
      filter(indicateur >= input$second_slider[1] & indicateur <= input$second_slider[2])
  })

  output$first_map  <- renderLeaflet(base_map(first_sections()))
  output$second_map <- renderLeaflet(base_map(second_sections()))

  observe({
    sectionned_map(
      data = data_first_map(), var = "indicateur", col_code = "code",
      sections = first_sections(),
      map = leafletProxy("first_map"),
      domain = input$first_slider,
      title = "EDI"
    )
  })

  observe({
    sectionned_map(
      data = data_second_map(), var = "indicateur", col_code = "code",
      sections = second_sections(),
      map = leafletProxy("second_map"),
      domain = input$second_slider,
      title = "APL MG"
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

  output$first_graph <- renderPlot({
    data_first_graph() |> 
      ggplot(aes(x=Prévalence,y=Sexe))+
      geom_boxplot(aes(fill=Sexe),alpha = 0.5)+
      geom_jitter(aes(col=Âge))+
      labs(
        caption="Santé Publique France",
        x = "Prévalence de la fagilité"
      )+
      theme_bw() +
      coord_flip()
  })
}

shinyApp(ui = ui, server = server)
