# Create sql query.

QueryStringLevel1 <- function(key1, limit = 20){
  # Create query for ngrams selection from db.
  #
  # Args:
  #   key1: ngram 1
  #   limit: max results
  
  q1 <- paste ("SELECT * FROM ", GQLiteGetTablebyNGrams(1), " WHERE ", 
               "key1 LIKE '", key1, "'",
               " LIMIT ", limit,
               sep = "", collapse = NULL)
  q1
}

QueryStringLevel2 <- function(key1, key2, limit = 20){
  # Create query for ngrams selection from db.
  #
  # Args:
  #   key1: ngram 1
  #   key2: ngram 2
  #   limit: max results
  
  q2 <- paste ("SELECT * FROM ", GQLiteGetTablebyNGrams(2), " WHERE ", 
               "key1 like '", key1, "%' AND ",
               "key2 like '", key2, "%'",
               " LIMIT ", limit,
               sep = "", collapse = NULL)
  q2
}


QueryStringLevel3 <- function(key1, key2, key3, limit = 20){
  # Create query for ngrams selection from db.
  #
  # Args:
  #   key1: ngram 1
  #   key2: ngram 2
  #   key3: ngram 3
  #   limit: max results
  
  q3 <- paste ("SELECT * FROM ", GQLiteGetTablebyNGrams(3), " WHERE ", 
               "key1 like '", key1, "%' AND ",
               "key2 like '", key2, "%' AND ",
               "key3 like '", key3, "%'",
               " LIMIT ", limit,
               sep = "", collapse = NULL)
  q3
}

QueryStringLevel4 <- function(key1, key2, key3, key4, limit = 20){
  # Create query for ngrams selection from db.
  #
  # Args:
  #   key1: ngram 1
  #   key2: ngram 2
  #   key3: ngram 3
  #   key4: ngram 4
  #   limit: max results
  
  q3 <- paste ("SELECT * FROM ", GQLiteGetTablebyNGrams(3), " WHERE ", 
               "key1 like '", key1, "%' AND ",
               "key2 like '", key2, "%' AND ",
               "key3 like '", key3, "%' AND ",
               "key4 like '", key4, "%'",
               " LIMIT ", limit,
               sep = "", collapse = NULL)
  q3
}

# Examles

# QueryStringLevel1("abc", limit = 30)
# QueryStringLevel2("abc", "bac", limit = 30)
# QueryStringLevel3("abc", "bac", "smth else", limit = 30)
# QueryStringLevel3("abc", "bac", "smth", "k4", limit = 30)
