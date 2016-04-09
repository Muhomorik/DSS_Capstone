rm(list=ls())

setwd("~/R Projects/Coursera/10 - DSS Capstone Project")

library(quanteda)
library(pryr)

path <- "Coursera-SwiftKey/final"

loc.de_DE <- "de_DE"
loc.en_US <- "en_US"
loc.fi_FI <- "fi_FI"
loc.ru_RU <- "ru_RU"

file.blogs <- ".blogs.txt"
file.news <- ".news.txt"
file.twitter <- ".twitter.txt"

file_Us_blogs <- paste0(loc.en_US, file.blogs)
file_Us_news <- paste0(loc.en_US, file.news)
file_Us_twitter <- paste0(loc.en_US, file.twitter)

path_Us_blogs <- paste0(path, "/", loc.en_US, "/", file_Us_blogs)
path_Us_news <- paste0(path, "/", loc.en_US, "/", file_Us_news)
path_Us_twitter <- paste0(path, "/", loc.en_US, "/", file_Us_twitter)

outputFolder <- "vs"
out.path_Us_blogs <- paste0(outputFolder, "/", file_Us_blogs)
out.path_Us_news <- paste0(outputFolder, "/", file_Us_news)
out.path_Us_twitter <- paste0(outputFolder, "/", file_Us_twitter)

ReadFile <- function(textFile,  nlines = 25000){
  # Rean a small samle of the data (n-lines). Removes common garbage.
  #
  # Args:
  #   textFile: Filepath to file.
  #   nlines: number of lines to read.
  #
  # Returns:
  #   Vector of lines, divided by new-line charachter.
  
  # Read data
  con  <- file(textFile, open = "r")
  oneLine <- readLines(con,  warn = FALSE, encoding = "UTF-8", n = nlines)
  close(con)
  
  # Escape unifode madness like: <f0><U+009F><U+0098><U+0096><f0><U+009F><U+0098>
  oneLine <- gsub("<(U\\+00..|f0)>", " ", oneLine, ignore.case = T)
  
  invisible(oneLine)
}

makeCorpus <- function(lines, n_grams, verbose = F){
  # Make a corpus from data.
  
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

# Blogs
lines.blogs <- ReadFile(out.path_Us_blogs)
dfm.blogs <- makeCorpus(lines.blogs, 1, F)

topfeatures(dfm.blogs, 8)


# News
lines.news <- ReadFile(out.path_Us_news)
dfm.news <- makeCorpus(lines.news, 1, F)

topfeatures(dfm.news, 8)


# Twiter
lines.twitter <- ReadFile(out.path_Us_twitter)
dfm.twitter <- makeCorpus(lines.twitter, 1, F)

topfeatures(dfm.twitter, 8)


# topfeatures
tokenInfo4 <- topfeatures(dfm.twitter, decreasing=T, n=40)
df_freq <- data.frame(keyName=names(tokenInfo4), value=tokenInfo4, row.names=NULL)

f_df <- topfeatures(dfm.twitter, n=20000)
df_fall <- data.frame(keyName=names(f_df), value=f_df, row.names=NULL)

# Combine DFM
dfm1 <- dfm("This is a sample text.", verbose = FALSE)
dfm2 <- dfm("one two three", verbose = FALSE)
cbind(dfm1, dfm2)

# calculate lexical diversity
mydfm <- dfm(subset(inaugCorpus, Year>1980))
mydfmSW <- dfm(subset(inaugCorpus, Year>1980), ignoredFeatures=stopwords("english"))
results <- data.frame(TTR = lexdiv(mydfm, "TTR"),
                      CTTR = lexdiv(mydfm, "CTTR"),
                      U = lexdiv(mydfm, "U"),
                      TTRs = lexdiv(mydfmSW, "TTR"),
                      CTTRs = lexdiv(mydfmSW, "CTTR"),
                      Us = lexdiv(mydfmSW, "U"))
results
cor(results)
t(lexdiv(mydfmSW, "Maas"))

# colocations
collocations("This is a sample text.", method = c("lr", "chi2", "pmi", "dice",
                           "all"), size = 2, n = NULL, spanPunct = FALSE)

coll <- collocations(lines.twitter, method = c("lr", "chi2", "pmi", "dice", "all"), 
             size = 3, n = NULL, spanPunct = FALSE)
