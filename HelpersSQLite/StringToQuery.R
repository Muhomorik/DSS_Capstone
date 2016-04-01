StringToQuery <- function(string, n){
  # Takes string and in some strange way converts it into the vector with last
  # N-wors to search in the db.
  #
  # Args:
  #   string: string to split.
  
  lines <- toLower(string)
  
  # Very strange way of doing that, but must remove things the same way.
  tok <- tokenize(lines, 
                  removeNumbers = T, 
                  removePunct = T, 
                  removeSeparators = T,
                  removeTwitter = T,
                  removeHyphens = T,
                  skip = 0,
                  verbose = F, simplify = TRUE
  )
  
  # To data.frame, tmp step.
  tok2 <- as.data.frame(tok)
  names(tok2) <- c("nm")
  tok2$nm <- as.character(tok2$nm)
  
  # filter stopwords
  filter <- !(tok2$nm %in% stopwords("english"))
  tok3 <- tok2[filter,]
  
  # filter last n-words.
  len <- length(tok3)
  x <- tok3[(len+1-n):len]
  x
}


# Example:

# phrase9 <- "Be grateful for the good times and keep the faith during the mamma mia"
# phrase10 <- "If this isn't the cutest thing you've ever seen, then you must be"
# 
# StringToQuery(phrase9, 2)
# StringToQuery(phrase10, 3)
