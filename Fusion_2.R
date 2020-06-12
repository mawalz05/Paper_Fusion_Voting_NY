#Importing Data from git hub
fusion = read.csv("https://raw.githubusercontent.com/mawalz05/Paper_Fusion_Voting_NY/master/nom_fusion2.csv")


# Code to Produce Main Model regression (Table 5)
regr = lm(dm_nokken_poole_dim1 ~ dm_party + dm_di + 
            dm_ri + dm_dl + dm_rl +dm_dc+ dm_rc+ dm_int_d_ind+ 
            dm_int_r_ind +dm_int_d_lib+ dm_int_r_lib+
            dm_int_d_cons+ dm_int_r_cons+ dm_age+ dm_race+
            dm_gender+ dm_competitive+ dm_uncontested+
            dm_incumbent+ dm_d_prop_pres+ factor(year), data = fusion)
summary(regr)

################################################
#Code to Produce Figure 2
library(ggplot2)
library(dplyr)
library(tidyr)

rep_conserv = fusion %>%
  filter(party_code == 200, rc == 1, year >1960) %>%
  group_by(year) %>%
  summarize(mean(nominate_dim1))

rep_none = fusion %>%
  filter(party_code == 200, rc == 0, year >1960) %>%
  group_by(year) %>%
  summarize(mean(nominate_dim1))

rep_con = rep_conserv %>%
  inner_join(rep_none, by = "year")

rep_con2 = gather(rep_con, type, nom, -year)

ggplot(rep_con2, aes(x = year, y = nom, color = type)) +
  geom_line() + scale_colour_grey() + theme_classic() + ylab("DW-NOMINATE") +
  theme(legend.position = "none") + 
  geom_text(x = 1980, y = 0.285, label = "Conservative Endorsed", color = "black")
##################################################

#Importing data from git hub for Table 6 and Figure 3
fus_minor2 = read.csv('https://raw.githubusercontent.com/mawalz05/Paper_Fusion_Voting_NY/master/fus_minor2.csv')

#Regressions for Table 6
dems = fus_minor2 %>%
  filter(party == 0) %>%
  mutate(lib_endorse_d = ifelse(lib_dem_supp >0, 1, 0))

regr_dem3 = lm(nokken_poole_dim1 ~  
                 rl+ rc+ ri+
                 gender+ race+ age+ competitive +
                 uncontested+ nyc+ incumbent + d_prop_pres + 
                 left_prop*lib_endorse_d +
                 factor(year), data= dems)
summary(regr_dem3)

reps = fus_minor2 %>%
  filter(party == 1, year > 1961) %>%
  mutate(cons_endorse_r = ifelse(cons_rep_supp >0, 1, 0))

regr_rep3 = lm(nokken_poole_dim1 ~  
                 dl+ dc+ di+
                 gender+ race+ age+ competitive +
                 uncontested+ nyc+ incumbent + d_prop_pres + +
                 right_prop*cons_endorse_r +
                 factor(year), data= reps)
summary(regr_rep3)
######################################################

#Code to create Figure 3 Plots
library(sjPlot)
(dem_plot = plot_model(regr_dem3, type = "pred", terms = c("left_prop","lib_endorse_d"),
                       axis.title = c("Proportion Leftist Minor Party Vote", "DW-NOMINATE scores"),
                       legend.title = "Endorsement",
                       colors = "bw",
                       title = "Predictions of Democratic Extremism"))


(rep_plot = plot_model(regr_rep3, type = "pred", terms = c("right_prop","cons_endorse_r"),
                            axis.title = c("Proportion Rightist Minor Party Vote", "DW-NOMINATE scores"),
                            legend.title = "Endorsement",
                            colors = "bw",
                            title = "Predictions of Republican Extremism"))

######################################################
#Need to Manipulate the Data to create hypotheticals
#Figure 4
new_ind = fusion %>%
  filter(year > 1992) %>%
  group_by(year, party_code) %>%
  summarize(mean(nominate_dim1))

new_ind_no = fusion %>%
  filter(year > 1992, ((party_code == 100 & di == 0) | (party_code == 200 & ri ==0))) %>%
  group_by(year, party_code) %>%
  summarize(mean(nominate_dim1))

test = new_ind %>%
  inner_join(new_ind_no, by = c("year", "party_code"))

colnames(test)[colnames(test)=="mean(nominate_dim1).x"] = "ind"
colnames(test)[colnames(test)=="mean(nominate_dim1).y"] = "no_ind"

test2 = test %>%
  filter(party_code == 100) %>%
  select(year, ind, no_ind)
colnames(test2)[colnames(test2)=="ind"] = "ind_dem"
colnames(test2)[colnames(test2)=="no_ind"] = "no_ind_dem"

test3 = test %>%
  filter(party_code == 200) %>%
  select(year, ind, no_ind)
colnames(test3)[colnames(test3)=="ind"] = "ind_rep"
colnames(test3)[colnames(test3)=="no_ind"] = "no_ind_rep"

test4 = test2 %>%
  inner_join(test3, by = "year") %>%
  mutate(div_no_ind = no_ind_rep - no_ind_dem) %>%
  mutate(div_ind = ind_rep - ind_dem)

ggplot(test4, aes(x = year, y = div_ind)) + geom_smooth(se = FALSE, color = "black") +
  geom_smooth(aes(x = year, y = div_no_ind), se = FALSE, color = "gray") + scale_colour_grey() + theme_classic() +
  geom_text(x = 2005, y = 0.66, label = "Full Sample", color = "black") +
  ylab("Divergence") + xlim(1995,2015) + geom_text(x = 2000, y = .8, label = "No Independence Party")
