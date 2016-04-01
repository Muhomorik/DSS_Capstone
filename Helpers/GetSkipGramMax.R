GetSkipGramMax <- function(nGrams){
  # Get max allowed value for skips for current ngrams
  #
  # Args:
  #   nGrams: NGrams .  
  
  #      1  2  3  4  5  6
  v <- c(0, 4, 2, 0, 0, 0) # 1gram, 2 gram, etc
  v[nGrams]
}
