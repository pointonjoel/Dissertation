/*
education fix - ask Gui
regional unemployment - include! so add to decomps.
rename some vars?

Need to sort the labeling for SIC1D and occup and region
*/
//cd "Z:\My Files\Diss"
cd "C:\Users\point\OneDrive\Documents\Standard Files\University\Stage 3\EC541\Data\LFS"
//log using oaxaca_output.log, replace
sysdir set PLUS "`c(pwd)'"
/*
ssc install estout
ssc install oaxaca
ssc install sutex
eststo clear
*/
use "Output\LFS_Finished_Data.dta", clear //I NEED TO MACHANG EVERYTHING FROM WHITE TO NONWHITE, BUT BE CAREFUL OF WHITE==1 NOW MEANS NONWHITE==0
//rename mixrace mixed
replace children=. if children==-9
replace exper=. if exper<0
drop if year==2020
table year ethnic, contents(mean paygh)

//replace INDD07M==. if INDD07M==4
//drop INDD07L

tab educ if nonwhite==1
/*
reg lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt i.educ i.occup i.time i.region if industry!=. & female==0
predict um, resid
//table industry, contents(mean um)
reg lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt i.educ i.occup i.time i.region if industry!=. & female==1
predict uf, resid
table industry, contents(mean um mean uf)
//drop um
*/

/*
**********Generating median pay into by ethnicity and gender
tabout ethnic if female==0 using Tables\male_hourly_percentiles.tex, c(p10 paygh p25 paygh p50 paygh p75 paygh p90 paygh) sum replace clab("10" "25" "50" "75" "90") style(tex) topf(Tables\Style\top_m.tex) botf(Tables\Style\bot_m.tex) f(2)
tabout ethnic if female==1 using Tables\female_hourly_percentiles.tex, c(p10 paygh p25 paygh p50 paygh p75 paygh p90 paygh) sum replace clab("10" "25" "50" "75" "90") style(tex) topf(Tables\Style\top_f.tex) botf(Tables\Style\bot_f.tex) f(2)
*/

local varlist married female children UKyrs black asian chinese mixed emplen exper exper2 disability pt educ industry time occup region lwage attitudes regional_u public u25 regional_u
gen missing = 0
foreach var in `varlist'{
	replace missing = missing + 1 if `var'==.
}

tabulate ethnic if year==1997, summarize(paygh) means
table year ethnic, contents(mean paygh)

**********Exporting summary stats
sutex * if missing==0 & year<2020, nobs key(sumstats) replace ///
file(Tables\sumstats.tex) title("Summary statistics") minmax digits(2) //add 'lab' after 1st commar to get labels instead of var names

**********Exporting industry data
*industry
estpost tabulate industry ethnic if lwage!=. & missing==0, elabels
esttab . using Tables\2D_industries.tex, cell(b()) unstack noobs varlabels(`e(labels)') eqlabels("White" "Black" "Chinese" "Asian" "Mixed") title("2-Digit SIC codes by ethnicity") tex compress nogaps longtable replace addnotes(\label{tab:2D_industries}) //raw numbers

*SIC1D - Male
estpost tabulate SIC1D ethnic if lwage!=. & female==0 & missing==0, elabels
esttab . using Tables\1D_industries_male.tex, cell(colpct(fmt(1))) unstack noobs varlabels(`e(labels)') eqlabels("White" "Black" "Chinese" "Asian" "Mixed") title("1-Digit SIC codes by ethnicity for males (proportions)") tex compress nogaps replace addnotes(\label{tab:1D_industries_male}) //percent

*SIC1D - Female
estpost tabulate SIC1D ethnic if lwage!=. & female==1 & missing==0, elabels
esttab . using Tables\1D_industries_female.tex, cell(colpct(fmt(1))) unstack noobs varlabels(`e(labels)') eqlabels("White" "Black" "Chinese" "Asian" "Mixed") title("1-Digit SIC codes by ethnicity for females (proportions)") tex compress nogaps replace addnotes(\label{tab:1D_industries_female}) //percent
//Just need to format it nicely so it doesn't have lots of 'b's at the top. Plus a label instead of (1) at the top.

**********Exporting occupation data
*Occupation - Male
estpost tabulate occup ethnic if lwage!=. & female==0 & missing==0, elabels
esttab . using Tables\occup_male.tex, cell(colpct(fmt(1))) unstack noobs varlabels(`e(labels)') eqlabels("White" "Black" "Chinese" "Asian" "Mixed") title("Occupation by ethnicity for males (proportions)") tex compress nogaps replace addnotes(\label{tab:occup_male}) //percent

*Occupation - Female
estpost tabulate occup ethnic if lwage!=. & female==1 & missing==0, elabels
esttab . using Tables\occup_female.tex, cell(colpct(fmt(1))) unstack noobs varlabels(`e(labels)') eqlabels("White" "Black" "Chinese" "Asian" "Mixed") title("Occupation by ethnicity for females (proportions)") tex compress nogaps replace addnotes(\label{tab:occup_female}) //percent
//Just need to format it nicely so it doesn't have lots of 'b's at the top. Plus a label instead of (1) at the top.


**********Generating the categorical dummies
tab educ, nofreq generate(educ)
tab time, nofreq generate(time)
tab industry, nofreq generate(industry)
tab occup, nofreq generate(occup)
tab region, nofreq generate(region)

//HNWKAGE
reg paygh married female children UKyrs black asian chinese mixed emplen exper exper2 disability pt i.educ i.industry i.occup i.time i.region attitudes regional_u public u25 regional_u
hettest

reg lwage married female children UKyrs black asian chinese mixed emplen exper exper2 disability pt i.educ i.industry i.occup i.time i.region attitudes regional_u public u25 regional_u
ovtest
hettest
//bgodfrey, lags(1)

*****************************Detailed Oaxaca Decomps****************************
//Add heckman (to which vars??)
*Males //NO CLUSTERING as only inc from 2001-Q2 onwards
eststo oaxacawmd: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if female==0, by(nonwhite) swap pooled robust detail(educ:educ*, time:time*, occup_ind:industry* occup*, exp_ten: emplen exper exper2, region: region*) relax //not included age, as we have emplen!

eststo oaxacabmd: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | black==1) & female==0, by(black) swap pooled robust detail(educ:educ*, time:time*, occup_ind:industry* occup*, exp_ten: emplen exper exper2, region: region*) relax //not included age, as we have emplen!

eststo oaxacacmd: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | chinese==1) & female==0, by(chinese) swap pooled robust detail(educ:educ*, time:time*, occup_ind:industry* occup*, exp_ten: emplen exper exper2, region: region*) relax //not included age, as we have emplen!

eststo oaxacaamd: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | asian==1) & female==0, by(asian) swap pooled robust detail(educ:educ*, time:time*, occup_ind:industry* occup*, exp_ten: emplen exper exper2, region: region*) relax //not included age, as we have emplen!

eststo oaxacammd: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | mixed==1) & female==0, by(mixed) swap pooled robust detail(educ:educ*, time:time*, occup_ind:industry* occup*, exp_ten: emplen exper exper2, region: region*) relax //not included age, as we have emplen!

*Females
eststo oaxacawfd: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if female==1, by(nonwhite) swap pooled robust detail(educ:educ*, time:time*, occup_ind:industry* occup*, exp_ten: emplen exper exper2, region: region*) relax //not included age, as we have emplen!

eststo oaxacabfd: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | black==1) & female==1, by(black) swap pooled robust detail(educ:educ*, time:time*, occup_ind:industry* occup*, exp_ten: emplen exper exper2, region: region*) relax //not included age, as we have emplen!

eststo oaxacacfd: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | chinese==1) & female==1, by(chinese) swap pooled robust detail(educ:educ*, time:time*, occup_ind:industry* occup*, exp_ten: emplen exper exper2, region: region*) relax //not included age, as we have emplen!

eststo oaxacaafd: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | asian==1) & female==1, by(asian) swap pooled robust detail(educ:educ*, time:time*, occup_ind:industry* occup*, exp_ten: emplen exper exper2, region: region*) relax //not included age, as we have emplen!

eststo oaxacamfd: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | mixed==1) & female==1, by(mixed) swap pooled robust detail(educ:educ*, time:time*, occup_ind:industry* occup*, exp_ten: emplen exper exper2, region: region*) relax //not included age, as we have emplen!


******************************Simple Oaxaca Decomps*****************************
//Check the matrix stuff still works with the added region data
*Males //NO CLUSTERING as only inc from 2001-Q2 onwards
eststo oaxacawms: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if female==0, by(nonwhite) swap pooled robust nodetail relax //not included age, as we have emplen!
matrix results = e(b)
matrix A = results/results[1,3]

eststo oaxacabms: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | black==1) & female==0, by(black) swap pooled robust nodetail relax //not included age, as we have emplen!
matrix results = e(b)
matrix B = results/results[1,3]

eststo oaxacacms: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | chinese==1) & female==0, by(chinese) swap pooled robust nodetail relax //not included age, as we have emplen!
matrix results = e(b)
matrix C = results/results[1,3]

eststo oaxacaams: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | asian==1) & female==0, by(asian) swap pooled robust nodetail relax //not included age, as we have emplen!
matrix results = e(b)
matrix D = results/results[1,3]

eststo oaxacamms: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | mixed==1) & female==0, by(mixed) swap pooled robust nodetail relax //not included age, as we have emplen!
matrix results = e(b)
matrix E = results/results[1,3]

//Joining all the percentages together
matrix rowjoinbyname F = A B C D E
matrix G = [F[1...,4],F[1...,5]]
matrix H = G/0.01
matrix J = H'
matrix list J
matrix rownames J = explained unexplained
matrix colnames J = Non-white Black Chinese Asian Mixed //Non-white may cause issues due to the dash
esttab matrix(J, fmt(%3.1f)) using Tables\oaxaca_pct_male.tex, mlabels("") title("Oaxaca Decompositions for Males (proportions)") tex compress nogaps replace addnotes(\label{tab:oaxaca_pct_male}) //units


*******Females
eststo oaxacawfs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if female==1, by(nonwhite) swap pooled robust nodetail relax //not included age, as we have emplen!
matrix results = e(b)
matrix A = results/results[1,3]


eststo oaxacabfs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | black==1) & female==1, by(black) swap pooled robust nodetail relax //not included age, as we have emplen!
matrix results = e(b)
matrix B = results/results[1,3]

eststo oaxacacfs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | chinese==1) & female==1, by(chinese) swap pooled robust nodetail relax //not included age, as we have emplen!
matrix results = e(b)
matrix C = results/results[1,3]

eststo oaxacaafs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | asian==1) & female==1, by(asian) swap pooled robust nodetail relax //not included age, as we have emplen!
matrix results = e(b)
matrix D = results/results[1,3]

eststo oaxacamfs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | mixed==1) & female==1, by(mixed) swap pooled robust nodetail relax //not included age, as we have emplen!
matrix results = e(b)
matrix E = results/results[1,3]

//Joining all the percentages together
matrix rowjoinbyname F = A B C D E
matrix G = [F[1...,4],F[1...,5]]
matrix H = G/0.01
matrix J = H'
matrix list J
matrix rownames J = explained unexplained
matrix colnames J = Non-white Black Chinese Asian Mixed
esttab matrix(J, fmt(%3.1f)) using Tables\oaxaca_pct_female.tex, mlabels("") title("Oaxaca Decompositions for Females (proportions)") tex compress nogaps replace addnotes(\label{tab:oaxaca_pct_female}) //units

**************************Exporting main decompositions*************************
*Detailed decompositions - LaTeX
esttab oaxacawmd oaxacabmd oaxacacmd oaxacaamd oaxacammd using Tables\oaxaca_male.tex, title(Oaxaca Decompositions for Males\label{tab1}) mtitles("Non-white" "Black" "Chinese" "Asian" "Mixed") nogaps replace longtable addnotes(\label{tab:oaxaca_male})
esttab oaxacawfd oaxacabfd oaxacacfd oaxacaafd oaxacamfd using Tables\oaxaca_female.tex, title(Oaxaca Decompositions for Females\label{tab1}) mtitles("Non-white" "Black" "Chinese" "Asian" "Mixed") nogaps replace longtable addnotes(\label{tab:oaxaca_female})

*Detailed decompositions - Excel
esttab oaxacawmd oaxacabmd oaxacacmd oaxacaamd oaxacammd using Tables\excel_male_decomps.csv, title(Oaxaca Decompositions for Males\label{tab1}) mtitles("Non-white" "Black" "Chinese" "Asian" "Mixed") csv not nose nogaps plain replace
esttab oaxacawfd oaxacabfd oaxacacfd oaxacaafd oaxacamfd using Tables\excel_female_decomps.csv, title(Oaxaca Decompositions for Males\label{tab1}) mtitles("Non-white" "Black" "Chinese" "Asian" "Mixed") csv not nose nogaps plain replace

*Simple/Summary decompositions - LaTeX
esttab oaxacawms oaxacabms oaxacacms oaxacaams oaxacamms using Tables\oaxaca_male_summary.tex, title(Oaxaca Decompositions for Males\label{tab1}) mtitles("Non-white" "Black" "Chinese" "Asian" "Mixed") nogaps replace addnotes(\label{tab:oaxaca_male_summary})
esttab oaxacawfs oaxacabfs oaxacacfs oaxacaafs oaxacamfs using Tables\oaxaca_female_summary.tex, title(Oaxaca Decompositions for Females\label{tab1}) mtitles("Non-white" "Black" "Chinese" "Asian" "Mixed") nogaps replace addnotes(\label{tab:oaxaca_female_summary})

*****************************Decomposition over time****************************
//might need to remove 1995 as no disability data and 1996.
local outcomelist 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
*Non-white MALE
local estimates1
foreach var in `outcomelist'{
	quietly oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if year==`var' & female==0, by(nonwhite) swap pooled robust nodetail relax
	est store est_`var'
	local estimates1 `estimates1' est_`var'
}
esttab `estimates1' using Tables\oaxaca_time_nonwhite_male.csv, b(2) obslast csv mtitles(`outcomelist') plain replace addnotes(\label{tab:oaxaca_time_nonwhite_male})

*Black MALE
local estimates2
foreach var in `outcomelist'{
	quietly oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if year==`var' & female==0 & (nonwhite==0 | black==1), by(black) swap pooled robust nodetail relax
	est store est_`var'
	local estimates2 `estimates2' est_`var'
}
esttab `estimates2' using Tables\oaxaca_time_black_male.csv, b(2) obslast csv mtitles(`outcomelist') plain replace addnotes(\label{tab:oaxaca_time_black_male})

*Asian MALE
local outcomelist 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
local estimates2
foreach var in `outcomelist'{
	quietly oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if year==`var' & female==0 & (nonwhite==0 | asian==1), by(asian) swap pooled robust nodetail relax
	est store est_`var'
	local estimates2 `estimates2' est_`var'
}
esttab `estimates2' using Tables\oaxaca_time_asian_male.csv, b(2) obslast csv mtitles(`outcomelist') plain replace addnotes(\label{tab:oaxaca_time_asian_male})

local outcomelist 1999 2007 2008 2009 2010 2012 2013 2014 2015 2016 2017 2018 2019
*Mixed MALE
local estimates2
foreach var in `outcomelist'{
	di `var'
	quietly oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if year==`var' & female==0 & (nonwhite==0 | mixed==1), by(mixed) swap pooled robust nodetail relax
	est store est_`var'
	local estimates2 `estimates2' est_`var'
}
esttab `estimates2' using Tables\oaxaca_time_mixed_male.csv, b(2) obslast csv mtitles(`outcomelist') plain replace addnotes(\label{tab:oaxaca_time_mixed_male})

local outcomelist 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
*Non-white FEMALE
local estimates3
foreach var in `outcomelist'{
	quietly oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if year==`var' & female==1, by(nonwhite) swap pooled robust nodetail relax
	est store est_`var'
	local estimates3 `estimates3' est_`var'
}
esttab `estimates3' using Tables\oaxaca_time_nonwhite_female.csv, b(2) obslast csv mtitles(`outcomelist') plain replace addnotes(\label{tab:oaxaca_time_nonwhite_female})

*Black FEMALE
local estimates4
foreach var in `outcomelist'{
	quietly oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if year==`var' & female==1 & (nonwhite==0 | black==1), by(black) swap pooled robust nodetail relax
	est store est_`var'
	local estimates4 `estimates4' est_`var'
}
esttab `estimates4' using Tables\oaxaca_time_black_female.csv, b(2) obslast csv mtitles(`outcomelist') plain replace addnotes(\label{tab:oaxaca_time_black_female})

*Chinese FEMALE
local outcomelist 2005 2006 2007 2008 2009 2012 2014 2015 2018 2019
local estimates4
foreach var in `outcomelist'{
	di `var'
	quietly oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if year==`var' & female==1 & (nonwhite==0 | chinese==1), by(chinese) swap pooled robust nodetail relax
	est store est_`var'
	local estimates4 `estimates4' est_`var'
}
esttab `estimates4' using Tables\oaxaca_time_chinese_female.csv, b(2) obslast csv mtitles(`outcomelist') plain replace addnotes(\label{tab:oaxaca_time_chinese_female})

*Asian FEMALE
local outcomelist 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
local estimates4
foreach var in `outcomelist'{
	quietly oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if year==`var' & female==1 & (nonwhite==0 | asian==1), by(asian) swap pooled robust nodetail relax
	est store est_`var'
	local estimates4 `estimates4' est_`var'
}
esttab `estimates4' using Tables\oaxaca_time_asian_female.csv, b(2) obslast csv mtitles(`outcomelist') plain replace addnotes(\label{tab:oaxaca_time_asian_female})

*Mixed FEMALE
local outcomelist 1998 1999 2000 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
local estimates4
foreach var in `outcomelist'{
	di `var'
	quietly oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if year==`var' & female==1 & (nonwhite==0 | mixed==1), by(mixed) swap pooled robust nodetail relax
	est store est_`var'
	local estimates4 `estimates4' est_`var'
}
esttab `estimates4' using Tables\oaxaca_time_mixed_female.csv, b(2) obslast csv mtitles(`outcomelist') plain replace addnotes(\label{tab:oaxaca_time_mixed_female})

******************************Sensitivity Analysis*****************************
reg lwage married female children UKyrs black asian chinese mixed emplen exper exper2 disability pt i.educ i.industry i.time i.occup, robust
ovtest

reg lwage married female children UKyrs black asian chinese mixed emplen exper exper2 disability pt i.educ i.industry i.time i.occup i.region, robust cluster(hhid)
ovtest

//Add heckman (to which vars??)
*Males - NO CLUSTERING
eststo oaxacawmncs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if female==0 & year>=2002 & year<=2019, by(nonwhite) swap pooled robust nodetail relax //not included age, as we have emplen!

eststo oaxacabmncs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | black==1) & female==0 & year>=2002 & year<=2019, by(black) swap pooled robust nodetail relax //not included age, as we have emplen!

eststo oaxacacmncs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | chinese==1) & female==0 & year>=2002 & year<=2019, by(chinese) swap pooled robust nodetail relax //not included age, as we have emplen!

eststo oaxacaamncs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | asian==1) & female==0 & year>=2002 & year<=2019, by(asian) swap pooled robust nodetail  relax //not included age, as we have emplen!

eststo oaxacammncs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | mixed==1) & female==0 & year>=2002 & year<=2019, by(mixed) swap pooled robust nodetail  relax //not included age, as we have emplen!

*Females - NO CLUSTERING
eststo oaxacawfncs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if female==1 & year>=2002 & year<=2019, by(nonwhite) swap pooled robust nodetail  relax //not included age, as we have emplen!

eststo oaxacabfncs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | black==1) & female==1 & year>=2002 & year<=2019, by(black) swap pooled robust nodetail  relax //not included age, as we have emplen!

eststo oaxacacfncs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | chinese==1) & female==1 & year>=2002 & year<=2019, by(chinese) swap pooled robust nodetail relax //not included age, as we have emplen!

eststo oaxacaafncs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | asian==1) & female==1 & year>=2002 & year<=2019, by(asian) swap pooled robust nodetail  relax //not included age, as we have emplen!

eststo oaxacamfncs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | mixed==1) & female==1 & year>=2002 & year<=2019, by(mixed) swap pooled robust nodetail  relax //not included age, as we have emplen!

*Males - CLUSTERING
eststo oaxacawmcs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if female==0 & year>=2002 & year<=2019, by(nonwhite) swap pooled robust nodetail cluster(hhid) relax //not included age, as we have emplen!

eststo oaxacabmcs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | black==1) & female==0 & year>=2002 & year<=2019, by(black) swap pooled robust nodetail cluster(hhid) relax //not included age, as we have emplen!

eststo oaxacacmcs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | chinese==1) & female==0 & year>=2002 & year<=2019, by(chinese) swap pooled robust nodetail cluster(hhid) relax //not included age, as we have emplen!

eststo oaxacaamcs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | asian==1) & female==0 & year>=2002 & year<=2019, by(asian) swap pooled robust nodetail cluster(hhid) relax //not included age, as we have emplen!

eststo oaxacammcs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | mixed==1) & female==0 & year>=2002 & year<=2019, by(mixed) swap pooled robust nodetail cluster(hhid) relax //not included age, as we have emplen!

*Females - CLUSTERING
eststo oaxacawfcs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if female==1 & year>=2002 & year<=2019, by(nonwhite) swap pooled robust nodetail cluster(hhid) relax //not included age, as we have emplen!

eststo oaxacabfcs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | black==1) & female==1 & year>=2002 & year<=2019, by(black) swap pooled robust nodetail cluster(hhid) relax //not included age, as we have emplen!

eststo oaxacacfcs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | chinese==1) & female==1 & year>=2002 & year<=2019, by(chinese) swap pooled robust nodetail cluster(hhid) relax //not included age, as we have emplen!

eststo oaxacaafcs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | asian==1) & female==1 & year>=2002 & year<=2019, by(asian) swap pooled robust nodetail cluster(hhid) relax //not included age, as we have emplen!

eststo oaxacamfcs: oaxaca lwage married children UKyrs emplen public u25 regional_u exper exper2 disability pt normalize(educ1-educ4) normalize(industry1-industry60) normalize(time1-time94) normalize(occup1-occup9) normalize(region1-region11) if (nonwhite==0 | mixed==1) & female==1 & year>=2002 & year<=2019, by(mixed) swap pooled robust nodetail cluster(hhid) relax //not included age, as we have emplen!

*Detailed decompositions - LaTeX
esttab oaxacawmncs oaxacabmncs oaxacacmncs oaxacaamncs oaxacammncs using Tables\oaxaca_male_nonclustered.tex, title(Non-clustered Oaxaca Decompositions for Males (2002-2019)\label{tab1}) mtitles("Non-white" "Black" "Chinese" "Asian" "Mixed") nogaps replace addnotes(\label{tab:oaxaca_male_nonclustered})
esttab oaxacawfncs oaxacabfncs oaxacacfncs oaxacaafncs oaxacamfncs using Tables\oaxaca_female_nonclustered.tex, title(Non-clustered Oaxaca Decompositions for Females (2002-2019)\label{tab1}) mtitles("Non-white" "Black" "Chinese" "Asian" "Mixed") nogaps replace addnotes(\label{tab:oaxaca_female_nonclustered})

esttab oaxacawmcs oaxacabmcs oaxacacmcs oaxacaamcs oaxacammcs using Tables\oaxaca_male_clustered.tex, title(Clustered Oaxaca Decompositions for Males (2002-2019)\label{tab1}) mtitles("Non-white" "Black" "Chinese" "Asian" "Mixed") nogaps replace addnotes(\label{tab:oaxaca_male_clustered})
esttab oaxacawfcs oaxacabfcs oaxacacfcs oaxacaafcs oaxacamfcs using Tables\oaxaca_female_clustered.tex, title(Clustered Oaxaca Decompositions for Females (2002-2019)\label{tab1}) mtitles("Non-white" "Black" "Chinese" "Asian" "Mixed") nogaps replace addnotes(\label{tab:oaxaca_female_clustered})
  
/*
estout oaxacawm using oaxacawm.xls, cells(b(star fmt(3)) t(par fmt(2))) replace
estout oaxacabm using oaxacabm.xls, cells(b(star fmt(3)) t(par fmt(2))) replace
estout oaxacacm using oaxacacm.xls, cells(b(star fmt(3)) t(par fmt(2))) replace
estout oaxacaam using oaxacaam.xls, cells(b(star fmt(3)) t(par fmt(2))) replace
estout oaxacamm using oaxacamm.xls, cells(b(star fmt(3)) t(par fmt(2))) replace
estout oaxacawf using oaxacawf.xls, cells(b(star fmt(3)) t(par fmt(2))) replace
estout oaxacabf using oaxacabf.xls, cells(b(star fmt(3)) t(par fmt(2))) replace
estout oaxacacf using oaxacacf.xls, cells(b(star fmt(3)) t(par fmt(2))) replace
estout oaxacaaf using oaxacaaf.xls, cells(b(star fmt(3)) t(par fmt(2))) replace
estout oaxacamf using oaxacamf.xls, cells(b(star fmt(3)) t(par fmt(2))) replace
*/

//outreg2 [oaxacaw oaxacab] using oaxaca.xls, replace //the oaxaca decomps
  
//log close 
  
  
/*
//eststo sumstats1: estpost summarize female nonwhite black age, detail

eststo sumstats1: estpost nonwhite black age, detail

esttab sumstats1, cells("mean p50 min max sd") nonumbers label

esttab sumstats1 using "sumstats.tex", booktabs ///
       label nonumbers cells("mean p50 min max sd") replace 
*/

//ssc install texdoc
//net install sjlatex, from(http://www.stata-journal.com/production)
//sjlatex install
//sjlog type output.do, replace
