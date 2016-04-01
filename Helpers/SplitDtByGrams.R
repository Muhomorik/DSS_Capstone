SplitDtByGrams <- function(dt, nGrams){
  # Splits data_table column to sub-columns by '_'.
  #
  # Args:
  #   dt: daa.table to change.
  #   nGrams: NGrams for slitting.  

  if ( nGrams == 1) {
    dt
  } else if ( nGrams == 2) {
    dt[,c("key1", "key2") := tstrsplit(keyName, "_", fixed=TRUE)][,keyName:=NULL]
  } else if ( nGrams == 3) {
    dt[,c("key1", "key2", "key3") := tstrsplit(keyName, "_", fixed=TRUE)][,keyName:=NULL]
  } else if ( nGrams == 4) {
    dt[,c("key1", "key2", "key3", "key4") := tstrsplit(keyName, "_", fixed=TRUE)][,keyName:=NULL]
  } else if ( nGrams == 5) {
    dt[,c("key1", "key2", "key3", "key4", "key5") := tstrsplit(keyName, "_", fixed=TRUE)][,keyName:=NULL]
  } else if ( nGrams == 6) {
    dt[,c("key1", "key2", "key3", "key4", "key5", "key6") := tstrsplit(keyName, "_", fixed=TRUE)][,keyName:=NULL]
  } else
    error("Unknown NGrams, ignoring.")
    dt
}
