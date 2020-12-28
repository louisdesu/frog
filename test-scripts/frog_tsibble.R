library(tidyverse)
library(lubridate)
library(tsibble)

# shimmer datafiles are read-in skipping a line with \tsv encoding, preserving column names
temp <- read_tsv(file.choose(), skip = 1, skip_empty_rows = TRUE, col_names = TRUE)

# all shimmer files will have the 2nd line contain unit information that needs to be dropped
temp <- temp[-1,]

# names are corrected regardless of order
names(temp)[str_detect(names(temp),"Timestamp")] <- "timestamp"
names(temp)[str_detect(names(temp),"Accel_LN_X")] <- "accel_x"
names(temp)[str_detect(names(temp),"Accel_LN_Y")] <- "accel_y"
names(temp)[str_detect(names(temp),"Accel_LN_Z")] <- "accel_z"
names(temp)[str_detect(names(temp),"Range")] <- "range"
names(temp)[str_detect(names(temp),"Conductance")] <- "conduc"
names(temp)[str_detect(names(temp),"Resistance")] <- "resist"
names(temp)[str_detect(names(temp),"Event")] <- "event"

# converts tbl_df to tbl_ts
# requires participant column to have already been created
temp <- temp %>% mutate(participant = "3603_CD1C") %>% 
  mutate(participant = as.factor(participant)) %>%
  mutate(timestamp = lubridate::as_datetime(as.double(.$timestamp)/1000)) %>%
  tsibble::as_tsibble(index = timestamp, key = participant)