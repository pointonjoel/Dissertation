cd "C:\Users\point\OneDrive\Documents\Standard Files\University\Stage 3\EC541\Data\LFS\"

use "Output\LFS_Combned.dta", clear

rename THISWV wave //wave of the participant
keep if wave==1


*INDD07M INDC07M (job industry- 2 digit and THEN 4 digit) 
*DISEA (disability)
*I need to understand how this income-weighting thing works.
//need to also get each person's industry that they work in
********************************D.Cleaning Data*********************************
drop CASENOP
//rename HSERIALP hhnum //unique household identifier - note NOT INCLUDED FROM 2001-Q2 and prior
rename AGE age //age of participant
rename SEX sex //sex of respondent
rename CAMEYR yrarrive //year arrived in the UK
rename EMPTEN empten //years with current employer - DERIVED
rename GRSSWK paygw //Gross weekly pay
*rename NETWK netweek //Net weekly income...?
label variable year "Year of LFS Study"
label variable quarter "Quarter of LFS Study"


********************************

drop BENFTS CLAIMS14 UNEMBN1 jsatyp BENTYP5
drop RELIG11 //No religion data for pre-2002

//need to merge the HIGQUAL and LEVQUL ONES - changes around 2014

*Removing the unemployed/Inactive
gen unemp = 1 //so anyone with a missing value, unemployed, inactive, under 16, unpaid family worker, or on a training programme gets a value of 1, so will be dropped.
label variable unemp "unemployed/inactive/missing value/U16/unpaid family work/training programme"
replace unemp = 0 if ILODEFR==1 //and only the 'in employment' group are kept
replace unemp = 0 if INECACR==1 | INECACR==2 & year==1993 & quarter!=4 //along with those who are employed or self employed in 1993 (Q1-Q3)
tab ILODEFR
tab year if ILODEFR!=.
tab unemp

*Generating the married dummy (changed in 2011) and marstt (1996-Q1) and marcon (1994-Q4) 
gen married = 0 if MARDY6==2 | MARDY==2 | marstt==1 | marstt==4 | marstt==5 | (marcon>=2 & marcon<=6) //non married people/divorced/widows/and those living together but not married
label variable married "Married, inc sep but not divorced/widows"
replace married = 1 if MARDY6==1 | MARDY==1 | marstt==2 | marstt==3 | marcon==1 //married people (marstt==3 means married peeps who are separated but not divorced - excludes divorced and widows)
drop MARDY6 marstt MARDY marcon

*Removing religion
//gen christian = 1 if RELIG==1 | relig==2
//replace christian = 0 if (RELIG>=2 & RELIG<=8) | relig==1 | (relig>=3 & relig<=8)
drop IREND2 RELIGE RELIGS RELIGW RELIG

* Region var - GOVTOF2 (post-2000), GOVTOF (2002-Q3), govtor (2000-Q1)
gen region = GOVTOF2
label variable region "Region of the UK"

//GOVTOF
replace region = GOVTOF if GOVTOF!=. & GOVTOF!=.3
replace region = 2 if GOVTOF==3 //merging regions 2 and 3

* Part time
gen pt = 1 if FTPTWK==2
replace pt = 0 if FTPTWK==1
label variable pt "=1 if working part time"

//govtor
replace region = 1 if govtor==1 | govtor==2 
replace region = 2 if govtor==3 | govtor==4 | govtor==5
replace region = 4 if govtor==6 | govtor==7 | govtor==8
replace region = 5 if govtor==9
replace region = 6 if govtor==10 | govtor==11
replace region = 7 if govtor==12
replace region = 8 if govtor==13 | govtor==14
replace region = 9 if govtor==15
replace region = 10 if govtor==16
replace region = 11 if govtor==17
replace region = 12 if govtor==18 | govtor==19 //Scotland
replace region = 13 if govtor==20 //NI
drop GOVTOF2 GOVTOF govtor

label define region -9 `"Does not apply"', modify
label define region 1 `"North East"', modify
label define region 2 `"North West (inc Merseyside)"', modify
label define region 4 `"Yorkshire and Humberside"', modify
label define region 5 `"East Midlands"', modify
label define region 6 `"West Midlands"', modify
label define region 7 `"Eastern"', modify
label define region 8 `"London"', modify
label define region 9 `"South East"', modify
label define region 10 `"South West"', modify
label define region 11 `"Wales"', modify
label define region 12 `"Scotland"', modify
label define region 13 `"Northern Ireland"', modify

*Generating ethnicity dummies (ETHUKEUL for 2011-2020, ETH01 for 2001-2011, ethcen for 1993-2000)
gen white=1 if ETH01==1 | ethcen==0 | ETHUKEUL==1
label variable white "White"
replace white=0 if (ETH01>=2 & ETH01<=5) | (ethcen>=1 & ethcen<=9) | ethcen==11 | (ETHUKEUL>=2 & ETHUKEUL<=8) //DO WE WANT MISSING VALUES TO ALL HAVE 0? IF SO WE CAN JUST PUT EVERY NON-1 VALUE AS 0

gen nonwhite = 1 - white
label variable nonwhite "Nonwhite (Black, Chinese, Asian, Mixed)"

gen black=1 if ETH01==4 | (ethcen>=1 & ethcen<=3) | ETHUKEUL==8 //NOT including ethcen's black-mixed category.
label variable black "Black, not inc black-mixed"
replace black=0 if (ETH01>=1 & ETH01<=3) | ETH01==5 | ethcen==0 | (ethcen>=4 & ethcen<=9) | ethcen==11 | (ETHUKEUL>=1 & ETHUKEUL<=7)

gen asian=1 if ETH01==3 | (ethcen>=5 & ethcen<=7) | ethcen==9 | (ETHUKEUL>=3 & ETHUKEUL<=5) | ETHUKEUL==7
label variable asian "Asian not inc Chinese"
replace asian=0 if (ETH01>=1 & ETH01<=2) | (ETH01>=4 & ETH01<=5) | (ethcen>=0 & ethcen<=4) | ethcen==8 | ethcen==11 | ETHUKEUL==1 | ETHUKEUL==2 | ETHUKEUL==6 | ETHUKEUL==8

gen chinese=1 if ETH01==5 | ethcen==8 | ETHUKEUL==6
label variable chinese "Chinese"
replace chinese=0 if (ETH01>=1 & ETH01<=4) | (ethcen>=0 & ethcen<=7) | ethcen==9 | ethcen==11 | (ETHUKEUL>=1 & ETHUKEUL<=5) | (ETHUKEUL>=7 & ETHUKEUL<=8)

gen mixed=1 if ETH01==2 | ethcen==4 | ethcen==11 | ETHUKEUL==2
label variable mixed "Mixed race"
replace mixed=0 if ETH01==1 | (ETH01>=3 & ETH01<=5) | (ethcen>=0 & ethcen<=3) | (ethcen>=5 & ethcen<=9) | ETHUKEUL==1 | (ETHUKEUL>=3 & ETHUKEUL<=8)

drop ethcen ethnic ethnica ETH01 ETHCEN15 ETHUK14 ETHUK8 ETHEWEUL ETHGBEUL ETHUKEUL

*Generating single ethnicity variable
gen ethnic=.
replace ethnic=0 if white==1
replace ethnic=1 if black==1
replace ethnic=2 if chinese==1
replace ethnic=3 if asian==1
replace ethnic=4 if mixed==1
label variable ethnic "Categorical ethnicity variable"

*Generate income weight variable
gen incweight=.
label variable incweight "Income weighting, changed 18/16/14/07"
replace incweight=PIWT18 if PIWT18!=.
replace incweight=PIWT16 if PIWT16!=.
replace incweight=PIWT14 if PIWT14!=.
replace incweight=PIWT07 if PIWT07!=.
drop PIWT07 PIWT14 PIWT16 PIWT18

* employment
gen empstat = 1 if (INECACR>=6 & INECACR<=29) //inactive
replace empstat = 2 if INECACR==3 | INECACR==4 | INECACR==5 //unemp
replace empstat = 3 if INECACR==1 & pt==1 //part time
replace empstat = 4 if INECACR==1 & pt==0 //full time - check these add up
replace empstat = 5 if INECACR==2 //self emp (full or pt)

replace empstat = 1 if (INECAC05>=6 & INECAC05<=34)
replace empstat = 2 if INECAC05==3 | INECAC05==4 | INECAC05==5 //unemp
replace empstat = 3 if INECAC05==1 & pt==1 //pt
replace empstat = 4 if INECAC05==1 & pt==0 //ft
replace empstat = 5 if INECAC05==2 //self emp (full or pt)

tab ethnic empstat if (age>=16 & age<=64), row nofreq gamma
//drop empstat INECACR INECAC05


*Merging age left education
replace edage=EDAGE if edage==.
drop EDAGE

* Disability (LNGLIM (1996) HEALYL (1997-1998, well to 2020 actually) but DISCURR (1998-2013), DISCURR13 (2013 onwards) are preferred as they are less subjective)
gen disability = 1 if LNGLIM==1 | HEALYL==1 | DISCURR==1 | DISCURR==2 | DISCURR==3 | DISCURR13==1 | DISCURR13==2 | DISCURR13==3 | DISCURR20==1 | DISCURR20==2 | DISCURR20==3
replace disability = 0 if LNGLIM==-9 | LNGLIM==2 | HEALYL==-9 | HEALYL==2 | DISCURR==-9 | DISCURR==4 | DISCURR13==-9 | DISCURR13==4 | DISCURR20==-9 | DISCURR20==4
drop LNGLIM HEALYL DISCURR*


*Generating degree dummy var - qual0-2 (93-95), degree(96-00), DEGREE (01-03), DEGREE4 (04-06), DEGREE7_ (06-10), QUAL_1 (11-20), hiquald (2001-Q2), QUALS01/QUALS02/QUALS03/QUALS04 (2004-Q1), QUAL_! (2015-Q3)
gen deg=.
label variable deg "Degree dummy variable"
replace deg=0 if (qual0>=4 & qual0<=29) | (qual1>=4 & qual1<=29) | (qual2>=4 & qual2<=29) | degree==-9 | DEGREE==-9 | DEGREE4==-9 | DEGREE71==-9 | (hiquald>=2 & hiquald<=6) | (QUALS01>=2 & QUALS01<=25) | QUAL_1==0 //note not using QUALS02 etc as otherwise people witha degree (1) then answer >1 (i.e. no degree) for QUALS02-04! 
replace deg=1 if (qual0>=1 & qual0<=3) | (qual1>=1 & qual1<=3) | (qual2>=1 & qual2<=3) | degree ==-8 | (degree>=1 & degree<=4) | DEGREE ==-8 | (DEGREE>=1 & DEGREE<=4) | (DEGREE4>=1 & DEGREE4<=5) | DEGREE71 ==-8 | (DEGREE71>=1 & DEGREE71<=5) | DEGREE72 ==-8 | (DEGREE72>=1 & DEGREE72<=5) | DEGREE73 ==-8 | (DEGREE73>=1 & DEGREE73<=5) | DEGREE74 ==-8 | (DEGREE74>=1 & DEGREE74<=5) | DEGREE75 ==-8 | (DEGREE75>=1 & DEGREE75<=5) | hiquald==1 | QUALS01==1 | QUALS02==1 | QUALS03==1 | QUALS04==1 | QUAL_1==1
drop degree DEGREE DEGREE4 DEGREE71 DEGREE72 DEGREE73 DEGREE74 DEGREE75 QUAL_1 QUALS01 QUALS02 QUALS03 QUALS04 qual0-qual2

*Fixing length in employment
replace empten=. if empten>86 | empten<0 //getting rid of anomalies/ones which just have the current year or something off

gen emplen=.
label variable emplen "Length of time with current employer"
replace emplen=0.125 if EMPLEN==1
replace emplen=0.375 if EMPLEN==2
replace emplen=0.75 if EMPLEN==3
replace emplen=1.5 if EMPLEN==4
replace emplen=3.5 if EMPLEN==5
replace emplen=7.5 if EMPLEN==5
replace emplen=0.5 if empten==0 & year<=1993 & emplen==.
replace emplen=empten if year<=1993 & emplen==.
replace emplen=20 if emplen>20

drop empten
rename EMPLEN ogemplen

*Generating industry/sector info - IN0792DM (2009-2020), INDD92M/indd92m (1994-2008)
rename IN0792DM industry
label variable industry "2 digit SIC 1992 (either direct or converted)"
replace industry=INDD92M if INDD92M!=.
replace industry=. if (industry>=61 & industry<=63) 
drop INDD92M

*Generating industry/sector info - IN0792EM (2009-2020), INDSECT/indsect (1994-2008)
*Note it only appears for 1996 onwards, although I could derive it from INDM92M if I figured out how the classifications work.
rename IN0792EM SIC1D
label variable SIC1D "1 digit SIC 1992 (either direct or converted)"
replace SIC1D=INDSECT if INDSECT!=.
replace SIC1D=. if SIC1D==10
drop INDSECT
label define SIC1D -9 `"Does not apply"', modify
label define SIC1D -8 `"No answer"', modify
label define SIC1D 1 `"A-B: Agriculture \& fishing"', modify
label define SIC1D 2 `"C,E: Energy \& water"', modify
label define SIC1D 3 `"D: Manufacturing"', modify
label define SIC1D 4 `"F: Construction"', modify
label define SIC1D 5 `"G-H: Distribution, hotels \& restaurants"', modify
label define SIC1D 6 `"I: Transport \& communication"', modify
label define SIC1D 7 `"J-K: Banking, finance \& insurance etc"', modify
label define SIC1D 8 `"L-N: Public admin, educ \& health"', modify
label define SIC1D 9 `"O-Q: Other services"', modify

*Adding in experience
gen exper=age-edage
label variable exper "Approximate experience in the labour market"

*Renaming the depednt children vars
rename FDPCH2 numchu2
rename FDPCH4 numch2t4
rename FDPCH9 numch5t9
rename FDPCH15 numch10t15
rename FDPCH16 numchu16
rename FDPCH19 numchu19

* Number of employees - MPNR02 (2020 - 2002-Q2), MPNR01 (2002-Q1 - 2001-Q3), oympr01 (2001-Q2), mpnor (pre-2001)
gen u25 = 1 if (MPNR02>=1 & MPNR02<=4) | (MPNR01>=1 & MPNR01<=4) | (oympr01>=1 & oympr01<=4) | (mpnor>=1 & mpnor<=4) //under 25 employees dummy
replace u25 = 0 if (MPNR02>4 & MPNR02<.) | (MPNR01>4 & MPNR01<.) | (oympr01>4 & oympr01<.) | (mpnor>4 & mpnor<.)

drop MPNR02 MPNR01 oympr01 mpnor
label variable u25 "Under 25 employees at current firm"

* Public company
gen public = 1 if PUBLICR==2
replace public = 0 if PUBLICR==1

drop PUBLICR
label variable public "=1 if working in the public sector"

*A Levels
replace LEVQUAL = LEVQUALI if LEVQUALI<.
replace LEVQUAL = LEVQUAL5 if LEVQUAL5<.
replace LEVQUAL = LEVQUAL6 if LEVQUAL6<.
replace LEVQUAL = LEVQUAL8 if LEVQUAL8<.
replace LEVQUAL = LEVQUL11 if LEVQUL11<.
replace LEVQUAL = LEVQUL15 if LEVQUL15<.

gen ALev1=.
label variable ALev1 "1 or more A Levels"
replace ALev1=1 if NUMAL==1 | NUMAL==2 | LEVQUAL== 1 | LEVQUAL==2 //if 1 or more A Levels
replace ALev1=0 if NUMAL==-9 | NUMAL==-8 //so only "Don't know" gives a missing value
gen ALev2p=.
label variable ALev2p "2 or more A Levels"
replace ALev2p=1 if NUMAL==2 | LEVQUAL== 1 | LEVQUAL==2 //if 2 or more A Levels
replace ALev2p=0 if NUMAL==-9 | NUMAL==-8 | NUMAL==1 //so only "Don't know" gives a missing value

drop NUMAL


/* because it only has 1 or more GCSEs, rather than 4+ or 5+ - so removing A Levels too as removing for 1993. Hard to tell the equivalent to an A Level too.
//qual0,qual1,qual2 for 1993-Q1
//replace qual0=. if year!=1993
//replace qual1=. if year!=1993
//replace qual2=. if year!=1993
replace ALev1=0 if qual0>=1 & qual0<=9 & ALev1==. //last part ensures we only put a 0 if we had a missing value before
replace ALev1=0 if qual1>=11 & qual1<=14 & ALev1==. //Issues with the labelling - use 1993-Q4
replace ALev1=0 if qual2>=11 & qual2<=14 & ALev1==.
replace ALev1=1 if qual0>=11 & qual0<=14
replace ALev1=1 if qual1>=1 & qual1<=9
replace ALev1=1 if qual2>=1 & qual2<=9
replace ALev2p=1 if qual0>=1 & qual0<=9 //not technically 2 plus? As could have just 1 A Level
replace ALev2p=1 if qual1>=1 & qual1<=9 //not technically 2 plus? As could have just 1 A Level
replace ALev2p=1 if qual2>=1 & qual2<=9 //not technically 2 plus? As could have just 1 A Level
*/

//drop NUMAL

*GCSEs - NUMOL5 (2005-2020), NUMOL4 (2004), NUMOL(1994-2003), special case for 2004/2005 Q1 below
gen GCSEs5=.
label variable GCSEs5 "5 or more GCSEs"
replace GCSEs5=0 if LEVQUAL==-9 | LEVQUAL==5 | LEVQUAL==7 //2004/2005 Q1
replace GCSEs5=0 if NUMOL5==-9 | NUMOL5==1 | NUMOL4==-9 | NUMOL4==1 | NUMOL4==2 | NUMOL==-9 | NUMOL==1 //So only don't know/no answer get a missing value
replace GCSEs5=. if LEVQUAL==3 | LEVQUAL==6
replace GCSEs5=1 if NUMOL5==2 | NUMOL4==3 | NUMOL==2
//LEVQUAL for 2004-Q1 and 2005-Q1
//replace LEVQUAL=. if year<2004 | year>2005
//replace LEVQUAL=. if quarter!=1
replace GCSEs5=1 if LEVQUAL==4 | LEVQUAL==2 | LEVQUAL==1 | LEVQUAL==6 | LEVQUL11==4 | LEVQUL11==2 | LEVQUL11==1 | LEVQUL15==4 | LEVQUL15==2 | LEVQUL15==1 //2004/2005 Q1

/*
//qual0,qual1,qual2 for 1993-Q1
replace GCSEs5=1 if qual0>=1 & qual0<=10
replace GCSEs5=1 if qual1>=1 & qual1<=10
replace GCSEs5=1 if qual2>=1 & qual2<=10
//Also have missing values for 1994-Q4 due to the change from seasonal to calendar quarters
*/
//drop LEVQUAL NUMOL* qual0 qual1 qual2

*Generating single education variable
gen educ=.
label variable educ "Nothing=0, 5 GCSEs=1, 2+ A Levels=2, degree=3"
replace educ=0 if GCSEs5==0
replace educ=1 if GCSEs5==1
replace educ=2 if ALev2p==1 | ALev1==1
replace educ=3 if deg==1
//drop LEVQUL* LEVQUAL* 
//do I need anything above degree - advanced degree?!

*Generating female dummy
gen female=.
replace female=0 if sex==1 //males
replace female=1 if sex==2 //females
drop sex
label variable female "=1 if female"

*Fixing the merging of yrarrive variable
replace yrarrive=yrarrive+1900 if year>=1994 & year<=1997 & yrarrive>0 //changing 62-->1962 for 1994-1997
replace yrarrive=yrarrive+1900 if year==1998 & quarter==1 & yrarrive>0 //changing 62-->1962 for 1998-Q1

*Number of adults in household - HNMF5964 (2010-Q2-->2020) and HNWKAG (1998-->2010-Q1)
//HNMF5964
//HNWKAG


*Generating unique hh identifier
gen id=real(HSERIALP)
egen hhid=concat(quarter year id)
destring hhid, replace
replace hhid=. if HSERIALP==""
drop id HSERIALP
label variable hhid "Household ID"
//gen hhid = real(string(quarter) + string(year) + string(real(HSERIALP)))

*Generating occupation (SC10MMJ - JM2011 onwards, sc2kmmj - 2001-Q2 onwards, SOCMAJM for 2000 and earlier)
gen occup = .
replace occup=SC10MMJ if SC10MMJ!=.
replace occup=SC2KMMJ if SC2KMMJ!=.
replace occup=socmajm if socmajm!=.
drop SC10MMJ SC2KMMJ socmajm
//label drop occup
label define occup 1 `"Managers, Directors And Senior Officials"', modify
label define occup 2 `"Professional Occupations"', modify
label define occup 3 `"Associate Professional And Technical Occupations"', modify
label define occup 4 `"Administrative And Secretarial Occupations"', modify
label define occup 5 `"Skilled Trades Occupations"', modify
label define occup 6 `"Caring, Leisure And Other Service Occupations"', modify
label define occup 7 `"Sales And Customer Service Occupations"', modify
label define occup 8 `"Process, Plant And Machine Operatives"', modify
label define occup 9 `"Elementary Occupations"', modify

label variable occup "Occupation, categorical variable"

*Generating time variable
egen time=concat(quarter year) //for the regression
destring time, replace
gen qdate=yq(year, quarter) //for xtset
format qdate %tq
label variable time "Time variable, qyyyy"
drop qdate

*Gen yearsinUK 
gen UKyrs=age if yrarrive==-9 //do we want natives to have a value at all?? Perfect MC with age?
label variable UKyrs "# years living in the UK"
replace UKyrs=year-yrarrive if yrarrive>1900 & yrarrive<2021

//check to remove any mental data
gen agearrive = age - UKyrs
drop if agearrive<-2 //allow for a bit of inconsistency

drop yrarrive agearrive

* Hourly wage (PAIDHRA for all except 2001-Q1 and 1999 where bushr is used instead)
replace paygw = . if paygw<0
gen paygh = paygw/PAIDHRA if PAIDHRA>0 & PAIDHRA!=. 
replace paygh = paygw/bushr if bushr>0 & bushr!=.


* Deflator
local cpi_deflator 59.8539 59.6946 60.2723 60.6104 60.8051 60.6298 60.6408 61.5902 61.6451 62.1379 62.6373 63.173 63.8302 64.9559 65.4731 65.6064 64.6893 64.5574 66.0181 64.4472 64.842 65.1966 65.621 66.7134 66.611 66.1413 65.9473 66.1628 67.0686 67.3494 67.6174 67.6621 67.5284 68.4993 68.1546 68.5178 68.9349 69.3233 69.8657 70.3122 70.7213 70.8836 71.4356 71.984 71.9395 73.0378 73.2965 73.9853 74.0992 75.2015 75.0037 75.8281 76.1531 76.954 77.5453 77.9278 78.3383 78.8768 79.5204 80.1653 80.9627 81.058 81.9881 82.7183 82.4184 82.8282 83.6177 83.0973 83.885 84.4408 84.2181 84.7447 86.1307 85.5411 85.8973 86.6973 86.5466 87.1367 87.9011 88.3725 88.3192 88.4523 89.4323 89.9727 90.2162 90.4226 90.9466 90.7755 90.8663 91.5453 91.3381 91.0126 92.0771 93.048 93.4061 94.0652 94.511 94.5787 94.8266 95.9072 96.3213 96.8807 97.4484 97.7161 98.4588 98.8892 99.527 99.706 101.8778 107.7536 105.334
gen deflator = .
forval i=1/111 {
	scalar year_index = floor((`i'-1)/4)+1
	local current_deflator: word `i' of `cpi_deflator'
	scalar current_year = 1992 + year_index
	scalar q = (((((`i'-1)/4)-(floor((`i'-1)/4)+1))+1)*4)+1
	replace deflator = `current_deflator' if year==current_year & quarter == q 
}
local variables_to_deflate paygh paygw
foreach var of varlist `variables_to_deflate '{
qui gen `var'_deflated = `var'/(deflator/100)
rename `var' `var'_nd
label var `var'_nd "`var' not deflated by cpi"
rename `var'_deflated `var'
label var `var' "`var' deflated by cpi, 2018/19=100"
}

drop PAIDHRA deflator

* Social attutides
local occup_attitudes 39.54648 27.408551 33.405171 39.548972 42.15983 39.272229 37.943259 47.16253 41.893605
gen attitudes = .
forval i=1/9 {
	local current_attitude: word `i' of `occup_attitudes'
	replace attitudes = `current_attitude' if occup==`i' 
}

* Proportion of ethnicities in each occup
local ethnicities nonwhite black chinese asian mixed
foreach var of varlist `ethnicities' { //generating output
	//di `var'
	estpost tab occup `var'
	esttab . using Output\occup_pct_`var'.csv, cell(rowpct) unstack noobs varlabels(`e(labels)') csv compress nogaps longtable replace
}


local occup_pct_nonwhite 4.40655 8.463395 6.423292 5.641192 4.380624 7.38471 7.826699 5.88773 8.088537
local occup_pct_black 1.053928 2.028038 1.974768 1.690509 1.109215 3.288921 1.728071 1.362558 2.62533
local occup_pct_chinese .2881064 .6169634 .3671798 .2646114 .2792429 .2166742 .3669062 .0740047 .3444738
local occup_pct_asian 2.526471 4.96625 3.278727 3.09214 2.550031 3.201604 4.823011 4.059378 4.442979
local occup_pct_mixed .5380448 .8521426 .8026173 .5939313 .4421347 .6775112 .9087107 .3917898 .6757549
foreach var of varlist `ethnicities' { //adding output to each person
	gen occup_pct_`var' = .
	forval i=1/9 {
	local percent: word `i' of `occup_pct_`var''
	replace occup_pct_`var' = `percent' if occup==`i' 
}
}

* Unemp Rates
sort time region female
//merge 1:m varlist using filename [, options]
merge m:1 time region female using "regional_unemp.dta"
sort year quarter
drop if _merge==2
drop _merge E-AC

/*
Unemp Rates MALE
local neast_m 15.632 16.157 16.343 15.84 16.446 18.17 16.559 16.431 16.091 14.766 16.253 15.222 15.35 14.472 13.564 13.504 12.159 13.127 12.064 11.843 11.598 10.145 10.635 10.029 9.943 10.016 11.498 10.866 11.15 11.39 9.775 10.393 10.749 10.974 9.073 8.954 8.683 8.045 8.634 8.776 7.861 7.747 8.818 8.376 7.151 7.798 7.327 6.492 6.876 6.322 7.652 6.515 7.643 7.314 8.105 7.402 6.988 8.181 7.699 8.294 7.478 7.277 6.324 6.947 7.831 9.277 9.283 9.989 12.309 11.608 11.233 11.187 11.233 9.789 11.204 11.038 10.99 13.114 11.943 12.741 12.127 11.462 10.697 10.391 10.68 11.362 10.139 10.52 9.544 9.164 7.605 7.844 9.434 9.648 8.483 8.135 8.339 6.709 7.801 7.028 6.973 5.502 6.032 5.401 4.462 4.937 5.186 5.847 5.675 6.323 7.606 7.482 5.981 9.236 7.863
local nwest_m 12.743 12.372 12.711 13.162 12.35 12.301 12.559 12.903 12.925 12.439 11.596 10.989 10.791 10.621 10.717 10.575 10.218 9.603 8.947 8.359 8.514 8.402 7.964 7.701 8.255 8.189 8.668 8.022 7.625 7.495 6.994 6.929 6.029 5.951 5.928 5.764 6.34 5.852 6.224 6.563 6.444 6.444 5.732 5.559 5.719 5.379 5.49 4.873 4.775 4.787 5.154 5.178 4.887 4.785 5.581 5.303 5.614 6.492 6.276 6.619 6.971 6.796 6.74 7.079 7.537 7.246 9.124 9.252 9.613 10.797 9.947 10.348 9.346 9.115 8.724 8.764 9.736 9.727 10.499 10.531 10.469 10.023 9.334 9.164 9.34 9.278 8.68 8.482 7.627 6.843 6.962 6.139 6.186 5.204 4.981 5.351 5.514 5.905 6.15 4.656 4.336 4.879 4.383 4.688 4.534 4.626 4.26 4.351 4.68 4.588 4.403 4.726 3.944 5.34 4.826
local ykhu_m 11.479 11.234 11.939 12.337 12.587 12.466 12.216 11.381 12.226 11.251 10.773 10.639 9.495 10.286 9.86 9.568 10.164 10.12 10.472 9.127 8.987 8.851 8.476 8.606 8.574 8.129 8.01 8.09 7.577 6.897 7.005 7.13 6.975 6.844 6.924 6.859 6.072 6.356 6.215 5.604 6.198 6.457 5.793 6.237 6.119 5.737 5.576 5.339 4.853 4.809 4.993 4.989 5.64 4.796 5.97 5.92 6.442 6.744 7.06 7.052 6.024 6.017 6.453 5.593 6.483 7.731 7.768 8.822 10.647 10.431 10.476 11.634 10.93 10.682 10.514 10.802 9.846 11.429 11.567 10.419 10.878 9.524 10.346 9.98 10.041 9.59 9.075 8.106 7.319 6.593 6.392 6.95 7.22 6.576 7.158 6.832 6.349 6.382 5.626 5.888 5.798 4.962 5.103 4.193 4.215 4.862 5.123 4.737 5.134 4.211 4.118 4.409 4.519 5.579 5.906
local emids_m 9.897 9.802 10.687 11.033 10.454 9.713 9.327 9.116 9.366 9.922 9.073 8.823 8.547 7.941 8.18 8.561 8.44 7.905 7.495 6.361 6.448 5.358 6.053 5.73 4.827 5.892 5.11 5.321 6.111 5.997 5.84 5.339 5.169 5.321 5.085 4.943 4.98 4.893 4.547 4.787 4.902 4.879 4.999 4.803 4.434 4.918 5.168 4.614 4.574 4.346 4.326 4.67 4.813 4.802 5.166 5.762 5.982 5.096 5.646 5.158 4.57 5.795 5.42 5.386 6.304 6.048 6.696 8.071 8.299 8.203 8.32 8.011 7.647 8.608 8.334 7.719 8.013 8.372 7.83 8.023 8.778 8.546 7.464 7.719 8.452 7.936 7.672 7.556 6.1 5.987 5.216 5.486 5.015 4.783 4.839 4.374 4.529 4.769 4.51 4.042 3.795 4.35 4.514 3.675 4.211 5.361 5.332 4.149 4.948 4.941 3.615 4.156 5.291 5.671 6.169
local wmids_m 12.84 12.807 14.144 14.815 13.556 13.568 13.731 12.541 11.639 10.757 10.318 10.082 10.335 10.295 9.913 10.409 10.933 9.618 8.793 7.969 7.642 8.08 7.065 6.599 6.349 6.965 7.305 7.871 7.778 6.599 7.023 6.515 6.49 6.312 6.946 6.286 6.423 6.499 6.382 6.244 6.038 6.235 5.954 6.546 6.403 6.551 6.115 5.989 6.239 5.325 5.416 5.139 4.845 5.208 5.832 5.568 5.824 6.524 7.171 6.992 7.064 6.681 6.363 6.884 7.573 7.709 8.935 10.623 12.743 12.381 11.32 11.441 9.995 9.58 10.713 11.117 9.349 9.612 9.92 9.264 9.05 9.39 9.636 9.849 10.707 10.01 9.498 8.618 8.641 7.893 6.826 7.106 6.102 6.216 5.894 5.837 5.974 5.378 6.282 6.12 6.241 5.421 4.772 4.717 4.316 5.362 6.08 5.928 4.593 3.912 4.862 4.715 4.673 5.292 6.156
local east_m 9.635 10.448 11.056 10.96 10.816 10.319 10.213 9.933 9.442 8.985 8.522 8.989 8.793 8.68 7.687 7.028 6.946 7.392 7.277 6.831 7.147 6.018 5.79 5.367 4.747 4.514 4.447 4.517 4.613 4.182 4.701 4.091 4.161 4.01 3.979 3.565 3.411 3.649 3.487 3.78 3.874 4.378 4.536 4.856 4.004 4.071 3.636 3.578 3.93 3.472 4.031 4.038 3.972 3.984 4.545 4.88 5.352 4.971 4.485 4.717 4.717 4.999 4.309 4.825 4.783 5.231 6.201 6.616 6.957 6.634 7.038 7.098 7.64 7.127 7.169 6.589 7.164 7.536 7.497 7.615 7.166 6.854 6.587 6.725 6.658 6.098 6.588 5.939 5.465 5.426 5.636 5.229 5.294 4.294 3.751 3.767 3.562 4.237 4.411 4.263 4.325 3.92 4.728 3.83 3.396 2.847 2.704 2.539 2.977 3.634 3.543 4.194 4.232 4.454 4.557
local lon_m 14.08 14.74 14.455 16.334 15.756 16.498 17.206 16.533 16.132 14.9 14.099 14.066 13.833 13.424 13.01 13.166 13.768 13.137 12.727 11.332 10.079 9.871 10.278 9.055 9.289 8.956 8.258 8.465 7.84 8.114 7.247 8.166 7.974 7.265 7.126 6.961 7.006 7.531 8.238 7.459 7.496 8.041 7.159 7.936 7.908 7.792 7.386 7.268 7.221 7.189 7.501 7.294 7.364 7.286 7.974 8.129 7.929 8.021 7.898 7.061 7.32 6.615 6.873 6.866 7.296 7.586 7.024 8.582 9.236 9.121 9.173 9.692 9.58 9.316 9.25 8.811 9.968 10.496 11.056 10.494 8.994 8.595 8.862 9.204 9.122 8.36 7.933 6.824 6.554 6.326 6.32 6.021 6.365 5.949 5.932 5.237 5.721 5.301 5.127 5.61 4.97 4.846 4.873 4.827 4.718 4.395 4.798 4.264 4.859 4.795 4.578 4.786 4.724 5.776 6.785
local seast_m 9.509 9.751 10.396 9.941 9.579 9.999 9.269 8.717 8.692 8.045 7.71 8.009 7.165 7.732 6.868 7.673 7.108 6.853 5.736 5.68 5.615 5.388 4.573 4.803 4.666 4.34 3.887 3.952 3.545 3.853 4.094 3.603 3.244 3.067 3.324 3.585 3.146 3.518 3.376 3.926 4.038 4.401 4.036 4.415 4.237 3.96 3.882 4.149 3.92 4.081 3.673 3.821 3.918 4.282 4.289 4.784 4.859 4.416 4.411 5.22 4.455 4.602 4.31 3.888 3.923 4.915 5.215 5.546 6.569 7.353 7.016 7.151 6.574 6.678 6.58 6.171 6.171 6.572 6.35 6.108 6.031 6.545 6.881 7.317 6.508 6.248 5.417 5.293 4.074 4.419 4.797 3.784 4.564 4.118 3.94 3.797 3.793 3.532 3.342 3.473 3.339 3.122 3.116 3.653 3.663 3.534 2.858 3.101 3.196 3.739 3.326 3.156 3.285 4.251 4.685
local swest_m 10.14 10.206 11.158 12.04 11.171 10.423 10.354 9.377 9.001 9.786 9.169 9.048 9.446 8.5 8.125 8.325 7.49 7.382 7.133 6.401 6.355 5.7 5.17 4.67 4.939 5.835 5.213 5.554 4.979 4.293 4.482 4.283 4.566 4.244 4.369 3.912 3.546 3.773 3.749 4.098 4.375 4.395 4.099 4.147 3.515 3.295 3.408 3.229 4.342 3.715 3.639 3.872 3.21 3.814 4.264 3.824 3.924 3.852 3.793 4.022 4.061 3.957 3.809 4.096 3.927 4.3 5.688 6.002 7.525 8.058 7.512 6.654 6.784 5.34 6.507 7.593 7.445 7.028 6.933 7.102 6.511 6.616 6.009 6.96 6.694 7.361 6.842 5.545 5.893 5.427 5.148 4.165 4.077 3.99 3.729 4.829 3.804 4.193 3.687 3.639 3.853 3.534 3.116 3.269 3.116 3.107 3.052 2.671 2.976 2.814 3.138 3.792 4.545 5.317 4.623
local eng_m .
local wal_m 11.933 12.359 12.578 13.017 13.3 12.023 12.141 11.633 11.262 11.67 11.532 10.726 10.125 9.985 9.443 10.214 10.446 10.273 9.979 9.819 9.677 8.517 7.985 8.13 7.676 8.219 8.246 8.667 9.232 8.738 8.483 7.805 6.87 7.634 7.381 7.082 7.514 6.518 6.207 6.152 6.219 5.907 5.678 6.047 5.878 5.724 5.879 5.157 3.716 5.525 4.441 5.176 5.391 5.896 6.139 5.631 6.755 5.847 5.774 5.699 6.111 4.876 4.785 5.481 5.407 7.799 8.644 9.741 9.51 10.042 10.021 11.32 10.428 10.124 9.824 9.499 10.891 12.121 10.495 9.755 8.884 8.612 8.98 8.942 8.321 8.188 7.872 8.292 7.845 7.844 7.284 8.131 6.62 8.173 6.095 5.199 4.499 6.112 5.487 5.694 4.733 4.644 4.436 4.896 4.323 4.63 4.662 5.183 5.028 3.906 2.695 3.032 2.769 5.357 4.49
local scot_m 10.926 11.92 13.246 12.338 11.911 11.499 11.333 11.374 11.616 10.884 10.407 9.873 10.233 10.593 10.476 11.04 10.297 10.432 10.508 9.937 9.958 9.632 8.507 8.922 8.436 8.563 9.328 8.367 8.58 8.411 8.287 8.45 8.267 7.014 6.871 6.797 7.22 7.797 8.127 8.279 7.124 7.347 6.672 6.72 5.863 6.973 6.833 6.701 7.093 6.286 6.413 6.164 6.101 6.095 5.624 5.816 6.265 5.528 5.68 5.006 4.651 5.34 5.086 5.27 4.47 5.183 6.079 7.107 8.039 7.898 9.076 9.987 9.884 9.5 9.228 9.28 9.089 9.576 9.144 8.487 9.114 9.178 8.519 8.27 7.952 7.761 7.823 6.982 7.217 7.204 6.792 6.51 6.635 6.602 6.533 7.306 6.034 5.373 5.192 4.517 4.255 4.675 5.363 4.755 4.676 4.479 4.165 3.604 4.461 4.276 3.393 4.247 5.015 5.073 5.546
local nire_m 15.455 15.38 15.372 15.747 16.031 15.675 15.374 15.459 15.539 15.007 14.548 14.052 14.389 13.809 13.026 12.354 13.564 12.01 11.445 10.817 10.383 10.943 10.604 10.551 8.528 8.821 7.768 8.42 8.594 8.16 7.557 7.491 7.94 6.356 6.666 7.443 7.264 7.236 7.008 7.413 6.37 6.56 6.323 5.633 5.907 7.08 8.685 7.076 6.219 6.674 6.185 5.891 5.778 5.337 5.655 5.569 5.197 5.618 4.769 4.618 3.879 4.299 4.801 5.705 5.011 5.735 7.405 7.957 8.342 9.702 7.871 9.46 9.131 9.208 10.37 9.221 8.941 9.085 9.283 8.729 9.863 9.196 10.191 10.631 10.008 9.296 9.302 9.523 8.703 7.594 6.309 7.498 7.871 6.97 6.425 6.852 7.477 7.555 6.786 7.003 7.281 5.14 4.957 4.264 5.108 4.898 4.747 3.184 3.511 2.958 2.548 2.622 2.794 4.167 3.856

local dates 21992 31992 41992 11993 21993 31993 41993 11994 21994 31994 41994 11995 21995 31995 41995 11996 21996 31996 41996 11997 21997 31997 41997 11998 21998 31998 41998 11999 21999 31999 41999 12000 22000 32000 42000 12001 22001 32001 42001 12002 22002 32002 42002 12003 22003 32003 42003 12004 22004 32004 42004 12005 22005 32005 42005 12006 22006 32006 42006 12007 22007 32007 42007 12008 22008 32008 42008 12009 22009 32009 42009 12010 22010 32010 42010 12011 22011 32011 42011 12012 22012 32012 42012 12013 22013 32013 42013 12014 22014 32014 42014 12015 22015 32015 42015 12016 22016 32016 42016 12017 22017 32017 42017 12018 22018 32018 42018 12019 22019 32019 42019 12020 22020 32020 42020
local regions neast_m nwest_m ykhu_m emids_m wmids_m east_m lon_m seast_m swest_m wal_m scot_m nire_m
local numbers 1	2 4 5 6 7 8 9 10 11 12 13

gen regional_u = .
forval i=1/115 {
	local current_date: word `i' of `dates'
	di `current_date'
	forval j=1/12{
		local region_number: word `j' of `numbers'
		di `region_number'
		local current_region: word `j' of `regions'
		local current_u: word `i' of ``current_region''
		di `current_u'
		replace regional_u = `current_u' if time==`current_date' & region==`region_number' & female==0
	}
}
drop regional_u
*/


* Gen log vars
gen lwage = log(paygh)
replace lwage=. if lwage<0
gen lwwage=log(paygw)

label variable lwage "Log of gross hourly wages"
label variable lwwage "Log of gross weekly wages"

**********

//I need to merge this into one variable which is categorical. So GCSEs ONLY, A Levels but no degree, degree, and nothing. Will be interesting to see how many missing values there are.

*Degree subject - not sure if it's necessary
//Use SNGDEGB and SNGDEG (2011-Q4) and subjct1 (1997-Q1) BUT NO DEGREE SUBJECT IN 1997-Q2

**********
//No SIC codes for 1993
//NET has been removed as only in 2015 upwards
//need to merge the Benefits (BENFTS and CLAIMS14) ones - chanegs around 2014
//All benefits vars (BENFTS benefits UNEMBN1 jsatyp JSA) have been removed as I will use the ILO definition of unemployment instead
//Religion has been removed. We had RELIG11 (2020-2011) and RELIG (2002-2010) but IREND2 is the only religion var for pre-2002 and it's only asked to NI people and includes christian denoms only
//No 2001-Q1 data included at all, as missing key ethnicity.PIWT info - BUT if PIWT isn't necessary then we could possibly use the 'cryox' variable to get the ethnicity data
//education subjects SNGDEGB and SNGDEG (2011-Q4) and subjct1 (1997-Q1) BUT NO DEGREE SUBJECT IN 1997-Q2
//No degree or highest qualification information for 2004-Q1
//Smaller sample in 1993/1994/1995 as many gave 'does not apply' to qual0,qual1,qual2, so limited info on this
//use STUCUR/cured if want to find students - but not needed as unemp is used
//Not allowed to use data on number of children before 1995, because of data errors
//NUMAL doesn't exist for 1993-Q1.
//NUMOL uses 4+ instead of 5+ for 1993, so I removed this.
//Might want to consider removing 2004-Q1 and 2005-Q1 as there is no GCSE data, so I have to use NVQ Level 2 upwards (which is 4/5 GCSEs, so not conisistent) - a lot of missing data too because 2005-Q1 is when the LFS moved from seasonal to calendar quarters. Same for 1994-Q1 I believe.

**********Education notes
//Removing all this, as I'm not sure it's need - will use 'edage' instead!
//merge GCSEFUL1, GCSEFUL2 and NUMOL5 (2005-Q1/2) - use 2005-Q2 to compare as it includes both! Most also include both! - NOTE THAT 2005-Q1 MISSES NUMOL
//need to merge number of OLevel/GCSE passes (NUMOL) and NUMOL5 (changed in 2003)
//So use NUMOL (compare from NUMOL, NUMOL4 and NUMOL5, and then use GCSEFUL to estimate/bodge it for 2005)
//Note that 2005-Q1 is MISSING NUMOL (along with GCSEFUL1 GCSEFUL2, which I think are redundant anyway)
//Note that LEVQUAL* was not included before 2001 - the closest alternative is the nvqlev variable which I think is useless - doesn't even exist for 1993-Q1 and before
//need to merge LEVWQUL and LEVQUAL for each suffix
//need to use 'qual0 qual1 qual2' to determine if a person has taken A-Levels

//drop GCSEFUL1 GCSEFUL2 cured STUCUR hiquald NUMOL* 
drop ogemplen nvqlev numchu2 numch2t4 numch5t9 numch10t15 numchu19 subjct1 ALev2p
//drop UNDEMP SINCOM SNGDEG SNGDEGB GCSEs5 ALev1 deg

*********Sample restriction
//drop if white==0 & black==0 & chinese==0 & asian==0 & mixed==0
replace industry=. if industry<0
replace occup=. if occup<0 //need to move this to the Data Cleaning one

gen exper2=exper^2
label variable exper2 "Experience squared"
gen age2=age^2
label variable age2 "Age squared"
//drop if paygw==.
drop if female==.

drop if emplen==.

drop if edage==.
drop if age<16 | age>64

drop if region==13 //dropping NI - need to sort labels as there's some discrepancy

drop if unemp==1

drop unemp
drop if empstat==5 //only one has wage data
rename numchu16 children
drop empstat
drop ILODEFR

*********Sample restriction 2
table year ethnic, contents(p50 paygh) //median
drop if year<=1996
//keep if year>1997 //as missing 70% of 1993 education data, specific varibles and just general missing values. OR I could use 'edage' as a proxy and then include 1993!
*keep if wave==5 (as they ask income data in wave 5 too and this is used for the weighing)

drop FTPTWK paygw_nd INECACR wave STUCUR NUMOL NUMOLi UNDEMP SINCOM SNGDEG bushr hiquald GCSEFUL1 GCSEFUL2 LEVQUALI NUMOL4 NUMOLI INECAC05 LEVQUAL5 NUMOL5 LEVQUAL6 LEVQUAL8 LEVQUAL LEVQUL11 SNGDEGB LEVQUL15 incweight deg age age2 ALev1 GCSEs5 paygh_nd paygw occup_pct_nonwhite occup_pct_black occup_pct_chinese occup_pct_asian occup_pct_mixed lwwage cured edage

replace children=. if children==-9
replace exper=. if exper<0

sa "Output\LFS_Finished_Data.dta", replace
*********Useful extra commands
*destring LFSID, generate(ID) //making a new ID variable which is numeric
*bysort LFSID: egen COUNTRY=mode(country)  //creating a ner var which is the mode of others

*********RUBBISH/JUNK, old code
//rename ILODEFR empstat //ILO employment status  - I make a new var combining 2 others.
//rename MARDY6 married //marrital status (NOTE NOT BINARY VAR AS NEED TO RECODE) - use MARSTA for more detailed information
//rename EMPLEN emplen //length of time (grouped) with current employed
//rename ETHEWEUL ethnicity16 //ethnicity in 16 groups
//rename ETHGBEUL ethnicity11 //ethnicity in 11 groups
//rename ETHUKEUL ethnicity9 //ethnicity in 9 groups
//rename RELIG11 relig //religion
//rename HIQUAL15 highqual //highest qualification (many options) - HIGQUAL* WAS USED FROM 2020 TO 2004-Q2 but in 2004-Q1 this variable isn't included
// LEVQUL15 highquallevl //highest level of qualification
*rename BENTYP1 UC //universal credit (NOTE NOT BINARY VAR AS NEED TO RECODE)
//rename BENTYP5 JSA //Jobseeker's Allowance (NOTE NOT BINARY VAR AS NEED TO RECODE) 
//rename CLAIMS14 benefits //different types of benefits (includes both UC and JSA)
//rename COUNTRY country //country within the UK  ommited as not included for 2000-Q2 and prior
//rename CONTUK livedUK //whether lived in the UK continuously - ommited as not included for 2007-Q4 and prior
//rename QUAL_1 degree //Whether recieved a degree-level qualification - a binary var :)
*rename DEGCLS7 degclass //class of first degree (1st, 2:1 etc) - ommited as not included for 2005-Q3 and prior
//rename SNGDEGB degsubject //subject of first degree (grouped)
*Not sure which var this was replacing - probably need to delete this as the var itself was deleted
//rename allstudent //whether currently in educ/training or not (NOTE NOT BINARY VAR AS NEED TO RECODE) 
//rename STUCUR FTstudent //whether a full time student (NOTE NOT BINARY VAR AS NEED TO RECODE)
//rename NETWK netweek //net weekly pay - NOT SURE THIS IS WHAT I THINK IT IS - LOTS OF BLANKS
//rename NUMAL numAL //number of A Levels
//rename NUMOL5 GCSEs //number of GCSEs (not much detail, more details below)
*rename NUMOL5F GCSEa5 //number of GCSE passes if above 5 - ommited as not included for 2005-Q2 and prior
*rename NUMOL5O GCSEb5 //number of GCSE passes if less than 5 need to merge these 3 vars - ommited as not included for 2005-Q2 and prior
//rename UNDEMP undemp //whether would like to work longer hours at current pay (under-employment) (NOTE NOT BINARY VAR AS NEED TO RECODE)
