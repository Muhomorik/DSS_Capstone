
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# exceptions
# http://mazamascience.com/WorkingWithData/?p=912
# format time.
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/strptime.html
library(shiny)
library(RSQLite)

# Source globally (functions only).
source("HelpersSQLite/SQLiteHelpers.R")
source("HelpersSQLite/QueryString.R")
source("HelpersSQLite/StringToQuery.R")

shinyServer(function(input, output) {
  # Other objects inside the function, such as variables and functions,
  # are also instantiated for each session.

  # Can create a local variable varA, which will be a copy of the shared variable
  # varA plus 1. This local copy of varA is not be visible in other sessions.
  # With <- or change the global var with <<-.

  # Reactive search terms, returns a vector of last X items, plitted by space.
  searchTermsNew <- reactive({
    split_input <- gsub("'", "", input$text, ignore.case = T) # removed by the tokenizer.
    split_input <- strsplit(split_input, " ")
    len <- length(split_input[[1]])
    
    # remake to real split in one line.
    if (len == 0) {
      keys <- c("" ,"" ,"" )
    } else if (len == 1) {
      keys <- c("" , "", split_input[[1]][(len)] )
    }  else if (len == 2) {
      keys <- c("", split_input[[1]][(len-1)], split_input[[1]][(len)] )
    }  else { # if (len == 3) {
      keys <- c(split_input[[1]][(len-2)], split_input[[1]][(len-1)], split_input[[1]][(len)])
    }
    
    # From: The guy in front of me just bought
    # TO: of me just bought
    keys1 <- keys[3]
    keys2 <- keys[2]
    keys3 <- keys[1]
    
    # message("len: ", paste(keys, sep = " ", collapse = " " ))
    # message("key1: ", keys[3])
    # message("key2: ", keys[2])
    # message("key3: ", keys[1])
    
    # db part
    con <- SQLiteGetConn("grams_db1.sqlite")
    q1 <- QueryStringLevel1(keys1)
    
    # q1
    res1 <- dbGetQuery(con, q1)
    # q2
    q2 <- QueryStringLevel2(keys1)
    res2 <- dbGetQuery(con, q2)
    # q3
    q3 <- QueryStringLevel3(keys2, keys1)
    res3 <- dbGetQuery(con, q3)    
    #q4
    q4 <- QueryStringLevel4(keys3, keys2, keys1)
    res4 <- dbGetQuery(con, q4)    
    
    invisible(dbDisconnect(con))
    
    list(
      res1 = res1[1:1], 
      res2 = res2[2:3], 
      res3 = res3[2:4], 
      res4 = res4[2:5],
      keys = keys)
  })
  
  #
  # Prediction results
  #

  output$query1 <- DT::renderDataTable({

    DT::datatable(searchTermsNew()$res1, options = list(searching = FALSE), rownames= FALSE)
  })

  output$query2 <- DT::renderDataTable({

    DT::datatable(searchTermsNew()$res2, options = list(searching = TRUE), rownames= FALSE)
  })

  output$query3 <- DT::renderDataTable({

    DT::datatable(searchTermsNew()$res3, options = list(searching = TRUE), rownames= FALSE)
  })

  output$query4 <- DT::renderDataTable({

    DT::datatable(searchTermsNew()$res4, options = list(searching = TRUE, autoWidth = TRUE), rownames= FALSE)
  })

  #
  # Search terms for every table shown.
  # With some leftovers...
  #

  output$predsearch1 <- renderText({
    keys <- searchTermsNew()$keys
    len <- length(keys)
    paste(keys[len], "*" , sep = "" , collapse = " ")
  })

  output$predsearch2 <- renderText({
    keys <- searchTermsNew()$keys
    len <- length(keys)
    paste(keys[(len-1):(len)], "*" , sep = "" , collapse = " ")
  })

  output$predsearch3 <- renderText({
    keys <- searchTermsNew()$keys
    len <- length(keys)
    paste(keys[(len-1):(len)], "*" , sep = "" , collapse = " ")
  })

  output$predsearch4 <- renderText({
    keys <- searchTermsNew()$keys
    len <- length(keys)
    paste(keys[(len-2):(len)], "*" , sep = "" , collapse = " ")
  })
  
  
  output$predictionOut <- renderText({ 
    pred4 <- searchTermsNew()$res4
    pred3 <- searchTermsNew()$res3
    pred2 <- searchTermsNew()$res2
    pred1 <- searchTermsNew()$res1
    
    if(length(pred4$key4) != 0){
      pred4[1, c("key4")]
    } else if (length(pred3$key3) != 0) {
      pred3[1, c("key3")]
    } else if (length(pred2$key2) != 0){
      pred2[1, c("key2")]
    } else if (length(pred1$key1) != 0) {
      pred1[1, c("key1")]
    } else {
      "* no idea ;) *"      
    }

  })
})
