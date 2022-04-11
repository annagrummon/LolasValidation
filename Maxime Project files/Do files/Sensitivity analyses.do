// Created: 1-13-22
// Modified:
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Sensitivity analyses (primary outcomes only)
// Details:
// 1. Excluding subjects in the bottom 2 percent of expenditure
// 2. Excluding subjects who completed the study unusually quickly
// 3. Excluding subjects who did not comply with the shopping list

clear
cd "T:\Wellcome\Aim 3\Full launch"
run "Do files\Programs"
use "Data\Processed data\shopping task compliance"
rename participantpublicid id
merge 1:1 id using "Data\Processed data\merged data" // All matched
drop _merge
keep id arm redmeat frac_rm totalprice completiontime nocomplier

// 1 Low total spend

_pctile totalprice, percentiles(2)
mmetable redmeat frac_rm if totalprice >= r(r1), ///
	putexcelcmd(`"putexcel set "Results\Sensitivity analyses.xlsx", sheet("Total spend", replace) modify"') ///
	modelopts(`"vce(robust)"') ///
	scale(100) ///
	scalevars(frac_rm)

// 2 Fast completion
// No pre-registered rule >> exclude subjects who completed the study in half the median completion time

_pctile completiontime, percentiles(50)
mmetable redmeat frac_rm if completiontime >= r(r1) / 2, ///
	putexcelcmd(`"putexcel set "Results\Sensitivity analyses.xlsx", sheet("Completion time", replace) modify"') ///
	modelopts(`"vce(robust)"') ///
	scale(100) ///
	scalevars(frac_rm)

// 3 Failure to comply with the shopping list

mmetable redmeat frac_rm if !nocomplier, ///
	putexcelcmd(`"putexcel set "Results\Sensitivity analyses.xlsx", sheet("Shopping list", replace) modify"') ///
	modelopts(`"vce(robust)"') ///
	scale(100) ///
	scalevars(frac_rm)

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------