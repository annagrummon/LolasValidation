// Created: 11-17-21
// Modified: 1-13-22
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Moderaton analysis for the primary outcomes
// Notes:
// 1. Moderators included in the analysis plan: red meat consumption frequency, interest in health, interest in sustainability, income, education, age, race/ethnicity, political orientation, and gender
// 2. Categorize int_health and int_envt1 into original 5-point scale because of estimation issues with Poisson when treated as continuous
// 3. Wooldridge recommends against using the deviance and Pearson goodness-of-fit tests for diagnostics as they assume negative binomial as the null model [1]
// 4. Tests of significance for interactions have an intuitive interpretation in the Poisson model but not in the fractional regression case

clear
cd "T:\Wellcome\Aim 3\Full launch"
do "Do files\Programs"
use "Data\Processed data\merged data"
keep id arm redmeat quantity age gender meat grocery online_shop ethnicity* race_* education income political int_*
generate frac_rm = redmeat / quantity

// 1 Cell sizes per arm

egen rownonmiss = rownonmiss(race_*), strok // Number of races selected (including 'Race not listed' and self-described race)
recode race_1 race_2 race_3 race_4 race_5 (. = 2) if rownonmiss > 0 // Missing values mean 'No' unless no options selected
drop rownonmiss

foreach v in meat income education race_1 race_2 race_3 race_4 race_5 ethnicity political gender {
	tabulate `v' arm
}

clonevar meat5 = meat
recode meat5 (6 = 5)
label copy meat meat5
label define meat5 5 "2/day or more" 6 "", modify
label values meat5 meat5

recode income (1 2 = 1 "< $15,000") (3 = 2 "$15,000-$24,999") (4 = 3 "$25,000-$34,999") (5 = 4 "$35,000-$49,999") (6 = 5 "$50,000-$74,999") (7 = 6 "$75,000-$99,999") (8 = 7 "$100,000-$149,999") (9 10 = 8 "> $149,999"), generate(inc8) label(inc8)
label variable inc8 "Household income in the last 12 months"

recode education (1 2 = 1 "High school diploma or less") (3 = 2 "Associate or technical degree") (4 = 3 "4-year college degree") (5 = 4 "Graduate degree"), generate(educ4) label(educ4)
label variable educ4 "Education level"

recode ethnicity (1 = 2) (2 3 4 = 1), generate(hisp)
label variable hisp "Of Hispanic, Latino, or Spanish origin"

foreach v in int_health int_envt1 {
	egen `v'_cat = cut(`v'), at(1,2,3,4,5,6) // Add 6 otherwise 5 goes to missing
	tabulate `v'_cat arm
}
recode int_health_cat (2 = 1) (3 = 2) (4 = 3) (5 = 4) // Too few subjects per arm with int_health_cat = 1
recode int_envt1_cat (5 = 4) // Too few subjects per arm with int_envt1_cat = 5

summarize age
local min = r(min)
local max = r(max) + 1
egen agecat = cut(age), at(`min' 30 40 50 60 70 `max') icodes
tabulate agecat arm
replace agecat = agecat + 1
label define agecat 1 "18-29" 2 "30-39" 3 "40-49" 4 "50-59" 5 "60-69" 6 "70 or over"
label values agecat agecat
label variable agecat "Age category"

// 2 Count of red meat items

// 2.1 Red meat consumption

glm redmeat arm##meat5, family(poisson) vce(robust)
res // Residual diagnostics (see Programs.do for details)
testparm arm#meat5
margins, dydx(arm) over(meat5) post
marginsplot, ylabel(-2(1)2) xlabel(.) xtitle("Red meat consumption (lowest to highest)") legend(order(4 "WL" 5 "T" 6 "WLT") row(1)) name(meatPOIS, replace)
contrast meat5, atequations
pwcompare meat5, atequations effects

// 2.2 Interest in health

glm redmeat arm##int_health_cat, family(poisson) vce(robust)
res
testparm arm#int_health_cat
margins, dydx(arm) over(int_health_cat) post
marginsplot, xlabel(.) xtitle("Interest in health (lowest to highest)") legend(order(4 "WL" 5 "T" 6 "WLT") row(1)) name(healthPOIS, replace)
contrast int_health_cat, atequations

// 2.3 Interest in sustainability

glm redmeat arm##int_envt1_cat, family(poisson) vce(robust)
res
testparm arm#int_envt1_cat
margins, dydx(arm) over(int_envt1_cat) post
marginsplot, xlabel(.) xtitle("Interest in sustainability (lowest to highest)") legend(order(4 "WL" 5 "T" 6 "WLT") row(1)) name(sustPOIS, replace)
contrast int_envt1_cat, atequations

// 2.4 Income

glm redmeat arm##inc8, family(poisson) vce(robust)
res
testparm arm#inc8
margins, dydx(arm) over(inc8) post
marginsplot, xlabel(.) xtitle("Annual household income (lowest to highest)") legend(order(4 "WL" 5 "T" 6 "WLT") row(1)) name(incPOIS, replace)
contrast income, atequations

// 2.5 Education

glm redmeat arm##educ4, family(poisson) vce(robust)
res
testparm arm#educ4
margins, dydx(arm) over(educ4) post
marginsplot, xlabel(.) xtitle("Education level (lowest to highest)") legend(order(4 "WL" 5 "T" 6 "WLT") row(1)) name(educPOIS, replace)
contrast educ4, atequations
pwcompare educ4, atequations effects

// 2.6 Age

glm redmeat arm##agecat, family(poisson) vce(robust)
res
testparm arm#agecat
margins, dydx(arm) over(agecat) post
marginsplot, ylabel(-2(1)2) xlabel(.) xtitle("Cohort (youngest to oldest)") legend(order(4 "WL" 5 "T" 6 "WLT") row(1)) name(agePOIS, replace)
contrast agecat, atequations
pwcompare agecat, atequations effects

// 2.7 Race

foreach v in race_1 race_2 race_4 { // Exclude American Indian or Alaskan Native and Pacific Islander because too few subjects per arm
    glm redmeat arm##`v', family(poisson) vce(robust)
	res
	testparm arm#`v'
	margins, dydx(arm) over(`v') post
	marginsplot, xlabel(.) xtitle("`: variable label `v'' (no left, yes right)") legend(order(4 "WL" 5 "T" 6 "WLT") row(1)) name(`v'POIS, replace)
	contrast `v', atequations
}

// 2.8 Ethnicity

glm redmeat arm##hisp, family(poisson) vce(robust)
res
testparm arm#hisp
margins, dydx(arm) over(hisp) post
marginsplot, ylabel(-2(1)2) xlabel(.) xtitle("Of Hispanic, Latino, or Spanish origin (no left, yes right)") legend(order(4 "WL" 5 "T" 6 "WLT") row(1)) name(hispPOIS, replace)
contrast hisp, atequations

// 2.9 Political orientation

glm redmeat arm##political, family(poisson) vce(robust)
res
testparm arm#political
margins, dydx(arm) over(political) post
marginsplot, ylabel(-2(1)2) xlabel(.) xtitle("Political orientation (liberal, moderate, conservative)") legend(order(4 "WL" 5 "T" 6 "WLT") row(1)) name(politicalPOIS, replace)
contrast political, atequations

// 2.10 Gender

glm redmeat arm##gender if gender < 3, family(poisson) vce(robust) // Exclude non-binary and self-described as cell sizes are too small for moderation analysis
res
testparm arm#gender // P = .4
margins, dydx(arm) over(gender) post
marginsplot, ylabel(-2(1)2) xlabel(.) xtitle("Gender (women left, men right)") legend(order(4 "WL" 5 "T" 6 "WLT") row(1)) name(genderPOIS, replace)
contrast gender, atequations

// 2.11 Putting it all in a table
// See Project notebook for the table shell and Programs.do for details on the modtable command

label variable int_health_cat "Interest in health"
label variable int_envt1_cat "Interest in sustainability"
label variable educ4 "Education level"
label define yesno 1 "Yes" 2 "No", replace
label values race_1 race_2 race_4 hisp yesno
clonevar gender2 = gender if gender < 3
label define int 1 "Low" 2 "Moderately low" 3 "Moderately high" 4 "High"
label values int_health_cat int
label values int_envt1_cat int

modtable redmeat meat5 int_health_cat int_envt1_cat inc8 educ4 agecat race_1 race_2 race_4 hisp political gender2, ///
	putexcelcmd(`"putexcel set Results\Moderation, sheet("Count (Poisson)", replace) modify"') ///
	model(glm) ///
	modelopts(`"family(poisson) vce(robust)"') ///
	intertest

modtable redmeat meat5 int_health_cat int_envt1_cat inc8 educ4 agecat race_1 race_2 race_4 hisp political gender2, ///
	putexcelcmd(`"putexcel set Results\Moderation, sheet("Count (OLS)", replace) modify"') ///
	model(regress)

// 3 Fraction of red meat items

modtable frac_rm meat5 int_health_cat int_envt1_cat inc8 educ4 agecat race_1 race_2 race_4 hisp political gender2, ///
	putexcelcmd(`"putexcel set Results\Moderation, sheet("Frac (frac probit)", replace) modify"') ///
	model(fracreg probit) ///
	scale(100)

modtable frac_rm meat5 int_health_cat int_envt1_cat inc8 educ4 agecat race_1 race_2 race_4 hisp political gender2, ///
	putexcelcmd(`"putexcel set Results\Moderation, sheet("Frac (OLS)", replace) modify"') ///
	model(regress) ///
	scale(100)

// References:
// 1. https://www.statalist.org/forums/forum/general-stata-discussion/general/1593251-poisson.

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------