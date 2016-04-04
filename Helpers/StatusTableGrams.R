# Helper table for storing information about ngrams processing in data.frame.


StatusTableGramsEmptyDf <- function() {
  # Creates an empty data.frame that is used to report ngram builder results.
  #
  # Returns:
  #   Empty data.frame with pre-defined columns.
  
  df_names <- c(
    "nGram", "skipGram", "GramsSize", "scaling", "runtime")
  
  # Empty df.
  df = data.frame(nGrams = integer(), skipGram = integer(), GramsSize = integer(),
                  scaling = integer(), runtime = numeric())
}


StatusTableGramsDfItem <- function(nGrams, skipGrams, gramsSize, scaling, runtime) {
  # Creates a filled data.frame that is used to report ngram builder results.
  #
  # Returns:
  #   Empty data.frame with pre-defined columns.
  
  # Table columns for printing.
  df_names <- c(
    "nGram", "skipGram", "GramsSize", "scaling", "runtime")
  
  # df.
  df.new = data.frame(nGrams, 
                      paste(skipGrams, collapse = ","),
                      round(gramsSize, digits = 0),
                      scaling, runtime
  )
  names(df.new) <- df_names
  df.new
}
