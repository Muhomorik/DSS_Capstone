# Create and fill grams DB
# Use nGrams.Min/Max variables.
# Skipgrams vars for each ngrams are defined in GetSkipGramMax()

rm(list=ls())
setwd("~/R Projects/Coursera/10 - DSS Capstone Project")

source("Helpers/filePaths.R")
source("Helpers/ReadAndCleanFile.R")
source("Helpers/MakeTrainTestByMemory.R")
source("Helpers/CreateCustomDfm.R")
source("Helpers/SplitDtByGrams.R")
source("Helpers/StatusTableGrams.R")

source("Helpers/CreateDocFreq.R")
source("Helpers/GetSkipGramMax.R")

source("HelpersSQLite/SQLiteHelpers.R")

# Libraries
library(quanteda)
library(data.table)
library(RSQLite)
library(knitr)
library(stringr)


pth <- file.path("sample", "en_US.blogs.txt")  

linesTwitter.Train <- ReadAndCleanFile(pth)
#linesTwitter.Train <- ReadAndCleanFile("sample/train_en_US.twitter.txt")
#linesTwitter.Train <- ReadAndCleanFile(path_Us_twitter)

# Run parameters
nGrams.Min <- 1
nGrams.Max <- 1

# Filter parameters, everything below or equal to will be dropped from results.
# Index = ngrams number.

# Empty Table columns for printing.
df = StatusTableGramsEmptyDf()

# Open db connection.
con <- SQLiteGetConn("grams_db.sqlite")

# Loop N-Grams
for(ngrams.i in nGrams.Min:nGrams.Max){
  message("Calculating N-Grams: ", ngrams.i)
    
  skipGrams <- 0:GetSkipGramMax(ngrams.i)
  message("Calculating skip-Grams: ", paste( skipGrams, collapse = " "))
    
  # Get docFreq's
  freqDt.train <- CreateDocFreq(linesTwitter.Train, 
                                n_grams = ngrams.i, 
                                skipGrams = skipGrams, 
                                trim=T, verbose = T)
  
  # Write to db.
  db_name <- SQLiteGetTablebyNGrams(ngrams.i)
  SQLiteWriteTable(con, db_name, freqDt.train)    

  # Create info-table.
  dim.Train <- dim(freqDt.train)[1]
  df.new <- StatusTableGramsDfItem(ngrams.i, skipGrams, dim.Train)
  # Add to df.
  df <- rbind(df,df.new)
}

# Close connection.
dbDisconnect(con)

# Print sizes of grams.
kable(df, format = "markdown", caption = "SkipGrams perfomance")
rm(df)

gc()
