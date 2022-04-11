// Created: 1-19-22
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: To check if subjects were more or less likely to purchase products with NFP errors by arm

clear
cd "T:\Wellcome\Aim 3\Full launch"
import excel product = A servings = E energy = G satfat = I salt = M servings_checked = Q energy_checked = R satfat_checked = S salt_checked = T using "Data\Processed data\Products to review_FULL STUDY", cellrange(A4:T298)
mvencode servings* energy* satfat* salt*, mv(0) override

// Tag products with NFP errors

foreach v in servings energy satfat salt {
	generate error_`v' = `v' < .8 * `v'_checked | `v' > 1.2 * `v'_checked
}
egen temp = rowtotal(error*)
generate error_any = temp > 0
drop temp

// Merge with shopping task data

keep product error*
merge 1:m product using "Data\Processed data\shopping task", keepusing(participantpublicid randomiserd68h product redmeat)
list product if _merge == 1, noobs // List the two products that were reviewed but not purchased

// Both products were purchased by subject z39ip02c after completing the shopping task once
// They ended up in the list of products to review because it was created before excluding any second set of purchases

keep if _merge == 3 // Drop purchases of these two products and of products that were not reviewed
drop _merge

// Tabulate the number of products with specific and any NFP errors among red meat and non-red meat products

preserve
keep product error* redmeat
duplicates drop
foreach v of varlist error* {
	tabulate redmeat `v', chi2
}
restore // Errors seem to be independent of whether a product contains red meat or not

// Get the number of products with any NFP error in each subject's basket and tabulate by arm

collapse (sum) error_any, by(participantpublicid randomiserd68h) // Number of products with any NFP error in each subject's basket
tabulate error_any randomiserd68h, chi2
generate error_any_01 = error_any > 0
tabulate error_any_01 randomiserd68h, chi2

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------