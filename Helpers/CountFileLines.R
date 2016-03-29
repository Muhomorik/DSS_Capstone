CountFileLines <- function(file) {
  # Loop lines in file and get the lines number (there is a better way with utols).
  #
  # Args:
  #   file: file to read.
  
  #   print.file <- paste("File:", file, sep=" ")
  #   message(print.file)
  
#   print.file <- paste("File:", file, sep=" ")
#   message(print.file)
  
  len <- 1
  cnt <- 0
  
  con  <- file(file, open = "r")
  
  # start.time <- Sys.time()  
  
  while (len > 0) {
    oneLine <- readLines(con, n = 1, warn = FALSE)
    len <- length(oneLine)
    cnt <- cnt+1
  }
  close(con)
  
#   end.time <- Sys.time()
#   time.taken <- end.time - start.time
#   time.taken
#   
#   print.res <- paste("Chars max:", charMaxCnt, ", Lines:", cnt, sep=" ")
#   message(print.res)

  cnt
}
