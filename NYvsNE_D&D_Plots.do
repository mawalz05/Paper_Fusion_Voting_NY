cd "C:\Users\mawal\OneDrive - Binghamton University\Desktop\My Papers\Papers\Fusion\Data"
use Northeast_noCTVT /* csv file saved in git hub repository */



*Descriptive statistics for Table 2******************
su divergence if ny == 1 & congress > 57
su divergence if ny == 0 & congress > 57
su divergence if ny == 1 & congress < 58
su divergence if ny == 0 & congress < 58

su nom_dem if ny == 1 & congress > 57
su nom_dem if ny == 0 & congress > 57
su nom_dem if ny == 1 & congress < 58
su nom_dem if ny == 0 & congress < 58

su nom_rep if ny == 1 & congress > 57
su nom_rep if ny == 0 & congress > 57
su nom_rep if ny == 1 & congress < 58
su nom_rep if ny == 0 & congress < 58
*****************************************************

*********************************************************
*Difference-in-Differences Regressions for Table 3
reg divergence post_1892 ny ny_post1892
reg divergence post_1900 ny ny_post1900
reg divergence post_1910 ny ny_post1910
reg divergence post_1920 ny ny_post1920
reg divergence post_1930 ny ny_post1930
**********************************************************


*********************************************************
*******Creating Figure 1*****************
*Plot comparing divergence in NY and Other NE regions with all congresses
set scheme s1mono
#delimit;
tw (line divergence year if ny == 1, lcolor(gs2))
(line divergence year if ny == 0, lcolor(gs10))
(scatteri .3 1850 "19th century", mlabcolor(black) mcolor(white))
(scatteri .3 1910 "20th century", mlabcolor(black) mcolor(white)),
xline(1892, lpattern(dash))
xline(1941, lpattern(dash))
legend(order(1 "NY" 2 "NE Region"))
xtitle("Congress Number")
ytitle("Divergence")
name("A1")
;


*Plot comparing Nomindates scores in NY and Other NE regions with all congresses
#delimit;
tw (line nom_dem year if ny == 1, lcolor(gs2) lpattern(dash))
(line nom_rep year if ny == 1, lcolor(gs2))
(line nom_dem year if ny == 0, lcolor(gs10) lpattern(dash))
(line nom_rep year if ny == 0, lcolor(gs10))
(scatteri 0 1850 "19th century", mlabcolor(black) mcolor(white))
(scatteri 0 1910 "20th century", mlabcolor(black) mcolor(white)),
xline(1900, lpattern(dash))
legend(order(1 "NY Dems" 2 "NY Reps" 3 "NE Dems" 4 "NE Reps"))
xtitle("Congress Number")
ytitle("Nominate Scores")
name("A2")
;

*Combining both Plots into one.
graph combine A1 A2
*****************************************************
