source("Helpers/filePaths.R")

DownloadFile <- function(force = FALSE){
  # Download file function. Uri must have a proper ending (like .csv).
  # Skips download if file exists (checks if folder exists).
  #
  # Args:
  #   force: overwrites file if true.

  fileUrl <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
  
  if (!dir.exists(path) || (force == TRUE)){
    message("Data is missing, downloading into: ", getwd())
    
    # Donload.
    download.file(fileUrl, fileName, method = "auto") # Don't use curl on Windows.
    unzip ("Coursera-SwiftKey.zip", exdir = "Coursera-SwiftKey")
  } else {
    message("File exists in: ", getwd())
  }
}
