

CreateDocFreq <- function(lines, n_grams, skipGrams=0, verbose = F, trim=F){
  
  dfm.train <- CreateCustomDfm(lines, n_grams = n_grams, skipGrams = skipGrams, F)  
  
  # trim
  if(trim) dfm.train <- trim(dfm.train, minCount = 2, verbose = verbose)
  
  df.train <- docfreq(dfm.train, scheme = "inversemax", k = 1, smoothing = 1)
  
  # Create dt from docfreq.
  freqDt.train <-  as.data.table(df.train, key=names(df.train),  keep.rownames=T) # must keep rownames or 1 col.
  # usefull names to columns.
  setnames(freqDt.train, c("keyName","value") ) 
  
  freqDt.train <- freqDt.train[, keyName := gsub("â€™", "'", keyName)]
  freqDt.train[, keyName := gsub(",", "", keyName)]
  setorder(freqDt.train, value) # order value desc with - (minus), -value.
  
  # Filter by char count (very short are garbage)
  filterCnt <- c(0, 3, 5, 8, 15, 24)  

  # Do filtering by char cnt.
  freqDt.train <- freqDt.train[,long:=nchar(keyName)][long>filterCnt[n_grams]][,long:=NULL]
  freqDt.train <- SplitDtByGrams(freqDt.train, n_grams) # split dt, must go after filter.
  
  rm(df.train)
  invisible(freqDt.train)
}

# Examples:

# linesTwitter.Train <- ReadAndCleanFile(path_Us_twitter, nlines = linesToRead)
# freqDt.train <- CreateDocFreq(linesTwitter.Train, 
#                               n_grams = 1, 
#                               skipGrams = 0, 
#                               trim=T, verbose = T)
