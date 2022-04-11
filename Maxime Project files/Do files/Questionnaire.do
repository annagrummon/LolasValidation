// Created: 11-1-21
// Modified: 1-14-22
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Cleaning and saving the questionnaire data as a .dta file
// Notes:
// 1. Drop test response (participantpublicid == "vxdvdjgk") and responses prior to October 18, 2021.
// 2. Some respondents answered the survey more than once (e.g., encountered error when submitting); keep the first set of responses unless finished = 0.

clear
cd "T:\Wellcome\Aim 3\Full launch"
import excel "Data\Processed data\Wellcome Aim 3 Qualtrics - Full Launch - Copy", firstrow case(lower) clear
keep startdate durationinseconds finished process easily_find enough felt_real anna_* ///
reason_similar_* ce_* pph reduce_meat risk_* pol_* *_burger *_pizza *_ham ethnicity* ///
race_1 race_2 race_3 race_4 race_5 race_6* education income political *_healthy ///
green_* id arm

// Drop the test response, responses prior to October 18, 2021, and the one response with missing arm (all variables also missing)

drop if id == "vxdvdjgk" | dofc(startdate) < mdy(10,18,2021) | arm == .

// Drop duplicates, keeping the first response if complete and the second otherwise

bysort id (startdate): generate n = _n
duplicates tag id, generate(dup)
tabulate finished n if dup // All first responses complete among duplicates, therefore drop all second responses
drop if n == 2
drop startdate n dup

// Compute descriptives to spot potential entry or coding errors, tabulating scale variables rather than using means

summarize durationinseconds, detail
summarize durationinseconds if finished == 1, detail // Short completion times noted in project notes for robustness checks
unab allvars: *
local notabvars durationinseconds finished reason_similar_4_text id arm
local tabvars: list allvars - notabvars
tab1 `tabvars'

// Save

save "Data\Processed data\questionnaire", replace

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------