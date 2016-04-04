# Write to SQLite
# https://github.com/rstats-db/RSQLite
# https://github.com/ysquared2/RSQLiteTutorial

# layout
library(RSQLite)

# LIKE: http://www.tutorialspoint.com/sqlite/sqlite_like_clause.htm
con <- dbConnect(RSQLite::SQLite(), ":memory:")

con <- dbConnect(RSQLite::SQLite(), dbname="grams_3.sqlite")

dbListTables(con)
dbWriteTable(con, "matDT", matDT)
dbListTables(con)

dbListFields(con, "matDT")

res <- dbSendQuery(con, "SELECT * FROM matDT WHERE keyName like 'happy_new_%'")
dbFetch(res)
dbClearResult(res)

# SELECT * FROM T WHERE FOO LIKE 'a\_b_c\%de%' ESCAPE '\'

dbClearResult(res)
# Disconnect from the database
dbDisconnect(con)
