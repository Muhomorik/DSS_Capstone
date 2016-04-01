CreateCustomDfm <- function(lines, n_grams, skipGrams=0, verbose = F){
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
                  #removeTwitter = T, # this one only removes hashtags. But we need it lates.
                  removeHyphens = T,
                  ngrams = n_grams,
                  skip = skipGrams,
                  verbose = verbose
  )
  
  # Most of the time, users will construct dfm objects from texts or a corpus, 
  # without calling tokenize() as an intermediate step.
  
  # The default behavior for ignoredFeatures when constructing ngrams using 
  # dfm(x, ngrams > 1) is to remove any ngram that contains any item in ignoredFeatures.
  ngrams <- dfm(tok,
                #toLower  = TRUE,
                language = "english",
                ignoredFeatures = stopwords("english"), 
                stem = FALSE, 
                verbose = verbose)
  
  # remove strange features starting with a number (enumerations, clock and so on.)
  ngrams<- selectFeatures(ngrams, c(
                                    "a\\.k\\.a", "a's",
                                    "u_([[:alnum:]]{4})", "f0", # utf codes, U+FF89>
                                    "www\\.", # things that starts with www, webpages.
                                    "(\\.com|\\.org|\\.edu|\\.net)", # pages, ends with .com.
                                    "#", "@", # remove hashtags, hings that starts with hashtag :D
                                    "(ha)+", # remove hahaha variants
                                    "[[:digit:]]", # everynhing with digits.
                                    "([^[:alnum:]_])",  #not Alphanumeric, garbage like ctrl.
                                    "\\_.$", "^.\\_" # starts/stops with a single letter
                                    ), 
                 "remove", 
                 valuetype = "regex",
                 verbose = verbose)
  
  # commonn one-words.
  selectFeatures(ngrams, c("rt", "aka", "ms", "ya", "yo", "ur", "oh", "da", "pm", "am", "xd",
                           "idk", "etc", "co", "btw", "hm", "cc", 
                           "b", "c", "d", "e", "f", "g", "h", "k", "m", "n", "o", 
                           "r", "s", "t", "w", "u","y", "x", 
                         "lol", "a1", "a3", "aa"), 
                 "remove", 
                 valuetype = "fixed",
                 verbose = verbose)
}

# Example
# df <- c("a's m lost a's may media a.k.a abc", "a3 cos a1 first aa preachers am aka @ ü ð 90am", 
#         "@c d e f www.newamericantheatre.com www.notesfromaglobalperspective.blogspot.com",
#         "ygjhheatre.com gfhpective.blogspot.com dsfgf.tumblr.com <U+062A>",
#         "#milliondollarlistingnewyork #reasonswhythecrimerategoup <U+3082>",
#         "<U+306E> <U+306E> <U+306F> <U+5728> <U+306E> <U+3066>",
#         "hahahahahahahahahahahahahahahahahahahahahaha hahahahahahahahahahahahahaha hahahaha",
#         "w.beyondthescoreboard.net_report tweeting_#momletemilygoseeaustin")
# 
# x <- CreateCustomDfm(df, 1, verbose = T)
# x

# mytexts <- c("The new law included a capital gains tax, and an inheritance tax.",
#              "New York City has raised a taxes: an income tax and a sales tax.")
# x2 <- CreateCustomDfm(mytexts, 1, verbose = T)
# x2
# 
# x3 <- x+x2
# x3
