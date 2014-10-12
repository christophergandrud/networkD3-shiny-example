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

  output$sankey <- renderSankeyNetwork({
    library(RCurl)
    URL <- "https://raw.githubusercontent.com/christophergandrud/d3Network/sankey/JSONdata/energy.json"
    Energy <- getURL(URL, ssl.verifypeer = FALSE)
    EngLinks <- JSONtoDF(jsonStr = Energy, array = "links")
    EngNodes <- JSONtoDF(jsonStr = Energy, array = "nodes")
    sankeyNetwork(Links = EngLinks, Nodes = EngNodes, Source = "source",
                  Target = "target", Value = "value", NodeID = "name",
                  fontsize = 12, nodeWidth = 30)
  })

}

#### UI ####

ui <- shinyUI(fluidPage(

  titlePanel("Shiny networkD3 "),

  sidebarLayout(
    sidebarPanel(
      numericInput("opacity", "Opacity (not for Sankey)", 0.6, min = 0.1,
      max = 1, step = .1)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Simple Network", simpleNetworkOutput("simple")),
        tabPanel("Force Network", forceNetworkOutput("force")),
        tabPanel("Sankey Network", sankeyNetworkOutput("sankey"))
      )
    )
  )
))

#### Run ####
shinyApp(ui = ui, server = server)
