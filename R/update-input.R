#' Change the value of a text input on the client
#'
#' @template update-input
#' @param value The value to set for the input object.
#'
#' @seealso \code{\link{textInput}}
#'
#' @examples
#' \dontrun{
#' shinyServer(function(input, output, session) {
#'
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     # This will change the value of input$inText, based on x
#'     updateTextInput(session, "inText", value = paste("New text", x))
#'
#'     # Can also set the label, this time for input$inText2
#'     updateTextInput(session, "inText2",
#'       label = paste("New label", x),
#'       value = paste("New text", x))
#'   })
#' })
#' }
#' @export
updateTextInput <- function(session, inputId, label = NULL, value = NULL) {
  message <- dropNulls(list(label=label, value=value))
  session$sendInputMessage(inputId, message)
}


#' Change the value of a checkbox input on the client
#'
#' @template update-input
#' @param value The value to set for the input object.
#'
#' @seealso \code{\link{checkboxInput}}
#'
#' @examples
#' \dontrun{
#' shinyServer(function(input, output, session) {
#'
#'   observe({
#'     # TRUE if input$controller is even, FALSE otherwise.
#'     x_even <- input$controller %% 2 == 0
#'
#'     updateCheckboxInput(session, "inCheckbox", value = x_even)
#'   })
#' })
#' }
#' @export
updateCheckboxInput <- updateTextInput


#' Change the value of a slider input on the client
#'
#' @template update-input
#' @param value The value to set for the input object.
#'
#' @seealso \code{\link{sliderInput}}
#'
#' @examples
#' \dontrun{
#' shinyServer(function(input, output, session) {
#'
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     # Similar to number and text. only label and value can be set for slider
#'     updateSliderInput(session, "inSlider",
#'       label = paste("Slider label", x),
#'       value = x)
#'
#'     # For sliders that pick out a range, pass in a vector of 2 values.
#'     updateSliderInput(session, "inSlider2", value = c(x-1, x+1))
#'
#'     # An NA means to not change that value (the low or high one)
#'     updateSliderInput(session, "inSlider3", value = c(NA, x+2))
#'   })
#' })
#' }
#' @export
updateSliderInput <- updateTextInput

#' Change the value of a date input on the client
#'
#' @template update-input
#' @param value The desired date value. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#' @param min The minimum allowed date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#' @param max The maximum allowed date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#'
#' @seealso \code{\link{dateInput}}
#'
#' @examples
#' \dontrun{
#' shinyServer(function(input, output, session) {
#'
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     updateDateInput(session, "inDate",
#'       label = paste("Date label", x),
#'       value = paste("2013-04-", x, sep=""),
#'       min   = paste("2013-04-", x-1, sep=""),
#'       max   = paste("2013-04-", x+1, sep="")
#'     )
#'   })
#' })
#' }
#' @export
updateDateInput <- function(session, inputId, label = NULL, value = NULL,
                            min = NULL, max = NULL) {

  # If value is a date object, convert it to a string with yyyy-mm-dd format
  # Same for min and max
  if (inherits(value, "Date"))  value <- format(value, "%Y-%m-%d")
  if (inherits(min, "Date"))    min   <- format(min,   "%Y-%m-%d")
  if (inherits(max, "Date"))    max   <- format(max,   "%Y-%m-%d")

  message <- dropNulls(list(label=label, value=value, min=min, max=max))
  session$sendInputMessage(inputId, message)
}


#' Change the start and end values of a date range input on the client
#'
#' @template update-input
#' @param start The start date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#' @param end The end date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#' @param min The minimum allowed date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#' @param max The maximum allowed date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#'
#' @seealso \code{\link{dateRangeInput}}
#'
#' @examples
#' \dontrun{
#' shinyServer(function(input, output, session) {
#'
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     updateDateRangeInput(session, "inDateRange",
#'       label = paste("Date range label", x),
#'       start = paste("2013-01-", x, sep=""))
#'       end = paste("2013-12-", x, sep=""))
#'   })
#' })
#' }
#' @export
updateDateRangeInput <- function(session, inputId, label = NULL,
                                 start = NULL, end = NULL, min = NULL,
                                 max = NULL) {
  # Make sure start and end are strings, not date objects. This is for
  # consistency across different locales.
  if (inherits(start, "Date"))  start <- format(start, '%Y-%m-%d')
  if (inherits(end, "Date"))    end <- format(end, '%Y-%m-%d')
  if (inherits(min, "Date"))    min <- format(min, '%Y-%m-%d')
  if (inherits(max, "Date"))    max <- format(max, '%Y-%m-%d')

  message <- dropNulls(list(
    label = label,
    value = c(start, end),
    min = min,
    max = max
  ))

  session$sendInputMessage(inputId, message)
}

#' Change the selected tab on the client
#'
#' @param session The \code{session} object passed to function given to
#'   \code{shinyServer}.
#' @param inputId The id of the \code{tabsetPanel}, \code{navlistPanel},
#' or \code{navbarPage} object.
#' @param selected The name of the tab to make active.
#'
#' @seealso \code{\link{tabsetPanel}}, \code{\link{navlistPanel}},
#' \code{\link{navbarPage}}
#'
#' @examples
#' \dontrun{
#' shinyServer(function(input, output, session) {
#'
#'   observe({
#'     # TRUE if input$controller is even, FALSE otherwise.
#'     x_even <- input$controller %% 2 == 0
#'
#'     # Change the selected tab.
#'     # Note that the tabset container must have been created with an 'id' argument
#'     if (x_even) {
#'       updateTabsetPanel(session, "inTabset", selected = "panel2")
#'     } else {
#'       updateTabsetPanel(session, "inTabset", selected = "panel1")
#'     }
#'   })
#' })
#' }
#' @export
updateTabsetPanel <- function(session, inputId, selected = NULL) {
  message <- dropNulls(list(value = selected))
  session$sendInputMessage(inputId, message)
}


#' Change the value of a number input on the client
#'
#' @template update-input
#' @param value The value to set for the input object.
#' @param min Minimum value.
#' @param max Maximum value.
#' @param step Step size.
#'
#' @seealso \code{\link{numericInput}}
#'
#' @examples
#' \dontrun{
#' shinyServer(function(input, output, session) {
#'
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     updateNumericInput(session, "inNumber", value = x)
#'
#'     updateNumericInput(session, "inNumber2",
#'       label = paste("Number label ", x),
#'       value = x, min = x-10, max = x+10, step = 5)
#'   })
#' })
#' }
#' @export
updateNumericInput <- function(session, inputId, label = NULL, value = NULL,
    min = NULL, max = NULL, step = NULL) {

  message <- dropNulls(list(
    label = label, value = formatNoSci(value),
    min = formatNoSci(min), max = formatNoSci(max), step = formatNoSci(step)
  ))
  session$sendInputMessage(inputId, message)
}

updateInputOptions <- function(session, inputId, label = NULL, choices = NULL,
                               selected = NULL, inline = FALSE,
                               type = 'checkbox') {

  choices <- choicesWithNames(choices)
  if (!is.null(selected))
    selected <- validateSelected(selected, choices, inputId)

  options <- if (length(choices))
    format(tagList(
      generateOptions(inputId, choices, selected, inline, type = type)
    ))

  message <- dropNulls(list(label = label, options = options, value = selected))

  session$sendInputMessage(inputId, message)
}

#' Change the value of a checkbox group input on the client
#'
#' @template update-input
#' @inheritParams checkboxGroupInput
#'
#' @seealso \code{\link{checkboxGroupInput}}
#'
#' @examples
#' \dontrun{
#' shinyServer(function(input, output, session) {
#'
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     # Create a list of new options, where the name of the items is something
#'     # like 'option label x 1', and the values are 'option-x-1'.
#'     cb_options <- list()
#'     cb_options[[sprintf("option label %d 1", x)]] <- sprintf("option-%d-1", x)
#'     cb_options[[sprintf("option label %d 2", x)]] <- sprintf("option-%d-2", x)
#'
#'     # Change values for input$inCheckboxGroup
#'     updateCheckboxGroupInput(session, "inCheckboxGroup", choices = cb_options)
#'
#'     # Can also set the label and select items
#'     updateCheckboxGroupInput(session, "inCheckboxGroup2",
#'       label = paste("checkboxgroup label", x),
#'       choices = cb_options,
#'       selected = sprintf("option-%d-2", x)
#'     )
#'   })
#' })
#' }
#' @export
updateCheckboxGroupInput <- function(session, inputId, label = NULL,
                                     choices = NULL, selected = NULL,
                                     inline = FALSE) {
  updateInputOptions(session, inputId, label, choices, selected, inline)
}


#' Change the value of a radio input on the client
#'
#' @template update-input
#' @inheritParams radioButtons
#'
#' @seealso \code{\link{radioButtons}}
#'
#' @examples
#' \dontrun{
#' shinyServer(function(input, output, session) {
#'
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     r_options <- list()
#'     r_options[[sprintf("option label %d 1", x)]] <- sprintf("option-%d-1", x)
#'     r_options[[sprintf("option label %d 2", x)]] <- sprintf("option-%d-2", x)
#'
#'     # Change values for input$inRadio
#'     updateRadioButtons(session, "inRadio", choices = r_options)
#'
#'     # Can also set the label and select an item
#'     updateRadioButtons(session, "inRadio2",
#'       label = paste("Radio label", x),
#'       choices = r_options,
#'       selected = sprintf("option-%d-2", x)
#'     )
#'   })
#' })
#' }
#' @export
updateRadioButtons <- function(session, inputId, label = NULL, choices = NULL,
                               selected = NULL, inline = FALSE) {
  # you must select at least one radio button
  if (is.null(selected) && !is.null(choices)) selected <- choices[[1]]
  updateInputOptions(session, inputId, label, choices, selected, inline, type = 'radio')
}


#' Change the value of a select input on the client
#'
#' @template update-input
#' @inheritParams selectInput
#'
#' @seealso \code{\link{selectInput}}
#'
#' @examples
#' \dontrun{
#' shinyServer(function(input, output, session) {
#'
#'   observe({
#'     # We'll use the input$controller variable multiple times, so save it as x
#'     # for convenience.
#'     x <- input$controller
#'
#'     # Create a list of new options, where the name of the items is something
#'     # like 'option label x 1', and the values are 'option-x-1'.
#'     s_options <- list()
#'     s_options[[sprintf("option label %d 1", x)]] <- sprintf("option-%d-1", x)
#'     s_options[[sprintf("option label %d 2", x)]] <- sprintf("option-%d-2", x)
#'
#'     # Change values for input$inSelect
#'     updateSelectInput(session, "inSelect", choices = s_options)
#'
#'     # Can also set the label and select an item (or more than one if it's a
#'     # multi-select)
#'     updateSelectInput(session, "inSelect2",
#'       label = paste("Select label", x),
#'       choices = s_options,
#'       selected = sprintf("option-%d-2", x)
#'     )
#'   })
#' })
#' }
#' @export
updateSelectInput <- function(session, inputId, label = NULL, choices = NULL,
                              selected = NULL) {
  choices <- choicesWithNames(choices)
  if (!is.null(selected))
    selected <- validateSelected(selected, choices, inputId)
  options <- if (length(choices)) selectOptions(choices, selected)
  message <- dropNulls(list(label = label, options = options, value = selected))
  session$sendInputMessage(inputId, message)
}

#' @rdname updateSelectInput
#' @inheritParams selectizeInput
#' @param server whether to store \code{choices} on the server side, and load
#'   the select options dynamically on searching, instead of writing all
#'   \code{choices} into the page at once (i.e., only use the client-side
#'   version of \pkg{selectize.js})
#' @export
updateSelectizeInput <- function(session, inputId, label = NULL, choices = NULL,
                                 selected = NULL, options = list(),
                                 server = FALSE) {
  if (length(options)) {
    res <- checkAsIs(options)
    cfg <- tags$script(
      type = 'application/json',
      `data-for` = inputId,
      `data-eval` = if (length(res$eval)) HTML(toJSON(res$eval)),
      HTML(toJSON(res$options))
    )
    session$sendInputMessage(inputId, list(config = as.character(cfg)))
  }
  if (!server) {
    return(updateSelectInput(session, inputId, label, choices, selected))
  }
  # in the server mode, the choices are not available before we type, so we
  # cannot really pre-select any options, but here we insert the `selected`
  # options into selectize forcibly
  value <- unname(selected)
  selected <- choicesWithNames(selected)
  message <- dropNulls(list(
    label = label,
    value = value,
    selected = if (length(selected)) {
      columnToRowData(list(label = names(selected), value = selected))
    },
    url = session$registerDataObj(inputId, choices, selectizeJSON)
  ))
  session$sendInputMessage(inputId, message)
}

selectizeJSON <- function(data, req) {
  query <- parseQueryString(req$QUERY_STRING)
  # extract the query variables, conjunction (and/or), search string, maximum options
  var <- unlist(fromJSON(query$field, asText = TRUE))
  cjn <- if (query$conju == 'and') all else any
  # all keywords in lower-case, for case-insensitive matching
  key <- unique(strsplit(tolower(query$query), '\\s+')[[1]])
  if (identical(key, '')) key <- character(0)
  mop <- query$maxop

  # convert a single vector to a data frame so it returns {label: , value: }
  # later in JSON; other objects return arbitrary JSON {x: , y: , foo: , ...}
  data <- if (is.atomic(data)) {
    data.frame(label = names(choicesWithNames(data)), value = data,
               stringsAsFactors = FALSE)
  } else as.data.frame(data, stringsAsFactors = FALSE)

  # start searching for keywords in all specified columns
  idx <- logical(nrow(data))
  if (length(key)) for (v in var) {
    matches <- do.call(
      cbind,
      lapply(key, function(k) {
        grepl(k, tolower(as.character(data[[v]])), fixed = TRUE)
      })
    )
    # merge column matches using OR, and match multiple keywords in one column
    # using the conjunction setting (AND or OR)
    idx <- idx | apply(matches, 1, cjn)
  }
  # only return the first n rows (n = maximum options in configuration)
  idx <- head(which(idx), mop)
  data <- data[idx, ]

  httpResponse(200, 'application/json', toJSON(columnToRowData(data)))
}
