// Created: 11-1-21
// Modified: 11-24-21
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Cleaning and saving the screener data as a .dta file
// Notes:
// 1. Drop ineligible subjects, the test response (participantpublicid == "vxdvdjgk"), and responses prior to October 18, 2021.

clear
cd "T:\Wellcome\Aim 3\Full launch"
import excel "Data\Raw data\Data including excluded participants\data_exp_30957-v53_questionnaire-ttwy", firstrow case(lower)
drop if eventindex == "END OF FILE" | inlist(branch21mx,"AgeFail","") | inlist(branchesc2,"MeatFail","") | inlist(branchjeq8,"ShopFail","")
keep utcdate participantpublicid randomiserd68h questionkey response

// Drop the test response and responses prior to 00:00 EDT, October 18, 2021, i.e. prior to 04:00 UTC, October 18, 2021

drop if participantpublicid == "vxdvdjgk"
generate double utcdate_new = clock(utcdate,"DMYhms")
drop if Cofc(utcdate_new) < Cmdyhms(10,18,2021,4,0,0)
drop utcdate*

// Reshape wide

tabulate questionkey, missing
drop if inlist(questionkey,"BEGIN QUESTIONNAIRE","END QUESTIONNAIRE","")
drop if strpos(questionkey,"quantised") > 0
replace questionkey = subinstr(questionkey,"-","_",.)
reshape wide response, i(participantpublicid) j(questionkey) string
rename response* *
foreach var in gender grocery meat online_shop {
	encode `var', generate(`var'_new) label(`var'_default)
	drop `var'
	label list `var'_default
}
rename *_new *

// Rearrange value labels and label variables

tabulate gender
recode gender (4 = 1 "Woman") (1 = 2 "Man") (2 = 3 "Non-binary") (3 = 4 "Self-described"), generate(gender_new) label(gender)
tabulate gender gender_new
recode grocery (1 = 1 "About half") (3 = 2 "More than half") (2 = 3 "All"), generate(grocery_new) label(grocery)
tabulate grocery grocery_new
recode meat (2 = 1 "1/week") (4 = 2 "2-3/week") (6 = 3 "4-6/week") (1 = 4 "1/day") (3 = 5 "2/day") (5 = 6 ">2/day"), generate(meat_new) label(meat)
tabulate meat meat_new
recode online_shop (5 = 1 "None") (3 = 2 "Less than half") (1 = 3 "About half") (4 = 4 "More than half") (2 = 5 "All"), generate(online_shop_new) label(online_shop)
tabulate online_shop online_shop_new
foreach var in gender grocery meat online_shop {
	drop `var'
	label drop `var'_default
}
rename *_new *

// Compute descriptives to spot potential entry or coding errors

replace age = "86" if age == "86 yrs old"
destring age, replace
summarize age, detail // Two invalid values (1952, 2002), presumably birth years
tab1 gender gender_text grocery meat online_shop // All look correct

// Corrections

replace age = 2021 - age if inlist(age,1952,2002)

// Save

save "Data\Processed data\screener", replace

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
// 1-14-22	MB			Recompiled the data to include dropouts.
// -----------------------------------------------------------------------------