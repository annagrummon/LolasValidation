// Created: 10-29-21
// Modified: 1-13-22
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Determining shopping list compliance

clear
cd "T:\Wellcome\Aim 3\Full launch"
use "Data\Processed data\shopping task"
keep participantpublicid randomiserd68h product quantity shelf

// Note that a single product can count towards more than one product type (e.g. sandwich filling and taco filling)

replace shelf = "Organic Pantry Products" if shelf == "Organic Pantry" // Shelf 'Organic Pantry' not mapped onto shopping list items
tempfile temp
save `temp'
import excel "T:\Wellcome\Aim 3\Soft launch\Data\Cleaning item selections", cellrange(A1:J369) firstrow case(lower) clear
merge 1:m shelf using `temp' // 14 obs. in shopping task dataset only, i.e. in shelves not mapped onto shopping list items
distinct product if _merge == 2 // 12 products in total
generate assign_shelf = _merge == 2 // Flag these products for review
drop if _merge == 1 // Drop obs. from cleaning item selections if not in shopping task dataset
drop _merge

// Update assigments based on soft launch review

save `temp', replace
import excel "T:\Wellcome\Aim 3\Soft launch\Data\Products to review_corrections", sheet("Shopping list assignments") firstrow case(lower) clear
drop f_*
merge 1:m product shelf using `temp'
drop if _merge == 1
drop _merge
* recode pizza burrito patties sausage frozen bread sandwhich tortilla taco (. = 0) if inlist(shelf,"Mini Cans","Dessert")

// Update assigments based on full launch review

save `temp', replace
import excel "T:\Wellcome\Aim 3\Full launch\Data\Processed data\Products to review_FULL STUDY", sheet("Shopping list mapping") firstrow case(lower) clear
keep product shelf *_final
rename *_final *
rename burger patties
merge 1:m product shelf using `temp'
drop if _merge == 1
drop _merge
egen blanks = rowmiss(pizza burrito patties sausage frozen bread sandwich tortilla taco)
replace assign_shelf = 0 if blanks == 0
drop blanks

// Export products in shelves not mapped onto shopping list items and products in multiple shelves mapping to different shopping list items

preserve
keep assign_shelf product pizza burrito patties sausage frozen bread sandwich tortilla taco shelf
duplicates drop
foreach var in pizza burrito patties sausage frozen bread sandwich tortilla taco {
	generate f_`var' = 0
	egen stddev = sd(`var'), by(product)
	replace f_`var' = stddev > 0 if stddev < .
	drop stddev
}
egen anyflag = rowtotal(f_*)
keep if assign_shelf == 1 | anyflag > 0
drop anyflag
order product pizza-taco shelf assign_shelf f_*
sort product
capture export excel "Data\Processed data\Products to review.xlsx", sheet("Shopping list mapping (2)", replace) firstrow(variables)
restore

// Tag subjects who purchased fewer than 5 of the 9 items on the shopping list

generate n_comply = 0
foreach item in pizza burrito patties sausage frozen bread sandwich tortilla taco {
	assert !missing(`item')
	tempvar n_`item'
	egen `n_`item'' = total(`item'), by(participantpublicid)
	replace n_comply = n_comply + 1 if `n_`item'' > 0
}
generate nocomplier1 = n_comply < 5

// Tag subjects who purchased fewer than 7 or more than 11 items

assert !missing(quantity)
collapse (sum) quantity (firstnm) randomiserd68h nocomplier1, by(participantpublicid)
generate nocomplier2 = !inrange(quantity,7,11)

// Tabulate non-compliance by arm

tabulate nocomplier1 randomiserd68h, chi2
tabulate nocomplier2 randomiserd68h, chi2 // No non-compliers (not allowed to check out with less (more) than 7 (11) items)
drop nocomplier2
rename nocomplier1 nocomplier

// Save non-compliance

label variable nocomplier "Purchased fewer than 5 of the shopping list items"
keep participantpublicid nocomplier
isid participantpublicid
save "Data\Processed data\shopping task compliance", replace

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
// 1-13-22	MB			Dropped nocomplier2 because all zero after dropping
//						second set of purchases for the 8 subjects who checked
//						out twice.
// -----------------------------------------------------------------------------