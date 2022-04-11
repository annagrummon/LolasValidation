*Import Lolas Crosswalk
cd "$Data"
import excel "CrosswalkAnalysisCategories_v2.xlsx", sheet("categories_organized") firstrow clear

egen DeptAisleShelf = concat(Department Aisle Shelf), punc(-)

gen review = . 
	*No categories, or more than 1 category
	replace review = 1 if NumberCategories ==0
	replace review = 1 if NumberCategories > 1 & NumberCategories!=.
	*Notes indicate needs review
	replace review = 1 if Notes=="review"
	
	*No review needed if 1 category and no notes
	replace review = 0 if NumberCat==1 & Notes==""

cd "$Data/IntermediateData"
save "Crosswalk.dta",replace 
	
*Merge data with Lola's purchases
//Lola's data needs to have been prep already in LolasPurchasesPrep.do

cd "$Data/IntermediateData"
merge 1:m DeptAisleShelf using "LolasPurchases_all.dta"
drop if Action=="Summary" //don't need summary rows for hand-coding
assert _merge!=2  //all DeptAisleShelf in lola's purchase data (using) should be in Crosswalk (master) 


*Drop DeptAisleShelf not in Lola's Purchase data (_merge==1)
drop if _merge==1

*Set categories equal to missing for products we need to review
foreach category in Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice {
	replace `category'=. if review==1
}

*Keep only products to review
keep if review==1

*Order variables sensibly
order Product Ingredients Department Aisle Shelf Category Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice

*Drop duplicate products
duplicates drop Product Department Aisle Shelf, force

gen notes = ""
order Product Ingredients Department Aisle Shelf Category Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice notes

*Keep only variables useful for reviewing - drop those not needed
keep Product Ingredients Department Aisle Shelf Category Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice notes DeptAisleShelf PackSize PackUnit servingspercontainer servingsize EnergyKCAL Fat SaturatedFat TransFat Carbohydrates Sugar Salt Fibre Protein redmeat

*Export to excel for RAs to categorize
export excel using "/Users/annagrummon/Harvard University/Harvard University/Harvard University/Data/Lolas/LolasFoodsToCategorize.xlsx", firstrow(variables) replace
