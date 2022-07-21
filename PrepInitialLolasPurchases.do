************************************
*Data Prep: Lola's Purchases (not yet categorized)
************************************



*Import data from participant with missing data and save as .dta
import excel "/Users/annagrummon/Dropbox/ongoing projects/LolasValidationStudy/Data/Lolas/Lolas Data for Missing Participant-PID42.xlsx", sheet("Sheet1") firstrow clear

gen id = "placeholder"

save "$Data/IntermediateData/LolasPurchases_PID42_coded.dta", replace



*Import data
*Most recent version of Gorilla:
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

*bring in prior version:
foreach x in 1 2 {
	cd "$Data/Lolas"
	import excel "LolasPurchases`x'_part1.xlsx", firstrow clear
	
	*concatenate deptartment, aisle, and shelf
	egen DeptAisleShelf = concat(Department Aisle Shelf), punc(-)
	
	*Genreate id=ParticipantPublicID (id is how it's saved in Qualtrics)
	gen id = ParticipantPublicID 
	
cd "$Data/IntermediateData"
save "LolasPurchases`x'_part1.dta", replace
}

*PIDs not in original data...
foreach PID in 1 4 {
	cd "$Data/Lolas"
	import excel "LolasPurchases1_PID`PID'.xlsx", firstrow allstring clear
	
	*concatenate deptartment, aisle, and shelf
	egen DeptAisleShelf = concat(Department Aisle Shelf), punc(-)
	
	*Genreate id=ParticipantPublicID (id is how it's saved in Qualtrics)
	gen id = ParticipantPublicID 
	foreach v in  LocalTimezone LocalTimestamp UTCTimestamp Quantity TotalPrice TotalTimeTaken PackSize redmeat ShelfRank ExperimentID ExperimentVersion RepeatKey ScheduleID ParticipantPrivateID ParticipantCompletionCode ParticipantExternalSessionID Checkpoint TaskName BasketDistribution Labels ShoppingList BasketRating Taxes ActionID ParticipantStartingGroup   TaskVersion BasePrice  Tax {
		destring `v' , replace
	}
	
	drop Checkout
	
cd "$Data/IntermediateData"
save "LolasPurchases1_PID`PID'.dta", replace
	
}


*Append the datasets
clear
cd "$Data/IntermediateData"
use "LolasPurchases1.dta", clear
append using "LolasPurchases2.dta"
append using "LolasPurchases1_part1.dta"
append using "LolasPurchases2_part1.dta"
append using "LolasPurchases1_PID1.dta"
append using "LolasPurchases1_PID4.dta"

*Keep only Purchase and Summary Actions
keep if inlist(Action,"Purchase","Summary") // Only keep data on purchases and completion time

*Keep only variables we need or might use
keep EventIndex UTCDate UTCTimestamp Action ParticipantPublicID ParticipantDeviceType ParticipantBrowser ParticipantMonitorSize Category Product Quantity TotalPrice TotalTimeTaken PackSize PackUnit updated servingspercontainer servingsize EnergyKCAL Fat SaturatedFat TransFat Carbohydrates Sugar Salt Fibre Protein Ingredients redmeat ShelfRank Department Aisle Shelf DeptAisleShelf id

*Destring event index
destring EventIndex,replace

duplicates report id if Action == "Summary"
duplicates list id if Action == "Summary"
//one duplicate id. All purchases same in both shops. keep first instance. 

bysort ParticipantPublicID (EventIndex): egen temp1 = min(EventIndex) if Action == "Summary"
drop if EventIndex > temp1 // Drop the second summary
by ParticipantPublicID: egen temp2 = total(temp1) // Create a variable equal to the first summary's event index
drop if EventIndex > temp2 // Drop purchases made after the first set of purchases
drop temp*


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

sum TotalTimeTaken //time in ms 

cd "$Data/IntermediateData"
save "LolasPurchases_all.dta", replace


