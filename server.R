
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


#
#  NOTE: COPY SQLite Helpers to dir!
#

# exceptions
# http://mazamascience.com/WorkingWithData/?p=912
# format time.
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/strptime.html
library(shiny)
library(RSQLite)

shinyServer(function(input, output) {
  # Other objects inside the function, such as variables and functions,
  # are also instantiated for each session.

  # Can create a local variable varA, which will be a copy of the shared variable
  # varA plus 1. This local copy of varA is not be visible in other sessions.
  # With <- or change the global var with <<-.

  source("HelpersSQLite/SQLiteHelpers.R", local = TRUE)
  source("HelpersSQLite/QueryString.R", local = TRUE)
  source("HelpersSQLite/StringToQuery.R", local = TRUE)

  # Reactive search terms, returns a vector of last X items, plitted by space.
  searchTerms <- reactive({
    split_input <- gsub("'", "", input$text, ignore.case = T) # removed by the tokenizer.
    split_input <- strsplit(split_input, " ")
    len <- length(split_input[[1]])

    if (len == 0) {
      keys1 <- c()
      #message("0")
    } else if (len == 1) {
      keys1 <- c(split_input[[1]][(len)] )
      #message("1")
    }  else if (len == 2) {
      keys1 <- c(split_input[[1]][(len-1)], split_input[[1]][(len)])
      #message("2")
    }  else { # if (len == 3) {
      keys1 <- c(split_input[[1]][(len-2)], split_input[[1]][(len-1)], split_input[[1]][(len)])
      #message("3")
    }

    # From: The guy in front of me just bought
    # TO: of me just bought

    keys1
  })

  #
  # Prediction results
  #

  output$query1 <- DT::renderDataTable({

    len <- length(searchTerms())

    keys1 <- searchTerms()[(len)]
    keys2 <- searchTerms()[(len-1)]
    keys3 <- searchTerms()[(len-2)]

    # db part
    con <- SQLiteGetConn("grams_db1.sqlite")
    q1 <- QueryStringLevel1(keys1)
    res <- dbGetQuery(con, q1)
    invisible(dbDisconnect(con))

    DT::datatable(res[1:1], options = list(searching = TRUE), rownames= FALSE)
  })

  output$query2 <- DT::renderDataTable({

    len <- length(searchTerms())

    keys1 <- searchTerms()[(len)]
    keys2 <- searchTerms()[(len-1)]
    keys3 <- searchTerms()[(len-2)]

    # db part
    con <- SQLiteGetConn("grams_db1.sqlite")
    q1 <- QueryStringLevel2(keys1)
    res <- dbGetQuery(con, q1)
    invisible(dbDisconnect(con))

    DT::datatable(res[2:3], options = list(searching = TRUE), rownames= FALSE)
  })

  output$query3 <- DT::renderDataTable({

    len <- length(searchTerms())

    keys1 <- searchTerms()[(len)]
    keys2 <- searchTerms()[(len-1)]
    keys3 <- searchTerms()[(len-2)]

    # db part
    con <- SQLiteGetConn("grams_db1.sqlite")
    q1 <- QueryStringLevel3(keys2, keys1)
    res <- dbGetQuery(con, q1)
    invisible(dbDisconnect(con))

    DT::datatable(res[2:4], options = list(searching = TRUE), rownames= FALSE)
  })

  output$query4 <- DT::renderDataTable({

    len <- length(searchTerms())

    keys1 <- searchTerms()[(len)]
    keys2 <- searchTerms()[(len-1)]
    keys3 <- searchTerms()[(len-2)]

    # db part
    con <- SQLiteGetConn("grams_db1.sqlite")
    q1 <- QueryStringLevel4(keys3, keys2, keys1)
    res <- dbGetQuery(con, q1)
    invisible(dbDisconnect(con))
    q1
    DT::datatable(res[2:5], options = list(searching = TRUE, autoWidth = TRUE), rownames= FALSE)
  })

  #
  # Plots
  # Note: some leftovers.
  #

  output$ngramsPlot <- renderPlot({

    # db part
    con <- SQLiteGetConn("grams_db1.sqlite")
    q1 <- QueryStringStatusTable()
    res <- dbGetQuery(con, q1)
    invisible(dbDisconnect(con))

    #draw the histogram with the specified number of bins
    barplot(res$GramsSize,
            names.arg = res$nGram,
            main = "NGrams count", xlab = "ngram", ylab = "ngram count")

  })

  #
  # Search terms for every table shown.
  # With some leftovers...
  #

  output$predsearch1 <- renderText({
    len <- length(searchTerms())
    paste(searchTerms()[len], "*" , sep = "" , collapse = " ")
  })

  output$predsearch2 <- renderText({
    len <- length(searchTerms())
    if(TRUE){
      paste(searchTerms()[(len-1):(len)], "*" , sep = "" , collapse = " ")
    } else {
      "enter more words"
    }
  })

  output$predsearch3 <- renderText({
    len <- length(searchTerms())
    if(TRUE){
      paste(searchTerms()[(len-1):(len)], "*" , sep = "" , collapse = " ")
    } else {
      "enter more words (min 1)"
    }
  })

  output$predsearch4 <- renderText({
    len <- length(searchTerms())
    if(TRUE){
      paste(searchTerms()[(len-2):(len)], "*" , sep = "" , collapse = " ")
    } else {
      "enter more words (min 2)"
    }
  })
})
