************************************
*Data Prep: Categorized Lola's Purchases
************************************

*Import data

foreach x in 1 2 {
	cd "$Data/Lolas"
	import excel "LolasPurchases`x'.xlsx", firstrow clear
	
	*concatenate deptartment, aisle, and shelf
	egen DeptAisleShelf = concat(Department Aisle Shelf), punc(-)
	
	*Genreate id=ParticipantPublicID (id is how it's saved in Qualtrics)
	gen id = ParticipantPublicID 
	
cd "$Data/IntermediateData"
save "LolasPurchases`x'.dta", replace
}


*Append the datasets
clear
cd "$Data/IntermediateData"
use "LolasPurchases1.dta", clear
append using "LolasPurchases2.dta"

*Keep only Purchase and Summary Actions
keep if inlist(Action,"Purchase","Summary") // Only keep data on purchases and completion time

*Keep only variables we need or might use
keep EventIndex UTCDate UTCTimestamp Action ParticipantPublicID ParticipantDeviceType ParticipantBrowser ParticipantMonitorSize Category Product Quantity TotalPrice TotalTimeTaken PackSize PackUnit updated servingspercontainer servingsize EnergyKCAL Fat SaturatedFat TransFat Carbohydrates Sugar Salt Fibre Protein Ingredients redmeat ShelfRank Department Aisle Shelf DeptAisleShelf id

duplicates report id if Action == "Summary"
duplicates list id if Action == "Summary"
//TK TK TK one duplicate id = le7i20il - consult Qualtrics for more info

label variable TotalTimeTaken "Shopping task completion time in ms" // Carmen confirmed unit

*Convert to cents to avoid precision issues with 
foreach var in TotalPrice {
    replace `var' = round(`var' * 100,1) 
}

*Check Quantity, Price look correct for individual selections
sum Quantity if Action=="Purchase" //1-12 - appropriate range
sum TotalPrice if Action=="Purchase" 

*Check Quantity, TotalPrice look correct for baskets
sum Quantity if Action=="Summary" //6 to 238 - TK discuss with team
sum TotalPrice if Action=="Summary" //$15 to $632 ... TK discuss with team how to handle. Might be okay b/c we are ranking people. 

sum TotalTimeTaken

*Tk leave long for now.

cd "$Data/IntermediateData"
save "LolasPurchases_all.dta", replace



