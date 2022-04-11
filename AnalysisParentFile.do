/*Lola's Validation Project*/


*Set file paths
if "`c(username)'"=="anngrummon" | "`c(username)'" == "annagrummon"  {
	global Results "/Users/annagrummon/Harvard University/Harvard University/Harvard University/Results"	
	global Code "/Users/annagrummon/Harvard University/Harvard University/Harvard University/Analysis/Code"
	global Data "/Users/annagrummon/Harvard University/Harvard University/Harvard University/Data"	
	global Overall "/Users/annagrummon/Harvard University/Harvard University/Harvard University" 
}
	
else if "`c(username)'"=="" | "`c(username)'" == ""  {
	
}
	
*Run all data prep files
	do "$Code/PrepScreenerEnrolled.do"

	do "$Code/PrepInitialLolasPurchases.do"

	*do "$Code/PrepProductsToCategorize_Lolas.do" //only needed to be run 1x

	do "$Code/PrepLolasPurchasesCategorized.do"
	
	do "$Code/MergeLolasFoodCats.do"
	
	do "$Code/PrepMergedLolas.do"
	
	do "$Code/PrepWalmartPurchases.do"
	
	do "$Code/PrepSurveys.do"
	
	do "$Code/PrepAllValidation.do"


*Run analysis files
	*do "$Code/SampleDescriptives"

