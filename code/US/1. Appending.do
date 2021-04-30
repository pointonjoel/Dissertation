***************************1. IMPORT, REFINE & ANALYSE**************************

clear all
set more off

cd "C:\Users\point\OneDrive\Documents\Standard Files\University\Stage 3\EC541\Data\understanding society\US\All\UKDA-6614-stata\" // replace with your directory
*************for help with any file simply type help "command name"*************

******************************BHPS******************************
use pidp ba_hidp ba_age ba_sex ba_paygl ba_paygw ba_paynl ba_paynw ba_hiqual_dv ba_jbhrs ba_race ba_yr2uk4 ba_jbsic ba_jbbgy ba_feend ba_mastat ba_nchild_dv ba_jbseg_dv ba_gor_dv ba_jbstatt ba_jbft_dv ba_hllt using "stata\stata13_se\bhps_w1\ba_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix ba_ // removes the prefix ba_ from each variable
gen istrtdaty = 1991
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_1.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bb_hidp bb_age bb_sex bb_paygl bb_paygw bb_paynl bb_paynw bb_hiqual_dv bb_jbhrs bb_race bb_yr2uk4 bb_jbsic bb_jbbgy bb_feend bb_mastat bb_nchild_dv bb_jbseg_dv bb_gor_dv bb_jbstatt bb_jbft_dv bb_hllt using "stata\stata13_se\bhps_w2\bb_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bb_ // removes the prefix bb_ from each variable
gen istrtdaty = 1992
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_2.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bc_hidp bc_age bc_sex bc_paygl bc_paygw bc_paynl bc_paynw bc_hiqual_dv bc_jbhrs bc_race bc_yr2uk4 bc_jbsic bc_jbbgy bc_feend bc_mastat bc_nchild_dv bc_jbseg_dv bc_gor_dv bc_jbstatt bc_jbft_dv bc_hllt using "stata\stata13_se\bhps_w3\bc_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bc_ // removes the prefix bc_ from each variable
gen istrtdaty = 1993
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_3.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bd_hidp bd_age bd_sex bd_paygl bd_paygw bd_paynl bd_paynw bd_hiqual_dv bd_jbhrs bd_race bd_yr2uk4 bd_jbsic bd_jbbgy bd_feend bd_mastat bd_nchild_dv bd_jbseg_dv bd_gor_dv bd_jbstatt bd_jbft_dv bd_hllt using "stata\stata13_se\bhps_w4\bd_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bd_ // removes the prefix bd_ from each variable
gen istrtdaty = 1994
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_4.dta", replace // saves data in stata format. save to a location on your own drive

use pidp be_hidp be_age be_sex be_paygl be_paygw be_paynl be_paynw be_hiqual_dv be_jbhrs be_race be_yr2uk4 be_jbsic be_jbbgy be_feend be_mastat be_nchild_dv be_jbseg_dv be_gor_dv be_jbstatt be_jbft_dv be_hllt using "stata\stata13_se\bhps_w5\be_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix be_ // removes the prefix be_ from each variable
gen istrtdaty = 1995
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_5.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bf_hidp bf_age bf_sex bf_paygl bf_paygw bf_paynl bf_paynw bf_hiqual_dv bf_jbhrs bf_race bf_yr2uk4 bf_jbsic bf_jbbgy bf_feend bf_mastat bf_nchild_dv bf_jbseg_dv bf_gor_dv bf_jbstatt bf_jbft_dv bf_hllt using "stata\stata13_se\bhps_w6\bf_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bf_ // removes the prefix bf_ from each variable
gen istrtdaty = 1996
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_6.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bg_hidp bg_age bg_sex bg_paygl bg_paygw bg_paynl bg_paynw bg_hiqual_dv bg_jbhrs bg_race bg_yr2uk4 bg_jbsic bg_jbbgy bg_feend bg_mastat bg_nchild_dv bg_jbseg_dv bg_gor_dv bg_jbstatt bg_jbft_dv bg_hllt using "stata\stata13_se\bhps_w7\bg_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bg_ // removes the prefix bg_ from each variable
gen istrtdaty = 1997
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_7.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bh_hidp bh_age bh_sex bh_paygl bh_paygw bh_paynl bh_paynw bh_hiqual_dv bh_jbhrs bh_race bh_yr2uk4 bh_jbsic bh_jbbgy bh_feend bh_mastat bh_nchild_dv bh_jbseg_dv bh_gor_dv bh_jbstatt bh_jbft_dv bh_hllt using "stata\stata13_se\bhps_w8\bh_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bh_ // removes the prefix bh_ from each variable
gen istrtdaty = 1998
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_8.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bi_hidp bi_age bi_sex bi_paygl bi_paygw bi_paynl bi_paynw bi_hiqual_dv bi_jbhrs bi_race bi_yr2uk4 bi_jbsic bi_jbbgy bi_feend bi_mastat bi_nchild_dv bi_jbseg_dv bi_gor_dv bi_jbstatt bi_jbft_dv bi_hlsf4d using "stata\stata13_se\bhps_w9\bi_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bi_ // removes the prefix bi_ from each variable
gen istrtdaty = 1999
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_9.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bj_hidp bj_age bj_sex bj_paygl bj_paygw bj_paynl bj_paynw bj_hiqual_dv bj_jbhrs bj_race bj_yr2uk4 bj_jbsic bj_jbbgy bj_feend bj_mastat bj_nchild_dv bj_jbseg_dv bj_gor_dv bj_jbstatt bj_jbft_dv bj_hllt using "stata\stata13_se\bhps_w10\bj_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bj_ // removes the prefix bj_ from each variable
gen istrtdaty = 2000
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_10.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bk_hidp bk_age bk_sex bk_paygl bk_paygw bk_paynl bk_paynw bk_hiqual_dv bk_jbhrs bk_race bk_yr2uk4 bk_jbsic92 bk_jbbgy bk_feend bk_mastat bk_nchild_dv bk_jbseg_dv bk_gor_dv bk_jbstatt bk_jbft_dv bk_hllt using "stata\stata13_se\bhps_w11\bk_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bk_ // removes the prefix bk_ from each variable
gen istrtdaty = 2001
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_11.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bl_hidp bl_age bl_sex bl_paygl bl_paygw bl_paynl bl_paynw bl_hiqual_dv bl_jbhrs bl_race bl_yr2uk4 bl_jbsic92 bl_jbbgy bl_feend bl_mastat bl_nchild_dv bl_jbseg_dv bl_gor_dv bl_jbstatt bl_jbft_dv bl_hllt using "stata\stata13_se\bhps_w12\bl_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bl_ // removes the prefix bl_ from each variable
gen istrtdaty = 2002
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_12.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bm_hidp bm_age bm_sex bm_paygl bm_paygw bm_paynl bm_paynw bm_hiqual_dv bm_jbhrs bm_race bm_yr2uk4 bm_jbsic92 bm_jbbgy bm_feend bm_mastat bm_nchild_dv bm_jbseg_dv bm_gor_dv bm_jbstatt bm_jbft_dv bm_hllt using "stata\stata13_se\bhps_w13\bm_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bm_ // removes the prefix bm_ from each variable
gen istrtdaty = 2003
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic92 jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_13.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bn_hidp bn_age bn_sex bn_paygl bn_paygw bn_paynl bn_paynw bn_hiqual_dv bn_jbhrs bn_race bn_yr2uk4 bn_jbsic92 bn_jbbgy bn_feend bn_mastat bn_nchild_dv bn_jbseg_dv bn_gor_dv bn_jbstatt bn_jbft_dv bn_hlsf4d using "stata\stata13_se\bhps_w14\bn_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bn_ // removes the prefix bn_ from each variable
gen istrtdaty = 2004
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic92 jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_14.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bo_hidp bo_age bo_sex bo_paygl bo_paygw bo_paynl bo_paynw bo_hiqual_dv bo_jbhrs bo_race bo_yr2uk4 bo_jbsic92 bo_jbbgy bo_feend bo_mastat bo_nchild_dv bo_jbseg_dv bo_gor_dv bo_jbstatt bo_jbft_dv bo_hllt using "stata\stata13_se\bhps_w15\bo_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bo_ // removes the prefix bo_ from each variable
gen istrtdaty = 2005
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic92 jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_15.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bp_hidp bp_age bp_sex bp_paygl bp_paygw bp_paynl bp_paynw bp_hiqual_dv bp_jbhrs bp_race bp_yr2uk4 bp_jbsic92 bp_jbbgy bp_feend bp_mastat bp_nchild_dv bp_jbseg_dv bp_gor_dv bp_jbstatt bp_jbft_dv bp_hllt using "stata\stata13_se\bhps_w16\bp_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bp_ // removes the prefix bp_ from each variable
gen istrtdaty = 2006
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic92 jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_16.dta", replace // saves data in stata format. save to a location on your own drive

use pidp bq_hidp bq_age bq_sex bq_paygl bq_paygw bq_paynl bq_paynw bq_hiqual_dv bq_jbhrs bq_race bq_yr2uk4 bq_jbsic92 bq_jbbgy bq_feend bq_mastat bq_nchild_dv bq_jbseg_dv bq_gor_dv bq_jbstatt bq_jbft_dv bq_hllt using "stata\stata13_se\bhps_w17\bq_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix bq_ // removes the prefix bq_ from each variable
gen istrtdaty = 2007
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic92 jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_17.dta", replace // saves data in stata format. save to a location on your own drive

use pidp br_hidp br_age br_sex br_paygl br_paygw br_paynl br_paynw br_hiqual_dv br_jbhrs br_race br_yr2uk4 br_jbsic92 br_jbbgy br_feend br_mastat br_nchild_dv br_jbseg_dv br_gor_dv br_jbstatt br_jbft_dv br_hllt using "stata\stata13_se\bhps_w18\br_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix br_ // removes the prefix br_ from each variable
gen istrtdaty = 2008
//keep pidp hidp age istrtdaty sex paygl paygw paynl paynw hiqual_dv jbhrs race yr2uk4 jbsic92 jbbgy feend mastat nchild_dv jbseg_dv jbstatt
sort pidp istrtdaty
sa "Output\BHPS_18.dta", replace // saves data in stata format. save to a location on your own drive

****************************US****************************
use pidp a_hidp a_dvage a_istrtdaty a_sex a_paygl a_paygwc a_paynl a_paynwc a_hiqual_dv a_jbhrs a_racel a_yr2uk4 a_jbsic07_cc a_jbbgy a_feend a_marstat a_nchild_dv a_jbseg_dv a_gor_dv a_jbstat a_jbft_dv a_disdif12 a_britid a_jbsoc00_cc using "stata\stata13_se\ukhls_w1\a_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix a_ // removes the prefix a_ from each variable
//keep pidp hidp dvage istrtdaty sex paygl paygwc paynl paynwc hiqual_dv jbhrs racel yr2uk4 jbsic07_cc jbbgy feend marstat nchild_dv jbseg_dv jbstat
replace istrtdaty = 2009
sort pidp istrtdaty
sa "Output\US_1.dta", replace // saves data in stata format. save to a location on your own drive

use pidp b_hidp b_dvage b_istrtdaty b_sex b_paygl b_paygwc b_paynl b_paynwc b_hiqual_dv b_jbhrs b_racel b_yr2uk4 b_jbsic07_cc b_jbbgy b_feend b_marstat b_nchild_dv b_jbseg_dv b_gor_dv b_jbstat b_jbft_dv b_disdif12 using "stata\stata13_se\ukhls_w2\b_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix b_ // removes the prefix b_ from each variable
//keep pidp hidp dvage istrtdaty sex paygl paygwc paynl paynwc hiqual_dv jbhrs racel yr2uk4 jbsic07_cc jbbgy feend marstat nchild_dv jbseg_dv jbstat
replace istrtdaty = 2010
sort pidp istrtdaty
sa "Output\US_2.dta", replace // saves data in stata format. save to a location on your own drive

use pidp c_hidp c_dvage c_istrtdaty c_sex c_paygl c_paygwc c_paynl c_paynwc c_hiqual_dv c_jbhrs c_racel c_yr2uk4 c_jbsic07_cc c_jbbgy c_feend c_marstat c_nchild_dv c_jbseg_dv c_gor_dv c_jbstat c_jbft_dv c_disdif12 c_resunsafe3_3 c_resavoid3_3 c_resinsulted3_3 c_resattacked3_3 c_resunsafe6_3 c_resavoid6_3 c_resinsulted6_3 c_resattacked6_3 c_resunsafe8_3 c_resavoid8_3 c_resinsulted8_3 c_resattacked8_3 c_britid c_jbsoc00_cc using "stata\stata13_se\ukhls_w3\c_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix c_ // removes the prefix c_ from each variable
//keep pidp hidp dvage istrtdaty sex paygl paygwc paynl paynwc hiqual_dv jbhrs racel yr2uk4 jbsic07_cc jbbgy feend marstat nchild_dv jbseg_dv jbstat
replace istrtdaty = 2011
sort pidp istrtdaty
sa "Output\US_3.dta", replace // saves data in stata format. save to a location on your own drive

use pidp d_hidp d_dvage d_istrtdaty d_sex d_paygl d_paygwc d_paynl d_paynwc d_hiqual_dv d_jbhrs d_racel d_yr2uk4 d_jbsic07_cc d_jbbgy d_feend d_marstat d_nchild_dv d_jbseg_dv d_gor_dv d_jbstat d_jbft_dv d_disdif12 using "stata\stata13_se\ukhls_w4\d_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix d_ // removes the prefix d_ from each variable
//keep pidp hidp dvage istrtdaty sex paygl paygwc paynl paynwc hiqual_dv jbhrs racel yr2uk4 jbsic07_cc jbbgy feend marstat nchild_dv jbseg_dv jbstat
replace istrtdaty = 2012
sort pidp istrtdaty
sa "Output\US_4.dta", replace // saves data in stata format. save to a location on your own drive

use pidp e_hidp e_dvage e_istrtdaty e_sex e_paygl e_paygwc e_paynl e_paynwc e_hiqual_dv e_jbhrs e_racel e_yr2uk4 e_jbsic07_cc e_jbbgy e_feend e_marstat e_nchild_dv e_jbseg_dv e_gor_dv e_jbstat e_jbft_dv e_disdif12 e_resunsafe3_3 e_resavoid3_3 e_resinsulted3_3 e_resattacked3_3 e_resunsafe6_3 e_resavoid6_3 e_resinsulted6_3 e_resattacked6_3 e_resunsafe8_3 e_resavoid8_3 e_resinsulted8_3 e_resattacked8_3 using "stata\stata13_se\ukhls_w5\e_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix e_ // removes the prefix e_ from each variable
//keep pidp hidp dvage istrtdaty sex paygl paygwc paynl paynwc hiqual_dv jbhrs racel yr2uk4 jbsic07_cc jbbgy feend marstat nchild_dv jbseg_dv jbstat
replace istrtdaty = 2013
sort pidp istrtdaty
sa "Output\US_5.dta", replace // saves data in stata format. save to a location on your own drive


use pidp f_hidp f_dvage f_istrtdaty f_sex f_paygl f_paygwc f_paynl f_paynwc f_hiqual_dv f_jbhrs f_racel f_yr2uk4 f_jbsic07_cc f_jbbgy f_feend f_marstat f_nchild_dv f_jbseg_dv f_gor_dv f_jbstat f_jbft_dv f_disdif12 f_britid f_jbsoc00_cc using "stata\stata13_se\ukhls_w6\f_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix f_ // removes the prefix f_ from each variable
//keep pidp hidp dvage istrtdaty sex paygl paygwc paynl paynwc hiqual_dv jbhrs racel yr2uk4 jbsic07_cc jbbgy feend marstat nchild_dv jbseg_dv jbstat
replace istrtdaty = 2014
sort pidp istrtdaty
sa "Output\US_6.dta", replace // saves data in stata format. save to a location on your own drive

use pidp g_hidp g_dvage g_istrtdaty g_sex g_paygl g_paygwc g_paynl g_paynwc g_hiqual_dv g_jbhrs g_racel g_yr2uk4 g_jbsic07_cc g_jbbgy g_feend g_marstat g_nchild_dv g_jbseg_dv g_gor_dv g_jbstat g_jbft_dv g_disdif12 g_resunsafe3_3 g_resavoid3_3 g_resinsulted3_3 g_resattacked3_3 g_resunsafe6_3 g_resavoid6_3 g_resinsulted6_3 g_resattacked6_3 g_resunsafe8_3 g_resavoid8_3 g_resinsulted8_3 g_resattacked8_3 using "stata\stata13_se\ukhls_w7\g_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix g_ // removes the prefix g_ from each variable
//keep pidp hidp dvage istrtdaty sex paygl paygwc paynl paynwc hiqual_dv jbhrs racel yr2uk4 jbsic07_cc jbbgy feend marstat nchild_dv jbseg_dv jbstat
replace istrtdaty = 2015
sort pidp istrtdaty
sa "Output\US_7.dta", replace // saves data in stata format. save to a location on your own drive

use pidp h_hidp h_dvage h_istrtdaty h_sex h_paygl h_paygwc h_paynl h_paynwc h_hiqual_dv h_jbhrs h_racel h_yr2uk4 h_jbsic07_cc h_jbbgy h_feend h_marstat h_nchild_dv h_jbseg_dv h_gor_dv h_jbstat h_jbft_dv h_disdif12 using "stata\stata13_se\ukhls_w8\h_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix h_ // removes the prefix h_ from each variable
//keep pidp hidp dvage istrtdaty sex paygl paygwc paynl paynwc hiqual_dv jbhrs racel yr2uk4 jbsic07_cc jbbgy feend marstat nchild_dv jbseg_dv jbstat
replace istrtdaty = 2016
sort pidp istrtdaty
sa "Output\US_8.dta", replace // saves data in stata format. save to a location on your own drive

use pidp i_hidp i_dvage i_istrtdaty i_sex i_paygl i_paygwc i_paynl i_paynwc i_hiqual_dv i_jbhrs i_racel i_yr2uk4 i_jbsic07_cc i_jbbgy i_feend i_marstat i_nchild_dv i_jbseg_dv i_gor_dv i_jbstat i_jbft_dv i_disdif12 i_resunsafe3_3 i_resavoid3_3 i_resinsulted3_3 i_resattacked3_3 i_resunsafe6_3 i_resavoid6_3 i_resinsulted6_3 i_resattacked6_3 i_resunsafe8_3 i_resavoid8_3 i_resinsulted8_3 i_resattacked8_3 using "stata\stata13_se\ukhls_w9\i_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix i_ // removes the prefix i_ from each variable
//keep pidp hidp dvage istrtdaty sex paygl paygwc paynl paynwc hiqual_dv jbhrs racel yr2uk4 jbsic07_cc jbbgy feend marstat nchild_dv jbseg_dv jbstat
replace istrtdaty = 2017
sort pidp istrtdaty
sa "Output\US_9.dta", replace // saves data in stata format. save to a location on your own drive

use pidp j_hidp j_dvage j_istrtdaty j_sex j_paygl j_paygwc j_paynl j_paynwc j_hiqual_dv j_jbhrs j_racel j_yr2uk4 j_jbsic07_cc j_jbbgy j_feend j_marstat j_nchild_dv j_jbseg_dv j_gor_dv j_jbstat j_jbft_dv j_disdif12 using "stata\stata13_se\ukhls_w10\j_indresp.dta"
sort pidp // sort by unique ID (choose appropriate id)
renpfix j_ // removes the prefix j_ from each variable
//keep pidp hidp dvage istrtdaty sex paygl paygwc paynl paynwc hiqual_dv jbhrs racel yr2uk4 jbsic07_cc jbbgy feend marstat nchild_dv jbseg_dv jbstat
replace istrtdaty = 2018 //is this correct?
sort pidp istrtdaty
sa "Output\US_10.dta", replace // saves data in stata format. save to a location on your own drive

******************************B.Combining Datasets******************************
clear all
set more off

use "Output\BHPS_1.dta"
merge pidp istrtdaty using "Output\BHPS_2.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_3.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_4.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_5.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_6.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_7.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_8.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_9.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_10.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_11.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_12.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_13.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_14.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_15.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_16.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_17.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\BHPS_18.dta" 
sort pidp istrtdaty
drop _merge

**************************************************US

merge pidp istrtdaty using "Output\US_1.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\US_2.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\US_3.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\US_4.dta" 
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\US_5.dta"
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\US_6.dta"
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\US_7.dta"
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\US_8.dta"
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\US_9.dta"
sort pidp istrtdaty
drop _merge

merge pidp istrtdaty using "Output\US_10.dta"
sort pidp istrtdaty
drop _merge

sa "Output\Merged_Data.dta", replace


***************************D.Manipulating Panel Data****************************

/*
*When using panel data it is important to tell Stata that the data is panel (or
*time series)
tsset wave /// tells stata the data is time-series and that tvar denotes time
tsset pidp wave /// tells stata the data is a panel and that pid* denotes the household while tvar denotes time.

*You may need to create your own time variable if you are merging datasets for 
*example. Here are some useful commands for doing so. EACH OF THESE COMMANDS 
*RELY ON THE DATA BEING SORTED IN THE RIGHT ORDER FIRST

*In Stata it is easy to create lead and lag variables once the data is in panel 
*or time-series format
sort pid* tvar /// sort panel data
gen dX=x-L.x /// dX is x minus its value in the previous period replace x with 
// variable of interest
gen Xp2=x-F2.x /// Xp2 is x minus its value two periods in the future

*/

/*
*It is also possible to add data as columns i.e. append to the side based on a 
*unique identifier. 
merge 1:1 pidp using "Output\US_2.dta" 
// one-to-one merging based on a unique observational identifier 
keep if _merge==3 // keep only those in each wave
drop _merge

merge 1:1 pidp using "Output\US_3.dta" 
// one-to-one merging based on a unique observational identifier 
keep if _merge==3 // keep only those in each wave
drop _merge

merge 1:1 pidp using "Output\US_4.dta" 
// one-to-one merging based on a unique observational identifier 
keep if _merge==3 // keep only those in each wave
drop _merge

merge 1:1 pidp using "Output\US_5.dta" 
// one-to-one merging based on a unique observational identifier 
keep if _merge==3 // keep only those in each wave
drop _merge
*/

/*
//sort pidp istrtdaty
append using "Output\US_2.dta" 
//sort pidp istrtdaty
// one-to-one merging based on a unique observational identifier 
//keep if _merge==3 // keep only those in each wave
//drop _merge

append using "Output\US_3.dta" 
//sort pidp istrtdaty
// one-to-one merging based on a unique observational identifier 
//keep if _merge==3 // keep only those in each wave
//drop _merge

append using "Output\US_4.dta" 
// sort pidp istrtdaty
// one-to-one merging based on a unique observational identifier 
//keep if _merge==3 // keep only those in each wave
//drop _merge

append using "Output\US_5.dta"
sort pidp istrtdaty
// one-to-one merging based on a unique observational identifier 
//keep if _merge==3 // keep only those in each wave
//drop _merge
*/