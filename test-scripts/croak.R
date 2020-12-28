
### Resample to 8 Hz ------------------------------------------------------------

# create invocation map
n <- crossing(
  participant = unique(output_clean$participant),
  device = factor(levels = c("CD1C","CD2B")),
  phase = factor(levels = c("play","sf","reunion"))
) %>%
  mutate_all(as.character) %>%
  rowid_to_column() 

# construct function to perform resampling
croak <- function (data, map, hz_from = NULL, hz_to = NULL, butter = FALSE) {
  
  # initialise vectors for efficiency
  trail <- vector("integer",length(map$rowid))
  result <- map
  result$ts <- vector("list",length(map$rowid))
  result$bw <- vector("list",length(map$rowid))
  
  # conditionally initialise butterworth filter
  if (butter == TRUE) {
    b_filter <- signal::butter(n=1,W=0.2,type="low",plane="z")
    result$bw <- vector("list",length(map$rowid))
  }
  
  # primary loop to subset dataframe and run statistical analysis
  for (i in seq_along(map$rowid)) {
    trail <- map[i,]
    # subset for next steps
    temp <- data %>% 
      select("participant","device","phase","conduc","accel_xyz") %>%
      filter(participant == trail[["participant"]], 
             device == trail[["device"]],
             phase == trail[["phase"]])
    
    # resample waveform
    result$ts[[i]] <- resamp(temp$conduc,f=hz_from,g=hz_to,output="ts")
    
    if (butter == TRUE) {
      result$bw[[i]] <- signal::filter(b_filter,result$ts[[i]])
    }
  }
  return(result)
}

### Test `croak()` on contrived dataset ----------------------------------------

test_df <- dplyr::filter(output_clean, participant == 3115)
test_map <- dplyr::filter(n, participant == 3115)

test_output <- test_map %>%
  mutate(
    mod = croak(test_df,map=.,hz_from=5,hz_to=4,butter=TRUE)
    )

test_output <- croak(test_df,map=test_map,hz_from=5,hz_to=4,butter=TRUE)

glimpse(test_output)
View(test_output)

plot(test_output$mod$ts[[2]], type = "l")
plot(test_output$mod$bw[[2]], type = "l")

### Test `croak()` on the full dataset -----------------------------------------

m <- output_clean %>%
  select(1:2,4) %>%
  distinct() %>%
  mutate_at(vars(-group_cols()),~as.character) %>%
  rowid_to_column()

output_filtered <- croak(data = output_clean, map = m,
                         hz_from = 5, hz_to = 4,
                         butter = TRUE)

glimpse(output_filtered)
