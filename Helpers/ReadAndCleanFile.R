ReadAndCleanFile <- function(textFile,  nlines = -1L){
  # Rean a small samle of the data (n-lines). Removes common garbage.
  #
  # Args:
  #   textFile: Filepath to file.
  #   nlines: number of lines to read.
  #
  # Returns:
  #   Vector of lines, divided by new-line charachter.
  
  # Read data
  con  <- file(textFile, open = "r")
  oneLine <- readLines(con, encoding = "UTF-8", n = nlines, warn = TRUE, skipNul = TRUE)
  close(con)
  
  # Escape unifode madness like: <f0><U+009F><U+0098><U+0096><f0><U+009F><U+0098>
  oneLine <- gsub("<(U\\+([[:alnum:]]{4}))>", " ", oneLine, ignore.case = T)
  oneLine <- gsub("â€™", "’", oneLine, ignore.case = T)
  oneLine <- gsub("\\_", "", oneLine, ignore.case = T) # this is bug, won't create right ngrams.
  
  invisible(oneLine)
}
