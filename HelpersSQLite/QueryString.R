# Create sql query.

QueryStringLevel1 <- function(key1, limit = 20){
  # Create query for ngrams selection from db.
  #
  # Args:
  #   key1: ngram 1
  #   limit: max results

  q1 <- paste ("SELECT * FROM ", SQLiteGetTablebyNGrams(1), " WHERE ",
               "key1 LIKE '", key1, "%'",
               " ORDER BY value ASC ",
               " LIMIT ", limit,
               sep = "",
               collapse = NULL)
  q1
}

QueryStringLevel2 <- function(key1, key2 = NULL, limit = 20){
  # Create query for ngrams selection from db.
  #
  # Args:
  #   key1: ngram 1
  #   key2: ngram 2
  #   limit: max results

  q3 <- paste ("SELECT * FROM ", SQLiteGetTablebyNGrams(2), " WHERE ",
               "key1 LIKE '", key1, "%'",
               sep = "", collapse = NULL)

  if(!is.null(key2)){
    q3 <- paste (q3,
                 " AND key2 LIKE '", key2, "%'",
                 sep = "", collapse = NULL)
  }

  q3 <- paste (q3,
               " ORDER BY value ASC ",
               " LIMIT ", limit,
               sep = "",
               collapse = NULL)
  q3
}


QueryStringLevel3 <- function(key1, key2 = NULL, key3 = NULL, limit = 20){
  # Create query for ngrams selection from db.
  #
  # Args:
  #   key1: ngram 1
  #   key2: ngram 2
  #   key3: ngram 3
  #   limit: max results

  q3 <- paste ("SELECT * FROM ", SQLiteGetTablebyNGrams(3), " WHERE ",
               "key1 LIKE '", key1, "%'",
               sep = "", collapse = NULL)

  if(!is.null(key2)){
    q3 <- paste (q3,
                 " AND key2 LIKE '", key2, "%'",
                 sep = "", collapse = NULL)
  }

  if(!is.null(key3)){
    q3 <- paste (q3,
                 " AND key3 LIKE '", key3, "%'",
                 sep = "", collapse = NULL)
  }

  q3 <- paste (q3,
               " ORDER BY value ASC ",
               " LIMIT ", limit,
               sep = "",
               collapse = NULL)
  q3
}

QueryStringLevel4 <- function(key1, key2 = NULL, key3 = NULL, key4 = NULL, limit = 20){
  # Create query for ngrams selection from db.
  #
  # Args:
  #   key1: ngram 1
  #   key2: ngram 2
  #   key3: ngram 3
  #   key4: ngram 4
  #   limit: max results

  q3 <- paste ("SELECT * FROM ", SQLiteGetTablebyNGrams(4), " WHERE ",
               "key1 LIKE '", key1, "%'",
               sep = "", collapse = NULL)

  if(!is.null(key2)){
    q3 <- paste (q3,
                 " AND key2 LIKE '", key2, "%'",
                  sep = "", collapse = NULL)
  }

  if(!is.null(key3)){
    q3 <- paste (q3,
                 " AND key3 LIKE '", key3, "%'",
                 sep = "", collapse = NULL)
  }

  if(!is.null(key4)){
    q3 <- paste (q3,
                 " AND key4 LIKE '", key4, "%'",
                 sep = "", collapse = NULL)
  }

  q3 <- paste (q3,
               " ORDER BY value ASC ",
               " LIMIT ", limit,
              sep = "",
              collapse = NULL)
  q3
}

QueryStringStatusTable <- function(){
  # Requests the whole (max 5 rows) status table from db.
  #

  q3 <- paste ("SELECT * FROM ", "runStatus",
               sep = "", collapse = NULL)

  q3
}

# Examles

# QueryStringLevel1("abc", limit = 30)
# QueryStringLevel2("abc", "bac", limit = 30)
# QueryStringLevel3("abc", "bac", "smth else", limit = 30)
# QueryStringLevel4("a", "b", "c", "d", limit = 30)
