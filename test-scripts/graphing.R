library(ggpubr)
library(grid)
library(egg)

# subset for testing
nlme_test <- nlme_visu %>% filter(str_detect(participant,"3115|3158|3184|3254"))
# unique(nlme_test$participant)

# loop over each participant to produce plots
for (i in seq_along(unique(nlme_test$participant))) {
  
  temp_px <- unique(nlme_test$participant)[i]
  temp_df <- nlme_test %>% filter(participant == temp_px)
  
  # have to set these separately because geom_abline() doesn't inherit from df
  pl_in <- temp_df %>% filter(phase == "play") %>% pull(ranef) %>% first()
  pl_sl <- temp_df %>% filter(phase == "play") %>% pull(slope) %>% first()
  sf_in <- temp_df %>% filter(phase == "sf") %>% pull(ranef) %>% first()
  sf_sl <- temp_df %>% filter(phase == "sf") %>% pull(slope) %>% first()
  re_in <- temp_df %>% filter(phase == "reunion") %>% pull(ranef) %>% first()
  re_sl <- temp_df %>% filter(phase == "reunion") %>% pull(slope) %>% first()
  
  play_temp <- temp_df %>%
    filter(phase=="play") %>%
    ungroup() %>%
    group_by(participant,device) %>%
    mutate(samples_n=phase_t) %>%
    ggplot(aes(x=samples_n,y=conduc,group=participant)) + 
    theme_bw() + theme(strip.background=element_blank(),strip.text.y=element_blank()) +
    facet_grid(device ~ .,scales = "free_x") +
    geom_line(alpha=.8,size=.2) +
    coord_cartesian(ylim=c(0,80)) +
    scale_x_continuous(expand=c(0,0)) +
    scale_y_continuous(expand=c(0,0)) +
    geom_abline(intercept=nlme_fixed_play_intercept,slope=nlme_fixed_play_slope,colour="red",size=.3,alpha=.5) +
    geom_abline(intercept=pl_in,slope=pl_sl,colour="blue",size=.3,alpha=.5) +
    labs(x="Free play",y=expression(paste("Skin conductance (",italic("μS"),")")))
  
  sf_temp <- temp_df %>%
    filter(phase=="sf") %>%
    ungroup() %>%
    group_by(participant,device) %>%
    mutate(samples_n=phase_t) %>%
    ggplot(aes(x=samples_n,y=conduc,group=participant)) + 
    theme_bw() + theme(strip.background=element_blank(),strip.text.y=element_blank()) +
    facet_grid(device ~ .,scales = "free_x") +
    geom_line(alpha=.8,size=.2,inherit.aes=TRUE) +
    coord_cartesian(ylim=c(0,80)) +
    scale_x_continuous(expand=c(0,0)) +
    scale_y_continuous(expand=c(0,0)) +
    geom_abline(intercept=nlme_fixed_sf_intercept,slope=nlme_fixed_sf_slope,colour="red",size=.3,alpha=.5) +
    geom_abline(intercept=sf_in,slope=sf_sl,colour="blue",size=.3,alpha=.5) +
    labs(x="Still-face")
  
  reunion_temp <- temp_df %>%
    filter(phase=="reunion") %>%
    ungroup() %>%
    group_by(participant,device) %>%
    mutate(samples_n=phase_t) %>%
    ggplot(aes(x=samples_n,y=conduc,group=participant)) + 
    theme_bw() + theme(strip.background=element_rect(colour="black",fill="white")) + 
    facet_grid(device ~ .,scales = "free_x") +
    geom_line(alpha=.8,size=.2,inherit.aes=TRUE) +
    coord_cartesian(ylim=c(0,80)) + # xlim=c(0,2)
    scale_x_continuous(expand=c(0,0)) +
    scale_y_continuous(expand=c(0,0)) +
    geom_abline(intercept=nlme_fixed_reunion_intercept,slope=nlme_fixed_reunion_slope,colour="red",size=.3,alpha=.5) +
    geom_abline(intercept=re_in,slope=re_sl,colour="blue",size=.3,alpha=.5) +
    labs(x="Reunion")
  
  temp_pl <- ggarrange(
    play_temp,
    sf_temp,# +
    # theme(axis.text.y = element_blank(),
    #       axis.ticks.y = element_blank(),
    #       axis.title.y = element_blank()),
    reunion_temp,# +
    # theme(axis.text.y = element_blank(),
    #       axis.ticks.y = element_blank(),
    #       axis.title.y = element_blank()),
    widths = c(4,1.5,2),
    nrow = 1) %>%
    annotate_figure(.,
                    bottom = textGrob(
                      "CBRC: Louis Klein, 12-11-20",
                      gp = gpar(fontface = 3, fontsize = 9),
                      hjust = 1.07, x = 1
                    )
    )
  
  ggsave(filename=paste0(temp_px,"_ranef_test.png"))
}