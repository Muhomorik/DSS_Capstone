CreateCustomDfm <- function(lines, n_grams, verbose = F){
  # Make a customized DFM from lines (vector).
  #
  # Args:
  #   lines: vector to read.
  #   n_grams: NGrams.
  #   verbose: print messages.

  # Lovering the canse doesn't work later (ignored??)
  lines <- toLower(lines)
  
  # ngrams will be called through tokenize, but these functions are also exported 
  # in case a user wants to perform lower-level ngram construction on tokenized texts.
  tok <- tokenize(lines, 
                  removeNumbers = T, 
                  removePunct = T, 
                  removeSeparators = T,
                  removeHyphens = T,
                  ngrams = n_grams,
                  verbose = verbose
  )
  
  #  Most of the time, users will construct dfm objects from texts or a corpus, 
  # without calling tokenize() as an intermediate step.
  
  # The default behavior for ignoredFeatures when constructing ngrams using 
  # dfm(x, ngrams > 1) is to remove any ngram that contains any item in ignoredFeatures.
  ngrams <- dfm(tok,
                toLower  = TRUE,
                language = "english",
                ignoredFeatures = stopwords("english"), 
                stem = TRUE, 
                #ngrams = 3, 
                verbose = verbose)
  invisible(ngrams)
}
