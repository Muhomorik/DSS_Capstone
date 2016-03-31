CreateDocFreq <- function(lines, n_grams, skipGrams=0, verbose = F, trim=F){
  
  dfm.train <- CreateCustomDfm(lines, n_grams = n_grams, skipGrams = skipGrams, F)  
  
  # trim
  if(trim) dfm.train <- trim(dfm.train, minCount = 2, verbose = T)
  
  df.train <- docfreq(dfm.train, scheme = "inversemax", k=1, smoothing = 1)
  
  # Create dt from docfreq.
  freqDt.train <-  as.data.table(df.train, key=names(df.train),  keep.rownames=T) # must keep rownames or 1 col.
  setnames(freqDt.train, c("keyName","value") ) # usefull names to columns.
  
  freqDt.train <- freqDt.train[, keyName := gsub("â€™", "'", keyName)]
  freqDt.train[, keyName := gsub(",", "", keyName)]
  setorder(freqDt.train, value) # order value desc with - (minus), -value.
  rm(df.train)
  
  invisible(freqDt.train)
}
