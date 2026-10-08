library(shiny)
source("minor_scripts/data_getter.R")
source("minor_scripts/map_creator.R")

regs <- load_map_sections("regions")
deps <- load_map_sections("departements")

data_temporary <- edi_2021 |> 
  mutate(EDI = as.numeric(EDI) / 1000)

data_temporary_full <- city_api_data |> 
  inner_join(data_temporary, join_by(codeDepartement == departement_code, code == Commune.Code))

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
  titlePanel("Titre principal"),

  tabsetPanel(
    tabPanel(
      "1ère carte",
      sidebarLayout(
        sidebarPanel(
          radioButtons("first_sections_type", "Découper la carte selon les :",
            choices = c("Régions" = "regs", "Départements" = "deps"),
            selected = "deps"),
          sliderInput("first_slider", "Variable carte 1", min = -100, max = 100, value = c(-100,100))
        ),
        mainPanel(
          textOutput("first_text"),
          leafletOutput("first_map")
        )
      )
    ),
    tabPanel(
      "2ème carte",
      sidebarLayout(
        sidebarPanel(
          radioButtons("second_sections_type", "Découper la carte selon les :",
            choices = c("Régions" = "regs", "Départements" = "deps"),
            selected = "deps"),
          sliderInput("second_slider", "Variable carte 2", min = -100, max = 100, value = c(-50,50))
        ),
        mainPanel(
          textOutput("second_text"),
          leafletOutput("second_map")
        )
      )
    ),
    tabPanel(
      "1er graphique",
      sidebarLayout(
        sidebarPanel(
          sliderInput("third_slider", "Variable graphique 1", min = 1, max = 100, value = 75)
        ),
        mainPanel(
          textOutput("third_text"),
          plotOutput("first_graph")
        )
      )
    ),
    tabPanel(
      "2eme graphique",
      sidebarLayout(
        sidebarPanel(
          sliderInput("fourth_slider", "Variable graphique 2", min = 1, max = 100, value = 50)
        ),
        mainPanel(
          textOutput("fourth_text"),
          plotOutput("second_graph")
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
    data_temporary_full |> 
      mutate(
        code = .data[[get_code_col(input$first_sections_type)]]
      ) |> 
      group_by(code) |> 
      summarise(indicateur = median(EDI, na.rm = TRUE)) |>
      filter(indicateur >= input$first_slider[1] & indicateur <= input$first_slider[2])
  })
  data_second_map <- reactive({
    data_temporary_full |> 
      mutate(
        code = .data[[get_code_col(input$second_sections_type)]]
      ) |> 
      group_by(code) |> 
      summarise(indicateur = median(EDI, na.rm = TRUE)) |>
      filter(indicateur >= input$second_slider[1] & indicateur <= input$second_slider[2])
  })

  output$first_map  <- renderLeaflet(base_map(first_sections()))
  output$second_map <- renderLeaflet(base_map(second_sections()))

  observe({
    sectionned_map(
      data = data_first_map(), var = "indicateur", col_code = "code",
      sections = first_sections(),
      map = leafletProxy("first_map"),
      domain = c(-100, 100),
      title = "EDI"
    )
  })

  observe({
    sectionned_map(
      data = data_second_map(), var = "indicateur", col_code = "code",
      sections = second_sections(),
      map = leafletProxy("second_map"),
      domain = c(-100, 100),
      title = "EDI"
    )
  })

  output$first_graph <- renderPlot({})
  
  output$second_graph <- renderPlot({})
}

shinyApp(ui = ui, server = server)
