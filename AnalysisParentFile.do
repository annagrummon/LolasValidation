/*Lola's Validation Project*/

*****************
*Set file paths
*****************

*Anna
if "`c(username)'"=="anngrummon" | "`c(username)'" == "annagrummon"  {
	global Results "/Users/annagrummon/Dropbox/ongoing projects/LolasValidationStudy/Results"	
	global Code "/Users/annagrummon/Dropbox/ongoing projects/LolasValidation-Code"
	global Data "/Users/annagrummon/Dropbox/ongoing projects/LolasValidationStudy/Data"
	global Overall "/Users/annagrummon/Harvard University/Harvard University/Harvard University" 
}

//to find your username, type the following in yoru command line: display "`c(username)'"

*Violet	
else if "`c(username)'"=="violetn"  {
	global Code "\\Client\C$\Users\violetnoe\Desktop\LolasValidation"
	global Data "\\Client\C$\Users\violetnoe\Dropbox\LolasValidationStudy\Data"
	global Results "\\Client\C$\Users\violetnoe\Dropbox\LolasValidationStudy\Results"
}

*Anna Claire
else if "`c(username)'"=="act3242"  {
	global Code "\\Client\C$\Users\annaclairetucker\Desktop\LolasValidation"
	global Data "\\Client\C$\Users\annaclairetucker\Dropbox\LolasValidationStudy\Data"
	global Results "\\Client\C$\Users\annaclairetucker\Dropbox\LolasValidationStudy\Results"
}

global catglist_ordered Sweets Dairy Nuts Other Bread FruitVeg MeatSeafood Cereal SSBs Entrees Sauces NonSSBs Eggs PastaRice SaltySnacks 

global catglist Bread Cereal Dairy Eggs Entrees FruitVeg NonSSBs MeatSeafood Nuts PastaRice SaltySnacks Sauces Sweets SSBs Other 

/*
*****************
*Run do files in order to execute entire project
*****************

*Run all data prep files
	*do "$Code/PrepScreenerEnrolled.do" //only need to run 1x. Use cleaned data without identifiers for remainder of project. 

	do "$Code/PrepInitialLolasPurchases.do"

	*do "$Code/PrepProductsToCategorize_Lolas.do" //only needed to be run 1x

	do "$Code/PrepLolasPurchasesCategorized.do"
	
	do "$Code/MergeLolasFoodCats.do"
	
	do "$Code/PrepMergedLolas.do"
	
	do "$Code/PrepWalmartPurchases.do"
	
	do "$Code/PrepSurveys.do"
	
	do "$Code/Labels.do"
	
	do "$Code/PrepAllValidation.do"


*Run analysis files - to be updated once these files are written
	*do "$Code/SampleDescriptives"

