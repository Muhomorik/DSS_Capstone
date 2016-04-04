# Helper table for storing information about ngrams processing in data.frame.


StatusTableGramsEmptyDf <- function() {
  # Creates an empty data.frame that is used to report ngram builder results.
  #
  # Returns:
  #   Empty data.frame with pre-defined columns.
  
  df_names <- c(
    "nGram", "skipGram", "GramsSize", "scaling")
  
  # Empty df.
  df = data.frame(nGrams = integer(), skipGram = integer(), GramsSize = integer(),
                  scaling = integer())
}


StatusTableGramsDfItem <- function(nGrams, skipGrams, gramsSize, scaling) {
  # Creates a filled data.frame that is used to report ngram builder results.
  #
  # Returns:
  #   Empty data.frame with pre-defined columns.
  
  # Table columns for printing.
  df_names <- c(
    "nGram", "skipGram", "GramsSize", "scaling")
  
  # df.
  df.new = data.frame(nGrams, 
                      paste(skipGrams, collapse = ","),
                      round(gramsSize, digits = 0),
                      scaling
  )
  names(df.new) <- df_names
  df.new
}
