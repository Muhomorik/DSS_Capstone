# Create and fill grams DB

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
source("Helpers/SplitDtByGrams.R")

source("Helpers/CreateDocFreq.R")
source("Helpers/GetSkipGramMax.R")

source("HelpersSQLite/SQLiteHelpers.R")

linesTwitter.Train <- ReadAndCleanFile("sample/train_en_US.twitter.txt")
#linesTwitter.Train <- ReadAndCleanFile(path_Us_twitter)

# Run parameters
nGrams.Max <- 4

# Filter parameters, everything below or equal to will be dropped from results.
# Index = ngrams number.
filterCnt <- c(0, 3, 5, 8, 15, 24)

# Table columns for printing.
df_names <- c(
  "nGram", "skipGram", "GramsSize")

# Empty df.
df = data.frame(nGrams = numeric(), skipGram = character(), GramsSize = numeric())

# Open db connection.
con <- SQLiteGetConn("grams_db.sqlite")

# Loop N-Grams
for(ngrams.i in 1:nGrams.Max){
  message("Calculating N-Grams: ", ngrams.i)
  
  # Loop skip-Grams                
  #for(skipgrams.i in 0:skipgrams.Max){
    skipGrams <- 0:GetSkipGramMax(ngrams.i)
    
    message("Calculating skip-Grams: ", paste( skipGrams, collapse = " "))
    
    # Get both docFreq's
    freqDt.train <- CreateDocFreq(linesTwitter.Train, 
                                  n_grams = ngrams.i, skipGrams = skipGrams, 
                                  trim=T, verbose = T)
    
    invisible(gc())
    
    # fix different names
    setnames(freqDt.train, c("keyName","valueTrain") )
  
    # Do filtering by char cnt.
    freqDt.train <- freqDt.train[,long:=nchar(keyName)][long>filterCnt[ngrams.i]][,long:=NULL]
    freqDt.train <- SplitDtByGrams(freqDt.train, ngrams.i) # split dt, must go after filter.
    
    # Write to db.
    db_name <- GQLiteGetTablebyNGrams(ngrams.i)
    SQLiteeWriteTable(con, db_name, freqDt.train)

    
    # Create info-table.
    # Dims
    dim.Train <- dim(freqDt.train)[1]
    # Create table with results.
    df.new = data.frame(ngrams.i, paste(skipGrams, collapse = ","),
                        round(dim.Train, digits = 4)
    )
    names(df.new) <- df_names
    # Add to df.
    df <- rbind(df,df.new)
  #}
}

# Close connection.
dbDisconnect(con)

# Print sizes of grams.
kable(df, format = "markdown", caption = "SkipGrams perfomance")
rm(df)
