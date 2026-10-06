library(shiny)

ui <- fluidPage(
  titlePanel("Titre principal"),

  tabsetPanel(
    tabPanel(
      "1ère carte",
      sidebarLayout(
        sidebarPanel(
          sliderInput("first_slider", "Variable carte 1", min = 1, max = 100, value = 75)
        ),
        mainPanel(
          textOutput("first_text"),
          plotOutput("first_map")
        )
      )
    ),
    tabPanel(
      "2ème carte",
      sidebarLayout(
        sidebarPanel(
          sliderInput("second_slider", "Variable carte 2", min = 1, max = 100, value = 75)
        ),
        mainPanel(
          textOutput("second_text"),
          plotOutput("second_map")
        )
      )
    ),
    tabPanel(
      "3ème carte",
      sidebarLayout(
        sidebarPanel(
          sliderInput("third_slider", "Variable carte 3", min = 1, max = 100, value = 75)
        ),
        mainPanel(
          textOutput("third_text"),
          plotOutput("third_map")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  output$first_text <- renderText({
    paste("Carte 1 : ", input$first_slider)
  })

  output$second_text <- renderText({
    paste("Carte 2 : ", input$second_slider)
  })

  output$third_text <- renderText({
    paste("Carte 3 : ", input$third_slider)
  })
  
  output$first_map <- renderPlot({

  })
  
  output$second_map <- renderPlot({

  })
  
  output$third_map <- renderPlot({

  })
}

shinyApp(ui = ui, server = server)
