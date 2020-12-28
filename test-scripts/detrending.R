
play <- output_clean %>%
  filter(participant == "3201", device == "CD1C", phase == "play")
sf <- output_clean %>%
  filter(participant == "3201", device == "CD1C", phase == "sf")
reunion <- output_clean %>%
  filter(participant == "3201", device == "CD1C", phase == "reunion")

# this function is not possible to use for trend because periodicity is <2
decomposedRes <- decompose(test2, type="additive") # use type = "additive" for additive components
plot(decomposedRes)

### Merge into final dataset ---------------------------------------------------

# alternative method to detrend
play_detrended <- lm(conduc ~ c(1:length(play$conduc)) + resist + accel_xyz, data = play)
plot(resid(play_detrended), type="l")

library(broom)
play_detrended %>%
  augment() %>%
  transmute(
    x_axis = `c(1:length(play$conduc))`,
    y_axis = .resid
  ) %>%
  as.data.frame() %>%
  ggplot(aes(x = x_axis, y = y_axis)) +
  geom_line(colour = "#00AFBB", size = 1) +
  stat_smooth(colour = "#E7B800", fill = "#E7B800", method = "loess") +
  theme_minimal()

sf_detrended <- lm(conduc ~ c(1:length(sf$conduc)) + resist + accel_xyz, data = sf)
plot(resid(sf_detrended), type="l")

sf_detrended %>%
  augment() %>%
  transmute(
    x_axis = `c(1:length(sf$conduc))`,
    y_axis = .resid
  ) %>%
  as.data.frame() %>%
  ggplot(aes(x = x_axis, y = y_axis)) +
  geom_line(colour = "#00AFBB", size = 1) +
  stat_smooth(colour = "#E7B800", fill = "#E7B800", method = "loess") +
  theme_minimal()

reunion_detrended <- lm(conduc ~ c(1:length(reunion$conduc)) + resist + accel_xyz, data = reunion)
plot(resid(reunion_detrended), type="l")

reunion_detrended %>%
  augment() %>%
  transmute(
    x_axis = `c(1:length(reunion$conduc))`,
    y_axis = .resid
  ) %>%
  as.data.frame() %>%
  ggplot(aes(x = x_axis, y = y_axis)) +
  geom_line(colour = "#00AFBB", size = 1) +
  stat_smooth(colour = "#E7B800", fill = "#E7B800", method = "loess") +
  theme_minimal()


### Resampling engine ----------------------------------------------------------

library(seewave)

play_8hz <- resamp(play$conduc, f = 5, g = 8, output = "ts")
plot(play_8hz, type = "l")
plot(play$conduc, type = "l")

### High pass Butterworth filter -----------------------------------------------

library(signal)

bf <- butter(n = 1, W = 0.2, type = "low", plane = "z") 
y_filtered_b <- filter(bf, play$conduc)

plot(y_filtered, type="l")






