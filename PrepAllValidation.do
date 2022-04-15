*Merge datasets

*Start by bringing in Survey Data 
cd "$Data/IntermediateData"
use "Survey_all_clean.dta", clear

*Tk remove this code eventually or keep just 1 instance. Right now two missing ids are people with only Walmart surveys, still following up on this issue
drop if id==""


*Merge survey data with Lola's purchase data using id variable
merge 1:1 id using "$Data/IntermediateData/LolasPurchases_all_clean.dta"

*Clean up _merge==2 people - in Lola's only. The following ids are from PIDxxs in Lola's Qualtrics surveys - i.e., to drop
foreach id in vtmngmlk  itxsfbzq vwoyg2h1 ddtfqvkt yge8na8b mttcdi5u op0jvidt f68c17g3 {
	drop if _merge==2 & id=="`id'"
}

drop if _merge==2 & id=="yh2sn2cn" //no visits in Participant Tracker scheduled for date of this Lola's trip

rename _merge mergeSurveyLolas


*Merge data with Walmart purchase data using PID variable
merge 1:1 PID using "$Data/IntermediateData/WalmartPurchases_clean.dta"
rename _merge mergeSurveyWalmart

//*Two PIDs are in Walmart only - 25 and 146. These are known missing from surveys, it is not clear why these Ps have purchahse data but did not complete surveys. But the purchase data can still be analyzed. 


*Merge with Screener + Enrollment Data
merge 1:1 PID using "Screener_EnrolledOnly.dta"

***********************
*Define participants to be excluded
**********************

*Create variables for excluding from all analyses and from sensitivity analyses, plus reasons why excluded

gen exclude_all = .
gen exclude_all_why = ""
gen exclude_sens = .
gen exclude_sens_why =""

*Define PIDs that should be excluded from all analyses
replace exclude_all = 1 if PID==9
replace exclude_all_why = "Did not follow instructions" if PID==9

replace exclude_all = 1 if PID==32
replace exclude_all_why = "Did not follow instructions" if PID==32

replace exclude_all = 1 if PID==143
replace exclude_all_why = "Did not follow instructions" if PID==143

replace exclude_all = 1 if PID==25
replace exclude_all_why = "Lola's data not captured due to technical difficulties" if PID==25



*Define PIDs that should be excluded from sensitivity analyses
replace exclude_sens = 1 if PID==6
replace exclude_sens_why = "Not all purchases captured in Walmart due to technical glitch" if PID==6

replace exclude_sens = 1 if PID==34
replace exclude_sens_why = "Did not follow instructions - completed on phone" if PID==34

replace exclude_sens = 1 if PID==36
replace exclude_sens_why = "Data accuracy concerns due to technical difficulties for participant" if PID==36

replace exclude_sens = 1 if PID==31
replace exclude_sens_why = "Data accuracy concerns due to technical difficulties for participant" if PID==31

*TK double check after RAs reply re: start date of out of stock
replace exclude_sens = 1 if PID==40
replace exclude_sens_why = "Out of stock item prior to recording these" if PID==40

replace exclude_sens = 1 if inlist(PID, 49, 50, 51, 52, 58, 28, 38, 60, 63, 69, 90)
replace exclude_sens_why = "Out of stock item prior to recording these" if inlist(PID, 49, 50, 51, 52, 58, 28, 38, 60, 63, 69, 90)

*Save the data
cd "$Data"
save "ValidationData_all.dta", replace
