/*Lola's Validation Project*/

*****************
*Set file paths
*****************

*Anna
if "`c(username)'"=="anngrummon" | "`c(username)'" == "annagrummon"  {
	global Results "/Users/annagrummon/Harvard University/Harvard University/Harvard University/Results"	
	global Code "/Users/annagrummon/Dropbox/ongoing projects/LolasValidation"
	global Data "/Users/annagrummon/Harvard University/Harvard University/Harvard University/Data"	
	global Overall "/Users/annagrummon/Harvard University/Harvard University/Harvard University" 
}

//to find your username, type the following in yoru command line: display "`c(username)'"

*Violet	
else if "`c(username)'"=="" | "`c(username)'" == ""  {
	
}

*Anna Claire
else if "`c(username)'"=="act3242"  {
	global Code "\\Client\C$\Users\annaclairetucker\Desktop\LolasValidation"
	
}

*Veronica
else if "`c(username)'"=="" | "`c(username)'" == ""  {
	
}


*****************
*Run do files in order to execute entire project
*****************

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


*Run analysis files - to be updated once these files are written
	*do "$Code/SampleDescriptives"

