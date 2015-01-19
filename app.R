#### Load necessary packages and data ####
library(shiny)
library(networkD3)

data(MisLinks)
data(MisNodes)

#### Server ####
server <- function(input, output) {

  output$simple <- renderSimpleNetwork({
    src <- c("A", "A", "A", "A", "B", "B", "C", "C", "D")
    target <- c("B", "C", "D", "J", "E", "F", "G", "H", "I")
    networkData <- data.frame(src, target)
    simpleNetwork(networkData, opacity = input$opacity)
  })

  output$force <- renderForceNetwork({
    forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source",
                 Target = "target", Value = "value", NodeID = "name",
                 Group = "group", opacity = input$opacity)
  })

}

#### UI ####

ui <- shinyUI(fluidPage(

  titlePanel("Shiny networkD3 "),

  sidebarLayout(
    sidebarPanel(
      sliderInput("opacity", "Opacity (not for Sankey)", 0.6, min = 0.1,
                    max = 1, step = .1)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Simple Network", simpleNetworkOutput("simple")),
        tabPanel("Force Network", forceNetworkOutput("force"))
      )
    )
  )
))

#### Run ####
shinyApp(ui = ui, server = server)
