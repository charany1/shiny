% Generated by roxygen2 (4.0.2): do not edit by hand
\name{observeEvent}
\alias{observeEvent}
\title{Event handler}
\usage{
observeEvent(eventExpr, callback, env = parent.frame(), quoted = FALSE)
}
\description{
Event handler
}
\examples{
\dontrun{
# In ui.R:
shinyUI(basicPage(
  numericInput("n", "Number of observations", 5),
  actionButton("saveButton", "Save")
))
# In server.R:
shinyServer(function(input, output) {
  observeEvent(input$saveButton, function() {
    write.csv(runif(input$n), file = "data.csv")
  })
})
}
}
\seealso{
\code{\link{actionButton}}
}

