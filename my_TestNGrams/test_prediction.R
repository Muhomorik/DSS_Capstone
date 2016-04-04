# Prediction test.

rm(list=ls())
setwd("~/R Projects/Coursera/10 - DSS Capstone Project")

# Libraries
library(quanteda)
library(data.table)
library(RSQLite)
library(knitr)

source("Helpers/filePaths.R")
source("Helpers/ReadAndCleanFile.R")
source("Helpers/MakeTrainTestByMemory.R")
source("Helpers/CreateCustomDfm.R")
source("Helpers/CreateDocFreq.R")

source("HelpersSQLite/SQLiteHelpers.R")
source("HelpersSQLite/QueryString.R")
source("HelpersSQLite/StringToQuery.R")

phrase1 <- "The guy in front of me just bought a pound of bacon, a bouquet, and a case of"
phrase2 <- "You're the reason why I smile everyday. Can you follow me please? It would mean the" 
phrase3 <- "Hey sunshine, can you follow me and make me the"
phrase4 <- "Very early observations on the Bills game: Offense still struggling but the"
phrase5 <- "Go on a romantic date at the"
phrase6 <- "Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my"
phrase7 <- "Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some"
phrase8 <- "After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little"
phrase9 <- "Be grateful for the good times and keep the faith during the"
phrase10 <- "If this isn't the cutest thing you've ever seen, then you must be"

k1 <- "please"
k2 <- "let"
k3 <- "us"
k4 <- "know"

library(RSQLite)
con <- SQLiteGetConn("grams_db1.sqlite")

n<-4
keys <- StringToQuery(phrase2, n)
keys

q1 <- QueryStringLevel1(keys[1])
q2 <- QueryStringLevel2(keys[1])
q3 <- QueryStringLevel3(keys[1])
q4 <- QueryStringLevel4(keys[1])

res <- dbGetQuery(con, q1)
kable(res, format = "markdown", caption = "Results")

res <- dbGetQuery(con, q2)
kable(res, format = "markdown", caption = "Results")

res <- dbGetQuery(con, q3)
kable(res, format = "markdown", caption = "Results")

res <- dbGetQuery(con, q4)
kable(res, format = "markdown", caption = "Results")

# Close connection.
dbDisconnect(con)

# checkk stopwords
# "of" %in% stopwords("english")

# - [ ] beer
# - [ ] soda
# - [ ] pretzels
# - [ ] cheese
