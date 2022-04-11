// Created: 1-14-22
// Modified: 1-19-22
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Describing dropout status by arm and screener characteristics
// Notes:
// 1. Only subjects who started the shopping task but did not complete it are of interest; eligible subjects who did not start the shopping task are not relevant.

clear
cd "T:\Wellcome\Aim 3\Full launch"
use "Data\Processed data\dropout status"
merge 1:1 participantpublicid using "Data\Processed data\screener" // 926 eligible subjects did not start the shopping task (in screener only); 18 did but dropped out (participantstatus not complete)
drop if _merge == 2
drop _merge
rename (participantpublicid randomiserd68h) (id arm)
run "Do files\Labels"
label values arm arm

// Test for differential dropout by arm and screener characteristics

foreach v in arm gender grocery online_shop {
	tabulate `v' dropout, chi2 // Pearson's Chi-square test
}
ttest age, by(dropout) // t-test for age by dropout status

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------