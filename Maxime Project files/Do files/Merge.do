// Created: 11-2-21
// Modified: 2-25-22
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Merging all datasets and checking randomization
// Notes:
// 1. participantpublicid and randomiserd68h in screener and shopping task = id and arm in questionnaire.
// 2. Nutritional information in the shopping task dataset is per serving.
// 3. totalprice in shopping task dataset is the tax-inclusive price per unit.

clear
cd "T:\Wellcome\Aim 3\Full launch"

// Collapse variables of interest from the shopping task at the respondent level

use "Data\Processed data\shopping task"
foreach v in energykcal saturatedfat salt {
    replace `v' = `v' * servingspercontainer * quantity
}
recode energykcal saturatedfat salt (. = 0) // Energy and nutrients all zero for products with missing servingspercontainer
foreach v in totalprice redmeat {
    replace `v' = `v' * quantity
}
collapse (sum) energykcal saturatedfat salt totalprice redmeat quantity, by(participantpublicid randomiserd68h)
label variable energykcal "Total energy (kcal)"
label variable saturatedfat "Total saturated fat (g)"
replace salt = salt / 1000
label variable salt "Total salt (g)"
label variable totalprice "Total cost of basket ($)"
label variable redmeat "Count of red meat items"
label variable quantity "Count of all items"

// Merge datasets, drop the test response, and assign value and variable labels

merge 1:1 participantpublicid using "Data\Processed data\shopping task completion times" // All matched
drop _merge
merge 1:1 participantpublicid using "Data\Processed data\screener" // 944 obs. in screener only, i.e. dropouts
drop if _merge == 2 // Exclude the dropouts
drop _merge
rename (participantpublicid randomiserd68h) (id arm)
merge 1:1 id using "Data\Processed data\questionnaire" // 9 obs. from master not matched, i.e. never started the questionnaire
drop _merge
run "Do files\Labels"

// Create variables for analysis

// Fraction of red meat items

generate frac_rm = redmeat / quantity
label variable frac_rm "Fraction of red meat items"

// Interest in health

alpha *_healthy, item // Exclude diet_healthy
egen int_health = rowmean(effort_healthy fat_healthy)
label variable int_health "Interest in health"
notes int_health: Average of effort_healthy and fat_health (Cronbach's alpha = .7605); diet_healthy excluded because its inclusion causes Cronbach's alpha to drop to .6235.

// Interest in the environment

alpha green_*, item // Alpha = .9108 but green_nohram and green_impact are missing for two and one observations, respectively >> does excluding those items make a difference?
egen int_envt1 = rowmean(green_*)
alpha green_habits green_concerned green_responsible green_inconvenience, item // Alpha = .8566
egen int_envt2 = rowmean(green_habits green_concerned green_responsible green_inconvenience)
correlate int_envt1 int_envt2 // rho = .9817
label variable int_envt1 "Interest in sustainability"
label variable int_envt2 "Interest in sustainability (subset)"
notes int_envt1: Average of all interest in sustainability items (Cronbach's alpha = .9108). 
notes int_envt2: Alternate interest in sustainability measure excluding green_noharm and green_impact, which are missing for two and one observations, respectively (Cronbach's alpha = .8566). Correlation coefficient with int_envt1 = .9817.

// Study completion time (shopping task and questionnaire)

generate completiontime = totaltimetaken / 1000 + durationinseconds // totaltimetaken is in ms
label variable completiontime "Study completion time in s"
drop totaltimetaken durationinseconds

// Save

save "Data\Processed data\merged data", replace

// Erase screener, shopping task, and questionnaire datasets

* erase "Data\Processed data\screener.dta"
* erase "Data\Processed data\shopping task.dta"
* erase "Data\Processed data\questionnaire.dta"

// Check randomization among shopping list completes and among shopping task and questionnaire completes

tabulate arm, missing // Among shopping task completes
tabulate arm if finished == 1, missing // Among total completes (shopping task and questionnaire)
tabulate arm finished, missing chi2 // Test for systematic differences in questionnaire completion (finished, did not finish, did not do the questionnaire) by arm

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
// 11-12-21	MB			Deleted code creating alternative categories for red
//						meat consumption frequency, education, and income in
//						favor of a more data driven approach to data reduction
//						in primary outcome analyses.
// 1-13-22	MB			Deleted code creating totalprice_rm for the total cost
//						of all red meat items because this variable is not used
//						in the analysis, and was created incorrectly.
//						Merged shopping task completion time and created a total
//						study completion time variable.
// -----------------------------------------------------------------------------