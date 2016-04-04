# Create and fill grams DB
# Use nGrams.Min/Max variables.
# Skipgrams vars for each ngrams are defined in GetSkipGramMax()

rm(list=ls())
setwd("~/R Projects/Coursera/10 - DSS Capstone Project")
start.time <- Sys.time()

source("Helpers/filePaths.R")
source("Helpers/ReadAndCleanFile.R")
source("Helpers/MakeTrainTestByMemory.R")
source("Helpers/CreateCustomDfm.R")
source("Helpers/SplitDtByGrams.R")
source("Helpers/StatusTableGrams.R")

source("Helpers/CreateDocFreq.R")
source("Helpers/GetSkipGramMax.R")

source("HelpersSQLite/SQLiteHelpers.R")

# Libraries (tricky messages...)
suppressWarnings(library(quanteda, quietly = T, warn.conflicts = F))
suppressMessages( suppressWarnings(library(data.table, quietly = T, warn.conflicts = F)))
suppressMessages(suppressWarnings(library(RSQLite, quietly = T, warn.conflicts = F, verbose = FALSE)))
suppressWarnings(library(knitr, quietly = T, warn.conflicts = F))
suppressWarnings(library(stringr, quietly = T, warn.conflicts = F))
suppressWarnings(library(beepr, quietly = T, warn.conflicts = F)) # beep!

# Memory profiler: uncomment end of file.
# Rprof(tf <- "rprof.log", memory.profiling=TRUE)

#pth <- file.path("sample", "en_US.blogs.txt")  

#linesTwitter.Train <- ReadAndCleanFile(pth)
#linesTwitter.Train <- ReadAndCleanFile("sample/train_en_US.twitter.txt")
#linesTwitter.Train <- ReadAndCleanFile(path_Us_twitter)

# Command line args
args <- commandArgs(trailingOnly = TRUE)

if(length(args) != 0) {
  # Run parameters, from cmd.
  cat("Arguments from cmd\n")
  nGrams.Min <- as.numeric(args[1])
  nGrams.Max <- as.numeric(args[2])  
} else {
  # Run parameters, from script (here)
  nGrams.Min <- 1
  nGrams.Max <- 4  
}

# Starting headers
cat("Ngrams, min: ", nGrams.Min, " max: ", nGrams.Max, "\n")

# Default, replaced later.
linesInFIle <- -1
linesMax.Twiter <- 2360148

#             1  2   3  4  5
scaling <-  c(1, 4, 14, 3, 3) # w/o stopwords, 1gram, 2 gram, etc

#                      1  2   3  4  5
scaling.stopword <-  c(5, 5, 5, 5, 5) # 1gram, 2 gram, etc

# Filter parameters, everything below or equal to will be dropped from results.
# Index = ngrams number.

# Empty Table columns for printing.
df = StatusTableGramsEmptyDf()

db_file <- "grams_db1.sqlite"
# Open db connection.
con <- SQLiteGetConn(db_file)

# Loop N-Grams
for(ngrams.i in nGrams.Min:nGrams.Max){
  # ngrams.i <- 1
  
  if(linesInFIle != -1){
    linesToRead <- ceiling(as.numeric(linesInFIle)/scaling.stopword[ngrams.i])  
  } else {
    linesToRead <- ceiling(linesMax.Twiter/scaling.stopword[ngrams.i])
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
  
  # Write to db (don't let it be open for too long).
  con <- SQLiteGetConn(db_file)
  
  db_name <- SQLiteGetTablebyNGrams(ngrams.i)
  SQLiteWriteTable(con, db_name, freqDt.train)    
  
  # Close connection (skip TRUE).
  invisible(dbDisconnect(con))
  
  # Create info-table.
  dim.Train <- dim(freqDt.train)[1]
  df.new <- StatusTableGramsDfItem(ngrams.i, skipGrams, dim.Train, scaling.stopword[ngrams.i])
  # Add to df.
  df <- rbind(df,df.new)
  
  rm(linesTwitter.Train, freqDt.train )
  invisible(gc())
}

# Open db connection.
con <- SQLiteGetConn(db_file)
# write status to db.
SQLiteWriteTableStatus(con, df) 
# Close connection (skip TRUE).
invisible(dbDisconnect(con))

# Print sizes of grams.
kable(df, format = "markdown", caption = "SkipGrams perfomance")
rm(df)

# Rprof(NULL)
# summaryRprof(tf)
end.time <- Sys.time()
time.taken <- end.time - start.time
cat("Done in: ", time.taken, "\n")

gc()
beep(6)
