***************************1. IMPORT, REFINE & ANALYSE**************************

clear all
set more off
eststo clear
//net install http://xtoaxaca.uni-goettingen.de/xtoaxaca.pkg, replace

cd "C:\Users\point\OneDrive\Documents\Standard Files\University\Stage 3\EC541\Data\understanding society\US\All\UKDA-6614-stata\analysis" // replace with your directory
*************for help with any file simply type help "command name"*************
use "..\Output\Finished_Data.dta", replace
replace pt = . if pt<0
sort pidp year

//attrition bias has not been taken into account
//could use data on work history to make exper more accurate
gen lwage = log(ghrpay)
gen exper2 = exper^2
replace UKyrs = age //for people who were born in the UK! Do I want to do this??

tab jbsic07_cc nonwhite, row nofreq
bysort pidp: egen mbritid = max(britid)
tab jbsic07_cc britid if britid>=0 & jbsic07_cc>=1 & britid==mbritid, row nofreq
//does this align with:
tab jbsic07_cc racism if jbsic07_cc>=1, row nofreq //? where 8 is the most racist and 1 & 5 are least

estpost tab jbsic07_cc britid if britid>=0 & jbsic07_cc>=1 & britid==mbritid //only keep max value to remove attrition bias
esttab . using occup_attitudes.csv, cell(rowpct) unstack noobs varlabels(`e(labels)') csv compress nogaps longtable replace

//gen id = hidp*year
xtset pidp year //balanced or gaps?

reg racism female married year i.occup i.region i.SIC2D black chinese asian pt disabled tenure
hettest
reg racism female year i.occup i.region i.SIC2D black chinese asian pt disabled tenure, robust //not much better
//reg the industry on racism to see if racism impacts which industry you work in!

eststo fe: xtreg racism female i.year i.occup i.region i.SIC2D black chinese asian pt disabled, fe //can't cluster
eststo re: xtreg racism female year i.occup i.region i.SIC2D black chinese asian pt disabled, re
hausman fe re //therefore should use fe

tab occup, nofreq generate(occup)
tab region, nofreq generate(region)
tab SIC2D, nofreq generate(SIC2D)
tab year, nofreq generate(year)
tab educ, nofreq generate(educ)
xtserial racism female year occup1-occup8 region1-region12 SIC2D1-SIC2D20 black chinese asian pt disabled //so need to use FD (and robust?)  BUT I lose around 1/3 of my data.

xtreg racism D.(female year occup1-occup8 region1-region12 SIC2D1-SIC2D20 year1-year27 black chinese asian pt disabled), robust //do I include time, the year var??
eststo fe: xtreg racism female i.year i.occup i.region i.SIC2D black chinese asian pt disabled, fe robust

oaxaca lwage married numch UKyrs tenure exper exper2 disabled pt educ1-educ8 SIC2D1-SIC2D21 year1-year28 occup1-occup9 region1-region13 if female==0, by(nonwhite) pooled cluster(pidp) detail(educ:educ*, year:year*, SIC2D:SIC2D*, occup:occup*, exp_ten: tenure exper exper2, region: region*)  //why is tenure only 168,145 obs??. Could cluster by pidp (why not hidp??)

eststo oaxaca: oaxaca lwage married numch UKyrs tenure exper exper2 educ1-educ8 SIC2D1-SIC2D21 year1-year28 occup1-occup9 region1-region13 pt disabled if female==1, by(nonwhite) pooled //relax and robust

eststo oaxaca: oaxaca lwage married numch UKyrs tenure exper exper2 pt disabled normalize(educ1-educ8) normalize(SIC2D1-SIC2D21) normalize(year1-year28) normalize(occup1-occup9) normalize(region1-region13) if female==0, by(nonwhite) pooled robust categorical(educ?, SIC2D1-SIC2D21, year1-year28, occup1-occup9) detail(educ:educ*, year:year*, SIC2D:SIC2D*, occup:occup*, region:region*, exp_ten: emplen exper exper2) relax //not included age, as we have emplen!