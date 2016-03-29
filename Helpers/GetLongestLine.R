GetLongestLine <- function(file) {
  # Loop lines in file and get char count for the longest line.
  #
  # Args:
  #   file: file to read.
  
#   print.file <- paste("File:", file, sep=" ")
#   message(print.file)
  
  charMaxCnt <- 0
  len <- 1
  cnt <- 0
  
  # start.time <- Sys.time()    

  con  <- file(file, open = "r")
  while (len > 0) {
    oneLine <- readLines(con, n = 1, warn = FALSE)
    len <- length(oneLine)
    
    chars <- max(0, nchar(oneLine))
    charMaxCnt <- max(charMaxCnt, chars)
    
    cnt <- cnt+1
  }
  
  close(con) 
  
#   end.time <- Sys.time()
#   time.taken <- end.time - start.time
#   time.taken
#   
#   print.res <- paste("Chars max:", charMaxCnt, ", Lines:", cnt, sep=" ")
#   message(print.res)
  
  charMaxCnt
}
