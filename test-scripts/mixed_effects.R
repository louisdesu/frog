
# library(nlme)
# sf_rma <- lme(conduc ~ phase_t + resist + accel_xyz + participant + device,
#               random = ~ device|participant,
#               correlation = corAR1(form = ~ phase_t|participant),
#               data = output_clean)
# 
# library(mgcv)
# sf_splines <- gamm(conduc ~ s(phase_t) + resist + accel_xyz + participant + device,
#                    random = ~ device|participant,
#                    data = output_clean)

library(lme4)
sf_lme <- lmer(conduc ~ phase_t + resist + accel_xyz + participant + phase + device +
                 (1 + device | participant) + (1 + phase | participant),
               data = output_clean)

summary(sf_lme3)
coef(summary(sf_lme))
test <- tidy(sf_lme)
View(test)

sf_lme2 <- lmer(conduc ~ phase_t + resist + accel_xyz + (1 | phase) + (1 | device) + 
                  (1 + phase | participant),
                data = output_clean)

sf_lme3 <- lmer(conduc ~ resist + accel_xyz + phase + device + 
                  (1 | phase) + (1 | device) + (1 + phase | participant),
                data = output_clean)
anova(sf_lme,sf_lme2,sf_lme3)

### Splice them together -------------------------------------------------------

sf_lme4 <- lm(conduc ~ phase_t + resist + accel_xyz + participant + phase + device,
              data = output_clean, REML = FALSE)
sf_lme4

library(nlme)
sf_rma <- lme(conduc ~ phase_t + resist + accel_xyz + participant + phase + device,
              data = output_clean)

library(lme4)
sf_lme5 <- lmer(conduc ~ phase_t + resist + accel_xyz + participant + phase + device +
                  (1 | phase) + (1 | participant),
                data = output_clean, REML = FALSE)

sf_lme6 <- lmer(conduc ~ phase_t + resist + accel_xyz + participant + phase + device +
                  (1 + phase | participant),
                data = output_clean, REML = FALSE)

sf_lme7 <- lmer(conduc ~ phase_t + resist + accel_xyz + participant + phase + device +
                  (1 | phase) + (1 + phase | participant),
                data = output_clean, REML = FALSE)

sf_lme8 <- lmer(conduc ~ phase_t + resist + accel_xyz + (1 | phase) + (1 | device) + 
                  (1 + phase + accel_xyz | participant),
                data = output_clean, REML = FALSE)

sf_lme9 <- lmer(conduc ~ phase_t + (1 | phase) + (1 | device) + 
                  (1 + phase + accel_xyz + resist | participant),
                data = output_clean, REML = FALSE)

sf_lme10 <- lmer(conduc ~ phase_t + (1 + participant | phase) + (1 | device) + 
                   (1 + phase + accel_xyz + resist | participant),
                 data = output_clean, REML = FALSE)

sf_lme11 <- lmer(conduc ~ phase_t + (1 + participant | phase) + (1 + participant | device) + 
                   (1 + phase + device + accel_xyz + resist | participant),
                 data = output_clean, REML = FALSE)

model_comp <- anova(sf_lme5,sf_lme6,sf_lme7,sf_lme8,sf_lme9,sf_lme10,sf_lme11)
model_comp

# something to consider is an interaction effect of phase by conduc since we know 
# that conduc will go up over the course of the phases - this implies that phase needs 
# to be encoded as an ordered categorical variable which currently it may not be


### Material from `frog_revised_Rmd` -------------------------------------------------------

# aliasing can occur when sampling at too low a frequency leading to distortion
# Nyquist-Shannon theorem tells us that sampling rate should be double the maximum frequency
# Nyquist rate is the sampling rate required for a frequency not to alias
# Nyquist frequency is the maximum frequency that will not alias given a sampling rate
# we sampled at 5 Hz therefore we have assumed that  resolution of 2.5 Hz is sufficient to capture arousal produced by sympathetic nervous system activity
# EDA is often sampled at 50 Hz [citation needed] however in practise the Shimmer devices only support resolution for EDA at approximately 16 Hz which is why the sampling rate was adjusted up to 15 Hz for T2 onwards
# for the machine learning algorithms, higher resolution will lead to more robust artifact classification and peak detection therefore it is attractive to upsample from 5 and even 15 Hz to approximately 50-60 Hz
# in order to upsample, a continuous model must first be fit to discrete data before resampling at a higher frequency i.e. 2 steps; while to downsample, 2 approaches can be taken firstly to randomly drop the required number of samples per second to reach the target sampling frequency, or to apply the same approach as in upsampling but then resample at a lower frequency (the benefit of the latter being that homogeneity of intervals between samples is preserved)

## Notes

- 396 participants at T1
- [] did the sf task
- 345 px with sf data
- 33 px lost due to data loss at device level (i.e. accelerometers not ticked)
- 119 px lost for mean conductance across phase <10 i.e. 'dead channels'

1. Can we tell the difference between infants who are individually versus dyadically emotionally regulating? [To answer this question from coding data: is mother being sensitive or not]
2. Regardless of how regulation is occurring, is there such regulation?
  3. And, for some infants will it not happen because the mother is not participating in the emotional regulation of infants?
  [sf rationale: we used the sf because there is a clear literature highlighting that some mothers are sensitive and some mothers aren't, some kids are therefore helped to feel less stressed (versus not)]

- in T1 data we have 4m of reunion - we can test whether reunion phase is too short for EDA levels to respond to re-regulation
- when putting the behavioural data with the EDA data (paper 2) we can talk to the comments made eye-tracking with infants [LoBue et al., 2020]

## Things to do this week:

- send Fran notes for the 16th of July CBRC presentation (n.b. major role that I'd like you to play is thinking through the major questions of where to from here particularly in view of the longitudinal dimension -> slide on paper 1 -> clear discussion questions)
- give list of putatively dead channels' px to Sinia to check RA's notes re: electrodes coming off
- send email to Bronte & Sinia to add 'left  foot'/'right foot' Vietnamese, English, Arabic labels to Shimmer devices (from return to testing)
- change timezone to reflect Sydney time in the lubridate call
- make the participant subsetting step independent of the filename length (count from last / in filename string)
- test whether the loop to drop NA cols is working on each individual file rather than being excluded at the frog::select() step
- test whether updated functions work on the full 6m dataset

## Necessary things to do on the project:

1. Figure out how to use the reticulate package to run artifact detection [EDA-Artifact-Detection-Script.py], peak detection [EDA-Peak-Detection-Script.py]
2. Build frequency rate (Hz) functionality into frog()

## Optional things to do for the project:

1. Expand frog() for alternate EDA signal collection methods (for e.g., E4)
2. Build hypothesis testing function

Build another function called legs() that takes a matrix of filenames and the sampling frequency used for by the shimmer device, and then appropriately downsamples to 4Hz.

This function should also be able to be called by frog() in the same way that frog() can apply spawn(). Ideally spawn() and legs() should be able to be called together; perhaps as an option i.e. legs = TRUE, spawn = FALSE

## Check and isolate any dead channels from the dataset

```{r}
# What is the mean conductance for each participant by device by phase?
output %>%
  mutate(phase = fct_relevel(phase,"play","sf","reunion")) %>%
  group_by(participant, device, phase) %>%
  summarise(avg_conduc = mean(conduc)) %>%
  View()

# Which channels have mean conductance <1 units by phase?
output %>%
  mutate(phase = fct_relevel(phase,"play","sf","reunion")) %>%
  group_by(participant, device, phase) %>%
  summarise(avg_conduc = mean(conduc)) %>%
  filter(avg_conduc < 1) %>%
  ungroup() %>%
  distinct(participant,device) %>%
  View()

# What if we exclude participants who's mean conductance across phases is <10?
# Dead channels were removed from the data for those participants with mean conductance across phase <=10 unit value resulting in n=156 unique participants # with one or both channels working
dead_channels <- output %>%
  mutate(phase = fct_relevel(phase,"play","sf","reunion")) %>%
  group_by(participant, device) %>%
  summarise(avg_conduc = mean(conduc)) %>%
  filter(avg_conduc < 10) %>%
  distinct(participant)
# count(participant) %>%
# filter(n<2) %>%
# View()
write.csv(dead_channels,file.path(write_dir,"6m_exclusions.csv"),row.names = FALSE)

# 197 px in total including both and singular i.e. 119 unique px
# 41 px have one channel working
# 156 px have both channels dead
# gives 156 px with either 1 or 2 channels working

# Can we use z-scores to help classifying dead channels? (...Not really)
output %>%
  mutate(phase = fct_relevel(phase,"play","sf","reunion")) %>%
  group_by(participant, device, phase) %>%
  summarise(avg_conduc = mean(conduc)) %>%
  mutate(z_score = (avg_conduc - mean(avg_conduc))/sd(avg_conduc)) %>%
  View()

# How are infants responding by phase after filtering dead channels?
output %>%
  mutate(phase = fct_relevel(phase,"play","sf","reunion")) %>%
  group_by(participant, device, phase) %>%
  summarise(avg_conduc = mean(conduc)) %>%
  filter(avg_conduc > 10) %>%
  ungroup %>%
  group_by(phase) %>%
  summarise(avg_phase = mean(avg_conduc)) %>%
  View()
```

### Create `legs()` which adjusts the sampling rate to 4 Hz


