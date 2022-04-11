************************************
*Data Prep: Participant Tracker (includes Screener data)
************************************

*Bring in data
cd "/Users/annagrummon/Harvard University/Harvard University/Harvard University/ParticipantTracking"
import excel using "Lola's Validation Screener_Including Enrolled Participants_3.23.xlsx", sheet("Sheet0") firstrow clear

	
*Rename pid variable for merging across files
rename participant_ID PID

*Replace participant no show as not a participant
replace participant_YN="0" if Removed_YN=="No Show - no data"
replace Removed_YN="1" if Removed_YN=="No Show - no data"

*Destring as needed
destring participant_YN, replace
destring Removed_YN, replace

*Keep only respondents in screener who participated in study
keep if participant_YN==1

*Drop those who need to be removed 
drop if Removed_YN==1


*Clean up duplicates
*PID 22 and PID 101 both took screener twice but only participated once. Screener answers are identical, so can drop either.
drop if PID=="22" & EndDate=="#########"
drop if PID=="101" & Duration==82

*Drop Travis Greene based on Participant List (duplicate/bad participant)
drop if PID=="98" & email=="TravisGreene003@gmail.com"

*Two missing PIDs = these are duplicates who took screener 2x. Retain earlier record, drop those with missing PIDs (these were marked as having participated, but we don't need their screening data 2x)
drop if PID==""

	
*Drop variables we don't need	
drop Status IPAddress Progress Durationinseconds Finished RecordedDate ResponseId RecipientLastName RecipientFirstName RecipientEmail ExternalReference LocationLatitude LocationLongitude DistributionChannel UserLanguage consent email phone1 phone2 bestcontact first last text time voicemail_cell voicemail_home futurecontact eligibility computer

*Variables were downloaded as string - encode/destring/gen new as needed
destring age, replace
destring PID, replace

gen frequency_new=.
	replace frequency_new = 1 if frequency=="1 time per month or less"
	replace frequency_new = 2 if frequency=="2-3 times per month"
	replace frequency_new = 3 if frequency=="1 time per week"
	replace frequency_new = 4 if frequency=="More than 1 time per week"
	label define frequency 1 "1 time per month or less" 2 "2-3 times per month" 3 "1 time per week" 4 "More than 1 time per week"
	label values frequency_new frequency 
	drop frequency
	rename frequency_new frequency

gen newshopmethod = .
	replace newshopmethod = 1 if shopmethod=="Website on a computer"
	replace newshopmethod = 2 if shopmethod=="Website on a cellphone"
	replace newshopmethod = 3 if shopmethod=="Website on a tablet"
	replace newshopmethod = 4 if shopmethod=="Mobile app on a cellphone"
	replace newshopmethod = 5 if shopmethod=="Mobile app on a tablet"
	replace newshopmethod = 6 if shopmethod=="Other"

	label define shopmethod 1 "Website on a computer" 2 "Website on a cellphone" 3 "Website on a tablet" 4 "Mobile app on a cellphone" 5 "Mobile app on a tablet" 6 "Other"
	drop shopmethod
	rename newshopmethod shopmethod
	label values shopmethod shopmethod
	
gen newhhld_shop = .
	replace newhhld_shop = 1 if hhld_shop=="None"
	replace newhhld_shop = 2 if hhld_shop=="Less than half"
	replace newhhld_shop = 3 if hhld_shop=="About half"
	replace newhhld_shop = 4 if hhld_shop=="More than half"
	replace newhhld_shop = 5 if hhld_shop=="All"

	label define hhld_shop 1 "None" 2 "Less than half" 3 "About half" 4 "More than half" 5 "All"
	drop hhld_shop 
	rename newhhld_shop hhld_shop
	label values hhld_shop hhld_shop

*Household size
foreach hhsize in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 { 
	capture encode fpl_`hhsize', gen(fpl_`hhsize'_num)
}

*Create FPL150 and FPL200 variables
gen fpl150 = .
forval hhsize=1/20 { 
	capture	replace fpl150 = 1 if fpl_`hhsize'_num==1
	capture	replace fpl150 = 0 if inrange(fpl_`hhsize'_num, 2, 5)
	capture	replace fpl150 = . if fpl_`hhsize'_num==. & hhsize_num == `hhsize'
}
	
gen fpl200 = .
foreach hhsize in 1 2 3 4 5 6 7 8 10 15 { 
	capture	replace fpl200 = 1 if fpl_`hhsize'_num==1 | fpl_`hhsize'_num==2
	capture	replace fpl200 = 0 if inrange(fpl_`hhsize'_num, 3, 5)
	capture	replace fpl200 = . if fpl_`hhsize'_num==. & hhsize_num == `hhsize'
}

*Drop variables we don't need
drop participant_YN
drop Removed_YN
drop fpl_1_num-fpl_15_num
drop fpl_1-fpl_20



*Save data as .dta
cd "$Data/IntermediateData"
save "Screener_EnrolledOnly.dta", replace
