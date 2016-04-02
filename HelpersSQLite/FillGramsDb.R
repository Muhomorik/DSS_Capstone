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
suppressMessages(suppressWarnings(library(quanteda)))
suppressMessages(suppressWarnings(library(data.table)))
suppressMessages(suppressWarnings(library(RSQLite)))
suppressMessages(suppressWarnings(library(knitr)))
suppressMessages(suppressWarnings(library(stringr)))
suppressMessages(suppressWarnings(library(beepr))) # beep!

# Memory profiler: uncomment end of file.
# Rprof(tf <- "rprof.log", memory.profiling=TRUE)

#pth <- file.path("sample", "en_US.blogs.txt")  

#linesTwitter.Train <- ReadAndCleanFile(pth)
#linesTwitter.Train <- ReadAndCleanFile("sample/train_en_US.twitter.txt")
#linesTwitter.Train <- ReadAndCleanFile(path_Us_twitter)

# Run parameters
nGrams.Min <- 1
nGrams.Max <- 1

# Default, replaced later.
linesInFIle <- -1
linesMax.Twiter <- 2360148

#             1  2   3  4  5
scaling <-  c(1, 4, 14, 3, 3) # 1gram, 2 gram, etc

# Filter parameters, everything below or equal to will be dropped from results.
# Index = ngrams number.

# Empty Table columns for printing.
df = StatusTableGramsEmptyDf()

# Open db connection.
con <- SQLiteGetConn("grams_db1.sqlite")

# Loop N-Grams
for(ngrams.i in nGrams.Min:nGrams.Max){
  # ngrams.i <- 1
  
  if(linesInFIle != -1){
    linesToRead <- ceiling(as.numeric(linesInFIle)/scaling[ngrams.i])  
  } else {
    linesToRead <- ceiling(linesMax.Twiter/scaling[ngrams.i])
  } 
  
  linesTwitter.Train <- ReadAndCleanFile(path_Us_twitter, nlines = linesToRead)
  
  if(linesInFIle == -1) linesInFIle <- length(linesTwitter.Train)
  cat("Calculating N-Grams: ", ngrams.i, 
          ". Reading lines: ", format(linesToRead, big.mark = ","),
          " Obj.size: ", format(object.size(linesTwitter.Train), units="Mb"), "\n")
    
  skipGrams <- 0:GetSkipGramMax(ngrams.i)
  cat("Calculating skip-Grams: ", paste( skipGrams, collapse = " "), "\n")
    
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
  
  rm(linesTwitter.Train, freqDt.train )
  invisible(gc())
}

# write status to db.
SQLiteWriteTableStatus(con, df) 

# Close connection (skip TRUE).
invisible(dbDisconnect(con))

# Print sizes of grams.
kable(df, format = "markdown", caption = "SkipGrams perfomance")
rm(df)

# Rprof(NULL)
# summaryRprof(tf)
gc()
beep(6)
