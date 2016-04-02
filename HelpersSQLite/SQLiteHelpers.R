library(RSQLite)

# SQLite helpers.

# Table names.

SQLtable.Grams1 <- "grams1"
SQLtable.Grams2 <- "grams2"
SQLtable.Grams3 <- "grams3"
SQLtable.Grams4 <- "grams4"
SQLtable.Grams5 <- "grams5"

SQLtable <-c("grams1", "grams2", "grams3", "grams4", "grams5")

SQLiteGetTablebyNGrams <- function(nGrams){
  # Get table name for current NGrams number.
  #
  # Args:
  #   nGrams: NGrams.
  
  SQLtable[nGrams]
}

SQLiteGetConn <- function(filePath){
  # Get connection to db.
  #
  # Args:
  #   filePath: path to db.
  
  dbConnect(RSQLite::SQLite(), dbname = filePath)
}


SQLiteWriteTable <- function(con, tableName, dt){
  # Drops the table and cteated new with values from dt.
  #
  # Args:
  #   con: connection to db.
  #   tableName: table to write to.
  #   dt: data.table to write.
  
  # remove if exists
  tables <- dbListTables(con)
  if(tableName %in% tables) dbRemoveTable(con, tableName)
  
  dbWriteTable(con, tableName, dt)
  
  # Create index for faster search. Increases size a bit!.
#   dbSendQuery(conn = con,
#               "CREATE INDEX byKeyValue ON grams1 (
#     keyName COLLATE NOCASE ASC)")
  
  #dbClearResult(res)
}
