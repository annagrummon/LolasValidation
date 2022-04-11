*Import Qualtrics Datasets (Screener not needed - part of participant tracker below)
foreach filename in  Main_Walmart_Visit1 Main_Walmart_Visit2 Main_Lolas_Visit1 Main_Lolas_Visit2 {
	cd "$Data/Qualtrics"
	import excel "`filename'.xlsx",  firstrow clear
	duplicates tag PID, gen(dupPID)
	cd "$Data"
	save "`filename'.dta", replace

}

foreach filename Checklist {
	cd "$Data/Qualtrics"
	import excel "`filename'.xlsx",  firstrow clear
	duplicates tag PID, gen(dupPID)
	cd "$Data"
	save "`filename'.dta", replace

}

*Rename id variable in Checklist to be PID for merging
TK need to clean the PID variable
cd "$Data"
use "Checklist.dta", clear
assert id==id_2
gen PID = id
save Checklist.dta, replace

*Import Lola's Purchase Data
	cd "$Data/Lolas"
	import excel "LolasTest2.xlsx", firstrow clear
	*concatenate deptartment, aisle, and shelf
	egen DeptAisleShelf = concat(Department Aisle Shelf), punc(-)
	*Genreate id= ParticipantPublicID (id is how it's saved in Qualtrics)
	gen id = ParticipantPublicID 
	
	cd "$Data"
	save "LolasTest2.dta", replace

	cd "$Data/Lolas"
	import excel "LolasTest1.xlsx", firstrow clear
	*concatenate deptartment, aisle, and shelf
	egen DeptAisleShelf = concat(Department Aisle Shelf), punc(-)
	*Genreate id= ParticipantPublicID (id is how it's saved in Qualtrics)
	gen id = ParticipantPublicID 
	
	cd "$Data"
	save "LolasTest1.dta", replace

************************************
*Participant Tracker (includes Screener data)
************************************

	import excel "/Users/annagrummon/Desktop/Lola's Validation Screener_Including Enrolled Participants_01.10.2022.xlsx", sheet("Sheet0") firstrow clear
		
	rename participant_ID PID

	destring participant_YN, replace
	destring Removed_YN, replace

	keep if participant_YN==1
	drop if Removed_YN==1
			
	cd "$Data"
	save "Screener_EnrolledOnly.dta", replace


*Import Lolas Purchases Post-Categorization
cd "$Data/Lolas"
import excel "LolasFoods_categorized.xlsx", firstrow clear
save "LolasFoods_categorized.dta", replace

