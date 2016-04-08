# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
# verbatimTextOutput("image_brushinfo")

# http://shiny.rstudio.com/articles/layout-guide.html

# Tables
# http://shiny.rstudio.com/gallery/datatables-demo.html
# http://shiny.rstudio.com/gallery/datatables-options.html

library(shiny)


shinyUI(navbarPage(
  #theme = "bootstrap.css",
  ""
  ,
  tabPanel(
    "Prediction",
    fluidPage(
      fluidRow(
        column(width = 8,
          #"Fluid 12",
          textInput(
            "text",
            label = "Start typing here",
            value = "And if you a", 
            width = "100%"
          )
        ),  
        column(width = 4,
            p(strong("Prediction, next word")),
            textOutput("predictionOut")               
        )

      ),
      fluidRow(
        column(width = 12,
          p(
           "continue tying: ..are professor of the year. If you type less than 3 words
           it will suggest words you should have typed."
          ),
          hr(),
          h4("Prediction terms: ")          
        )  
      ),
      # Search terms row
      fluidRow(
        column(2,
               verbatimTextOutput("predsearch1")),
        column(width = 3,
               verbatimTextOutput("predsearch2")),
        column(width = 3,
               verbatimTextOutput("predsearch3")),
        column(width = 4,
               verbatimTextOutput("predsearch4"))
      ),
      
      # Rown with help.
      fluidRow(
        column(2,
               h5("1-grams"),
               p("Predicts current word as you type it.")),
        column(
          width = 3,
          h5("2-ngrams "),
          p("Predicts next word based on word you type."),
          p("Best match for current word in KEY1, next work in KEY2.")
        ),
        column(
          width = 3,
          h5("3-ngrams "),
          p("Predicts next word based on previous 1 words."),
          p("Best match for current word in KEY2, next work in KEY3.")
        ),
        column(
          width = 4,
          h5("4-ngrams "),
          p("Predicts next word based on previous 2 words."),
          p("Best match for current word in KEY3, next work in KEY4.")
        )
      ),
      # Rows with prediction.
      fluidRow(
        column(2,
               DT::dataTableOutput('query1')),
        column(width = 3,
               DT::dataTableOutput('query2')),
        column(width = 3,
               DT::dataTableOutput('query3')),
        column(width = 4,
               DT::dataTableOutput('query4'))
      )
      
    )
  ),
  tabPanel("About",
           fluidPage(verticalLayout(
             includeMarkdown("AppAbout.md")
           ))),
  tabPanel("Examples",
           fluidPage(includeMarkdown("AppExamles.md")))
))
