***************************************************************************************
* Quantitative Methods Module (4SSPP109), AY 2023-24.                                 *
* This STATA do file produces some of the tables and graphs in the slides for Week 1  *
***************************************************************************************

clear*
version 15

* set working directory (note: you need to change this to indicate the place where you have stored the dataset files in your computer!)
cd "~/Library/CloudStorage/OneDrive-King'sCollegeLondon/KCL/Modules/4SSPP109_2024/4SSPP109_Week1_Introduction/"

* Import British Election Study 2019 dataset (source: British Election Study)
use bes_rps_2019_1.1.1.dta
* display a subset of the data
browse finalserialno b01 b02 b05
* frequency table
tabulate b05, missing
* pie chart
graph pie, over(b05) ///
		   plabel(_all sum, size(*1.5) color(white))  ///
		   legend(on position(6)) ///
		   plotregion(lstyle(none)) ///
		   missing ///
		   name(BES_pie_chart)

		   
* Import premier league 2020-2021 season dataset (source: found in an obscure website online - not the best source, I know, but it's just an example!)
import delimited cleaned_players-2.csv, clear 
rename element_type position
order first_name second_name position goals_scored assists minutes red_cards yellow_cards
browse
*Histogram of minutes played
histogram minutes, bins(5) frequency addlabels color(black) fcolor(ltblue) xtitle("Minutes played", size(large)) name(minutes_played)
* focus attention on forwards
keep if position=="FWD"
keep first_name second_name minutes goals_scored
browse 
* Scatterplot of minutes played vs goals scored among forwards
scatter goals_scored minutes, ytitle("Goals scored",size(vlarge)) name(pl_scatter, replace) xtitle("Minutes played", size(vlarge)) mcolor(blue) msize(medium)
scatter goals_scored minutes, mlabel(second_name) ytitle("Goals scored",size(vlarge)) name(pl_scatter2, replace) xtitle("Minutes played", size(vlarge)) mcolor(blue)


* Import data on GDP per capita in 1870 and 2018 (source: Penn World Tables)
use "mpd2020.dta", clear
keep if year==1870|year==1900|year == 2018
drop pop
reshape wide gdppc, i(countrycode) j(year)
set scheme plotplainblind
replace gdppc1870=ln(gdppc1870)
replace gdppc2018=ln(gdppc2018)
replace gdppc1900=ln(gdppc1900)
label variable gdppc1870 "Log GDP per capita in 1870"
label variable gdppc1870 "Log GDP per capita in 2018"

scatter gdppc2018 gdppc1900 if gdppc2018>=8, mcolor(blue) msize(medium) mlabel(countrycode) legend(off) ytitle("Log GDP per capita 2018",size(vlarge)) xtitle("Log GDP per capita 1870", size(vlarge))name(persistence_graph, replace) 
