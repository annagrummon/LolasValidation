// Created: 10-29-21
// Modified: 1-19-22
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Cleaning and saving the shopping task data as a .dta file
// Notes:
// 1. Drop test response (participantpublicid == "vxdvdjgk") and responses prior to October 18, 2021.

clear
cd "T:\Wellcome\Aim 3\Full launch"
local i 1
foreach arm in "control" "warning" "tax" "combination" {
    import excel "Data\Raw data\Data including excluded participants\data_exp_30957-v53_task-`arm'", firstrow case(lower) clear
	keep if inlist(action,"Purchase","Summary") // Only keep data on purchases and completion time
	keep eventindex utcdate participantpublicid participantstatus randomiserd68h action product-packunit servingspercontainer-redmeat shelf
	destring eventindex, replace
	tempfile file`i'
	save `file`i''
	local ++i
}
append using `file1' `file2' `file3'

// Drop the test response and responses prior to 00:00 EDT, October 18, 2021, i.e. prior to 04:00 UTC, October 18, 2021

drop if participantpublicid == "vxdvdjgk"
generate double utcdate_new = clock(utcdate,"DMYhms")
drop if Cofc(utcdate_new) < Cmdyhms(10,18,2021,4,0,0)
drop utcdate*

// Save shopping task completion status in a separate dataset for dropout analysis and exclude dropouts thereafter

preserve
keep participantpublicid participantstatus randomiserd68h
duplicates drop
generate dropout = 1 - (participantstatus == "complete")
drop participantstatus
save "Data\Processed data\dropout status", replace
restore
keep if participantstatus == "complete"
drop participantstatus

// Check that each subject has only one set of purchases

duplicates report participantpublicid if action == "Summary"

// Eight subjects have two sets of purchases >> keep the first

bysort participantpublicid (eventindex): egen temp1 = min(eventindex) if action == "Summary"
drop if eventindex > temp1 // Drop the second summary
by participantpublicid: egen temp2 = total(temp1) // Create a variable equal to the first summary's event index
drop if eventindex > temp2 // Drop purchases made after the first set of purchases
drop eventindex temp*

// Save total time taken separately for sensitivity analysis

preserve
keep if action == "Summary"
keep participantpublicid totaltimetaken
label variable totaltimetaken "Shopping task completion time in ms" // Carmen confirmed unit
save "Data\Processed data\shopping task completion times", replace
restore
drop if action == "Summary"
drop action totaltimetaken

// Check tax and total price calculations

preserve
keep randomiserd68h product tax *price redmeat
duplicates drop
foreach var in baseprice tax totalprice {
    replace `var' = round(`var' * 100,1) // Convert to cents to avoid precision issues with decimals
}
assert !missing(tax,totalprice)
assert tax == 0 if redmeat == 0 | inlist(randomiserd68h,1,2) // Check that non-red meat products are not taxed and that the tax was not implemented in the non-tax arms
assert tax == round(baseprice * .3,1) if inlist(randomiserd68h,3,4) & redmeat == 1 // Check that the tax was correctly calculated for red meat products in the tax arms
assert totalprice == baseprice + tax // Check that totalprice is correctly calculated
restore

// Clean nutrient variables of interest

replace energykcal = subinstr(energykcal,"cal","",.)
replace saturatedfat = subinstr(saturatedfat,"g","",.)
replace salt = subinstr(salt,"mg","",.)
destring energykcal saturatedfat salt, replace

// Clean the numbers of servings per container

tabulate servingspercontainer, missing // Energy and nutrients of interest all zero for products with missing servingspercontainer
replace servingspercontainer = lower(servingspercontainer) // Convert to lower case
replace servingspercontainer = "1" if servingspercontainer == "1 count of 2.85oz jerky"
replace servingspercontainer = "15.3" if servingspercontainer == "1 medium potato" // 5 lb bag = 15.3 medium potatoes (148 g or 0.326 lb)
replace servingspercontainer = "16.5" if servingspercontainer == "3.3-4.96" // Average package size = 4.13 lb, which gives 16.5 4-oz servings
replace servingspercontainer = "16" if servingspercontainer == "8 oz. package: about 4.5 servings, 16 oz. package: about 9 servings" // Package size = 16 oz
replace servingspercontainer = "26" if servingspercontainer == "5.0-8.0" // Average package size = 6.5 lb, which gives 26 4-oz servings
replace servingspercontainer = "3.5" if servingspercontainer == "about 3 1/2"
replace servingspercontainer = "4.5" if servingspercontainer == "about 4 1/2"
replace servingspercontainer = "6" if servingspercontainer == "about 5-7"
replace servingspercontainer = "10" if servingspercontainer == "about 8-12"
replace servingspercontainer = "8" if servingspercontainer == "loaf 8" // Varies between 7.5 and 7.9 depending on weight but approximating to 8
replace servingspercontainer = "8" if servingspercontainer == "varied" // Sold per pound, which gives 8 2-oz servings
replace servingspercontainer = subinstr(servingspercontainer,"servings","",.)
replace servingspercontainer = subinstr(servingspercontainer,"serving","",.)
replace servingspercontainer = subinstr(servingspercontainer,"sevings","",.)
replace servingspercontainer = subinstr(servingspercontainer,"about","",.)
replace servingspercontainer = subinstr(servingspercontainer,"abour","",.)
replace servingspercontainer = subinstr(servingspercontainer,"usually","",.)
replace servingspercontainer = strltrim(strrtrim(servingspercontainer)) // Remove leading and trailing blanks
destring servingspercontainer, replace
replace servingspercontainer = 8 if servingspercontainer == 0 & inlist(servingsize,"2 Oz","56 G")
replace servingspercontainer = 16 if servingspercontainer == 0 & inlist(servingsize,"1 Oz")
replace servingspercontainer = 30.6 if servingspercontainer == 0 & servingsize == "5 fl oz"

// Export a random 10% of products for NFP review -- do not rerun

* preserve
* keep product baseprice packsize-ingredients
* duplicates drop
* generate rand = runiform(0,1)
* drop if rand > .1
* drop rand
* export excel "Data\Processed data\Products to review.xlsx", sheet("10% NFP spot check", modify) firstrow(variables)
* restore

// Save

save "Data\Processed data\shopping task", replace

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
// 11-15-21	MB			Moved definition of value labels for arm to separate do
//						file for value and variable labels.
// 12-1-21	MB			Created a separate dta file with shopping task
//						completion times.
// 1-13-22	MB			Deleted second set of purchases for subjects with who
//						checked out twice (n = 8).
// 1-14-22	MB			Recompiled the data to include dropouts and save dropout
//						status in a separate dataset for dropout analysis.
// -----------------------------------------------------------------------------