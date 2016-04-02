# Helpers to create a small file from a large file by reading it from the beginning.
# 1. Sample by N-lines.
# 2. Sample by momory limit.
# 3. Sample function to run sample if needed.


TakeByRownN <- function(inFile, outFile,  nlines = 25000){
  # Reads N-first lines from textFile and saves them into a new file.
  #
  # Args:
  #   inFile: file to read.
  #   outFile: output file.
  
  # Read data
  con  <- file(inFile, open = "r")
  oneLine <- readLines(con,  warn = FALSE, encoding = "UTF-8", n = nlines)
  close(con)
  
  # Write to another file.
  wcon <- file(outFile, "w", encoding = "UTF-8")
  writeLines(oneLine, wcon)
  close(wcon)
}

TakeByObjectSize <- function(inFile, outFile, objSize = 7224696){
  # Reads N-first lines from textFile and saves them into a new file.
  # Make a small sample of data, stop when the object size is reached.
  # Size is very approximate and slow. Because it rads file two times.
  #
  # Args:
  #   inFile: file to read.
  #   outFile: output file.
  #   objSize: object size limit (appr).
  
  currSize <- 0
  myBigObj <- ""
  lines <- 0
  nlines <- 20 # number of lines to read at once (or very slow)
  
  # Read data
  con  <- file(inFile, open = "r")  
  
  # Read into a big array and check the size.
  # Count lines read.
  while(currSize <= objSize){
    oneLine <- readLines(con,  warn = FALSE, encoding = "UTF-8", n = nlines)    
    myBigObj <- append(myBigObj, oneLine)
    
    currSize <- as.numeric(object.size(myBigObj))
    lines <- lines + nlines
  }
  close(con)
  
  #Remove temp vars.
  rm(myBigObj, oneLine)  

  # Re-read file, counted row number.
  con  <- file(inFile, open = "r")  
  oneLine <- readLines(con,  warn = FALSE, encoding = "UTF-8", n = lines)  
  close(con)
  
  # Write to another file.
  wcon <- file(outFile, "w", encoding = "UTF-8")
  writeLines(oneLine, wcon)
  close(wcon)
}

MakeSampleByMemory <- function(objSize = 7224696, force = FALSE ){
  # Runs the 'memory-sample' function and creates a small sample of data if needed.
  # Skips sample if file exists (checks if folder exists).
  # Uses paths from filePaths.R.
  #
  # Args:
  #   objSize: object size limit (appr).   
  #   force: overwrites file if true.

  if (!dir.exists(samle.dir) || (force == TRUE)){
    message("Processing samples files into the: ", paste0(getwd(), "/", samle.dir))
    
    dir.create(samle.dir)
    TakeByObjectSize(path_Us_blogs, sample_Us_blogs, objSize)
    TakeByObjectSize(path_Us_news, sample_Us_news, objSize)
    TakeByObjectSize(path_Us_twitter, sample_Us_twitter, objSize)
    
  } else {
    message("Processed samples files are in: ", paste0(getwd(), "/", samle.dir))
  }
}


# Examples:
# MakeSampleByMemory()

#TakeByRownN(path_Us_blogs, out.path_Us_blogs)
#TakeByRownN(path_Us_news, out.path_Us_news)
#TakeByRownN(path_Us_twitter, out.path_Us_twitter)

# TakeByObjectSize(path_Us_blogs, out.path_Us_blogs)
# TakeByObjectSize(path_Us_news, out.path_Us_news)
# TakeByObjectSize(path_Us_twitter, out.path_Us_twitter)
