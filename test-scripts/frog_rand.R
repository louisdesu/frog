rand <- function (df) {
  # randomise df by row
  df$rnd <- sample(c(0,1), size = nrow(df), replace = TRUE)
  df$dup <- duplicated(df[,c(1,3)])
  
  while (any(df$dup) == TRUE) {
    for (i in seq_along(df$dup)) {
      if (df$dup[i] == TRUE) {
        df$rnd[i] <- sample(c(0,1), size = 1, replace = TRUE)
        df$dup <- duplicated(df[,c(1,3)])
      }
    }
  }
}

test <- rand(df)