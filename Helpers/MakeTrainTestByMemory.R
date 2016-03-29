source("Helpers/filePaths.R")

MakeTrainTestByMemory <- function(inFile, 
                                  outFileTrain, outFileTest, 
                                  testSize = 0.2, objSize = 7224696, force = FALSE ){
  # Runs the 'memory-sample' function and creates a small sample of data if needed.
  # Takes following lines by memory as Train set.
  # Takes next testSize% of size as Test set.  
  # Skips sample if file exists (checks if folder exists).
  #
  # Args:
  #   inFile: original file to process.  
  #   outFileTrain: file to use for train process. 
  #   outFileTest: file to use for test process. 
  #   objSize: object size limit (appr).   
  #   force: overwrites file if true.
  
  if(testSize > 0.4) warning("Test file size is set bigger than 40% of original.")
  
  if (!dir.exists(samle.dir) || (force == TRUE)){
    message("Processing samples files into the: ", dirname(outFileTrain))
    
    currMemSize <- 0
    myBigObj <- "" # store temp file here.
    nlines <- 20 # number of lines to read at once (or very slow)
    
    # Read data
    con.read  <- file(inFile, open = "r")  
    
    # Read into a big array and check the size.
    # Read TRAIN data.
    while(currMemSize <= objSize){
      oneLine <- readLines(con.read,  warn = FALSE, encoding = "UTF-8", n = nlines)    
      myBigObj <- append(myBigObj, oneLine)
      
      currMemSize <- as.numeric(object.size(myBigObj))
    }
    
    # Write to TRAIN file.
    con.train <- file(outFileTrain, "w", encoding = "UTF-8")
    writeLines(myBigObj, con.train)
    close(con.train)

    # Read into a big array and check the size.
    # Read TEST data.
    
    currMemSize <- 0
    myBigObj <- "" # store temp file here.
    objSize.test <- objSize * testSize
    
    while(currMemSize <= objSize.test){
      oneLine <- readLines(con.read,  warn = FALSE, encoding = "UTF-8", n = nlines)    
      myBigObj <- append(myBigObj, oneLine)
      
      currMemSize <- as.numeric(object.size(myBigObj))
    }
    
    # Write to TRAIN file.
    con.test <- file(outFileTest, "w", encoding = "UTF-8")
    writeLines(myBigObj, con.test)
    close(con.test)
    
    close(con.read)
    
  } else {
    message("Processed samples files are in: ", paste0(getwd(), "/", samle.dir))
  }
}

# Examle:

# out.path_Us_twitter_train <- file.path(samle.dir, paste0("train_", basename(path_Us_twitter)))
# out.path_Us_twitter_test <- file.path(samle.dir, paste0("test_", basename(path_Us_twitter)))
# 
# MakeTrainTestByMemory(path_Us_twitter, 
#   out.path_Us_twitter_train, out.path_Us_twitter_test, 
#   force = T)
