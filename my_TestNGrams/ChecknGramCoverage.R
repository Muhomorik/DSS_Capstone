rm(list=ls())
setwd("~/R Projects/Coursera/10 - DSS Capstone Project")

# Libraries
library(quanteda)
library(data.table)
library(RSQLite)
library(knitr)

source("Helpers/filePaths.R")
source("Helpers/ReadAndCleanFile.R")
source("Helpers/MakeTrainTestByMemory.R")
source("Helpers/CreateCustomDfm.R")
source("Helpers/CreateDocFreq.R")

source("HelpersSQLite/SQLiteHelpers.R")

linesTwitter.Train <- ReadAndCleanFile("sample/train_en_US.twitter.txt")
linesTwitter.Test <- ReadAndCleanFile("sample/test_en_US.twitter.txt")

#linesTwitter.Test <- ReadAndCleanFile("sample/train_en_US.twitter.txt")

# linesTwitter.Train <- ReadAndCleanFile(path_Us_twitter)
# linesTwitter.Test <- ReadAndCleanFile(path_Us_twitter)

# Table columns.
df_names <- c(
  "nGram", "skipGram",
  "gramsTrain", "gramsTest",
  "ResultNotInTrain",
  "ResultTest", "ResultTrain", "TestTrain")

# Empty df.
df = data.frame(nGrams = numeric(), skipGram = character(),
                gramsTrain = numeric(), gramsTest = numeric(),
                ResultNotInTrain = numeric(),
                ResultTest = numeric(), ResultTrain = numeric(), TestTrain = numeric()
)

# Define params.
skipgrams.Max <- 2 #use 6 for ngrams 2
nGrams <- 2

# force skipgrams to 0 for nGrams=0. Ignored, but will create extra loops.
if(nGrams == 1) skipgrams.Max <- 0

# memory limits (skip crashes) ;)
#if(nGrams == 3) skipgrams.Max <- 4

for(skipgrams.i in 0:skipgrams.Max){
  skipGrams <- 0:skipgrams.i

  message("Calculating skipgrams: ", paste( skipGrams, collapse = " "))

# Get both docFreq's
freqDt.train <- CreateDocFreq(linesTwitter.Train, n_grams = nGrams, skipGrams = skipGrams, trim=T)
freqDt.test <- CreateDocFreq(linesTwitter.Test, n_grams = nGrams, skipGrams = 0, trim=T) # no skips
invisible(gc())

# fix different names
setnames(freqDt.train, c("keyName","valueTrain") )
setnames(freqDt.test, c("keyName","valueTest") )

# print
#kable(head(freqDt.train), format = "markdown")
#kable(head(freqDt.test), format = "markdown")

# Merge big one (train) into small one (test)

# the LEFT OUTER JOIN returns all the rows from the left table, 
# filling in matched columns (or NA) from the right table
# Filter only na.
Result <- merge(freqDt.test,freqDt.train, all.x=TRUE, by="keyName")
Result <-Result[is.na(valueTrain)]#[,long:=nchar(keyName)][long>3]

# Dims
dim.Result <- dim(Result)[1]
dim.Test <- dim(freqDt.test)[1]
dim.Train <- dim(freqDt.train)[1]

# Create table with results.
df.new = data.frame(nGrams, paste(skipGrams, collapse = ","),
                dim.Train, dim.Test, 
                dim.Result,             
                round(100 - dim.Result/dim.Test *100, digits = 4),
                round(dim.Result/dim.Train *100, digits = 4),
                round(dim.Test/dim.Train *100, digits = 4)
                )
names(df.new) <- df_names

# Add to df.
df <- rbind(df,df.new)

}

kable(df, format = "markdown", caption = "SkipGrams perfomance")

#LongDt <-freqDt.train[,long:=nchar(keyName)][long>4]
# trim(td, sparsity = 0.7)

#freqDt.train[,long:=nchar(keyName)][long>3]
freqDt.train <- freqDt.train[,long:=nchar(keyName)]

# TODO: remove with length (garbage)
# 1grams: letters with 3
# 2grams: >5
# 3grams: 8
# 4grams: no skipgrams, min 15(14)
# 5grams: no skipgrams, incl 24
# 6 - no need

# freqDt.train <- freqDt.train[,long:=NULL]

