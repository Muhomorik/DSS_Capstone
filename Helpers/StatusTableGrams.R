# Helper table for storing information about ngrams processing in data.frame.


StatusTableGramsEmptyDf <- function() {
  # Creates an empty data.frame that is used to report ngram builder results.
  #
  # Returns:
  #   Empty data.frame with pre-defined columns.
  
  df_names <- c(
    "nGram", "skipGram", "GramsSize")
  
  # Empty df.
  df = data.frame(nGrams = numeric(), skipGram = character(), GramsSize = numeric())
}


StatusTableGramsDfItem <- function(nGrams, skipGrams, gramsSize) {
  # Creates a filled data.frame that is used to report ngram builder results.
  #
  # Returns:
  #   Empty data.frame with pre-defined columns.
  
  # Table columns for printing.
  df_names <- c(
    "nGram", "skipGram", "GramsSize")
  
  # df.
  df.new = data.frame(nGrams, 
                      paste(skipGrams, collapse = ","),
                      round(gramsSize, digits = 0)
  )
  names(df.new) <- df_names
  df.new
}
