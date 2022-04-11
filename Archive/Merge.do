*Merge datasets

*Start by bringing in Survey Data 
cd "$Data/IntermediateData"
use "Survey_all_clean.dta", clear

*Tk remove this code eventually or keep just 1 instance
drop if id==""


*Merge survey data with Lola's purchase data using id variable
merge 1:1 id using "$Data/IntermediateData/LolasPurchases_all_clean.dta"
drop _merge

*TK to remove later
drop if PID==""

*Merge data with Walmart purchase data using PID variable
merge 1:1 PID using "$Data/IntermediateData/WalmartPurchases_clean.dta"
drop _merge

*Merge with Checklist 
merge 1:1 PID using "$Data/IntermediateData/Checklist.dta"
drop _merge

*Merge with Screener + Enrollment Data
merge 1:1 PID using "Screener_EnrolledOnly.dta"
