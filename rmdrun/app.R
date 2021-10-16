#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

library(shiny)
library(knitr)

ui <- shinyUI(
    fluidPage(
        uiOutput('markdown')
    )
)
server <- function(input, output) {
    output$markdown <- renderUI({
        HTML(markdown::markdownToHTML(knit('run_shiny.Rmd', quiet = TRUE)))
    })
}

shinyApp(ui, server)


