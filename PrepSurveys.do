************************************
*Data Prep: Post-Shopping Task Surveys
************************************

****
*Visit 1
***  

*Import Qualtrics Datasets and save as dtas
foreach filename in  Main_Walmart_Visit1  Main_Lolas_Visit1  {
	cd "$Data/Qualtrics"
	import excel "`filename'.xlsx",  firstrow clear
	duplicates tag PID, gen(dupPID)
	tostring whynotsim, replace
	tostring gender_4_TEXT, replace
	destring difficult_*, replace
	destring race_*, replace
	destring Visit, replace
	mvdecode *, mv(-99)
	cd "$Data/IntermediateData"
	save "`filename'.dta", replace

}

*Append the visit 1 surveys
cd "$Data/IntermediateData"
use Main_Lolas_Visit1, clear
append using Main_Walmart_Visit1


***
*Visit 2
***

*Import Qualtrics Datasets and save as dtas
foreach filename in  Main_Walmart_Visit2  Main_Lolas_Visit2  {
	cd "$Data/Qualtrics"
	import excel "`filename'.xlsx",  firstrow clear
	duplicates tag PID, gen(dupPID)
	foreach variable in difficult_1 difficult_2 difficult_3 difficult_4 difficult_5 difficult_6 difficult_7 difficult_8 difficult_9 difficult_10 difficult_11 difficult_12 difficult_13 soda dietsoda energy dietenergy sports dietsports water fj100 fruitdrink swtteacoff teacoff fruit veg friedpot nonfriedpot otherveg onlinefeatures_1 onlinefeatures_2 onlinefeatures_3 onlinefeatures_4 onlinefeatures_5 onlinefeatures_6 onlinefeatures_7 onlinefeatures_8 onlinefeatures_9 onlinefeatures_10 onlinefeatures_11 onlinefeatures_12 hhsize_main children_num difficult_study_1 difficult_study_2 difficult_study_3 difficult_study_4 difficult_study_5 difficult_study_6 difficult_study_7 difficult_study_8 difficult_study_9 children_num {
		destring `variable', replace
	}
	capture replace children_num="2" if children_num=="6 and 9"
	destring children_num, replace
	destring Visit, replace
	mvdecode *, mv(-99)
	cd "$Data/IntermediateData"
	save "`filename'.dta", replace

}


*Append the visit 2 surveys
cd "$Data/IntermediateData"
use Main_Lolas_Visit2, clear
append using Main_Walmart_Visit2


*Append Visit 1 and Visit 2 - Data should be long.
append using Main_Lolas_Visit1
append using Main_Walmart_Visit1 


******
*Data Cleaning
******

*****
*Clean PIDs  
*****

*Remove .s
forval PID=1/400 {
	replace PID="`PID'" if PID=="`PID'."
}

*Drop observations with PIDxx
drop if strpos(PID,"xx")

*Drop if PID is undefined
drop if PID=="undefined"

*Drop missing PID that has all missing data
drop if PID=="" & Finished==0

*The other missing PID was for participant 42
replace PID="42" if PID==""

*Fix duplicates
 drop if PID=="111" & Finished==0 //Survey sent 2x, only finished 1x, drop incomplete 
replace Store="Lolas" if PID=="8" & Visit==1 //first survey was for Lola's visit (corroborated via Lola's data)
 drop if PID=="98" & id=="yh2sn2cn" //First PID 98 is someone to drop


/* Tk - Flag PIDs that only appear 1x
	gen missingvisit=.
		replace missingvisit=1 if inlist(PID, "25", "146")

*/

destring PID, replace

*Fill in missing id's (not passed from Gorilla)
replace id ="4zhgn2uj" if PID==8 & Store=="Lolas" //from Carmen's linking document "Missing Gorilla id linked to PID"
replace id ="placeholder" if PID==42 & Store=="Lolas" //per Gorilla data, rejected - timed out

replace id="kjgcudgk" if PID==73 & Store=="Lolas" //from Gorilla data and Participant Tracker, this id should belong to PID 73 based on when they completed Lolas Visit 1. Unclear why missing from Qualtrics - wrong link might have been sent that didn't capture PID from URL. 

******
*Process evaluation variables
******

*Easy to use
gen easy_use_agree = .
	replace easy_use_agree = 1 if inrange(easy_use, 4, 5)
	replace easy_use_agree = 0 if inrange(easy_use, 1, 3)
	
	

gen find_list_agree = .
	replace find_list_agree =1 if inrange(find_list, 3,5)
	replace find_list_agree =0 if inrange(find_list, 1,2)
	
	
	
*Difficulties in store - replace missing as 0 (not checked)
forval x=1/13 {
	replace difficult_`x'=0 if difficult_`x'==.
	gen difficult_`x'_ = difficult_`x'
	drop difficult_`x'
}

gen participate_again_agree = .
	replace participate_again_agree=1 if inrange(participate_again, 3, 4)
	replace participate_again_agree=0 if inrange(participate_again, 1, 2)
	
	

*Dichotomous versions of agree/disagree variables - code as 1 if somewhat or strongly agree, and 0 otherwise
foreach v in easily_find enough pick_similar similar_usual felt_real {
	gen `v'_agree = .
	replace `v'_agree= 1 if inrange(`v', 4,5)
	replace `v'_agree= 0 if inrange(`v', 1,3)
}
	


*Create categorical FFQ/BEVQ variables in case we want to present in this way
foreach foodbev in soda dietsoda energy dietenergy sports dietsports water fj100 fruitdrink swtteacoff teacoff fruit veg friedpot nonfriedpot otherveg {
	gen `foodbev'_cat = `foodbev'
	replace `foodbev'_cat = 2 if `foodbev'_cat==2.5
}

*Age 
gen age_cat = .
replace age_cat = 1 if inrange(age_main, 18, 29)
replace age_cat = 2 if inrange(age_main, 30, 39)
replace age_cat = 3 if inrange(age_main, 40, 49)
replace age_cat = 4 if age_main>=50 & age_main!=.

*Woman - leave as missing if NB or self-described
gen woman = 1 if gender==1 
replace woman = 0 if gender==2

*Gender cat (3 level)
gen gender_cat = .
	replace gender_cat = 1 if gender==1
	replace gender_cat = 2 if gender==2
	replace gender_cat = 3 if inrange(gender, 3,4)
	

*Educ - 4 level
gen educ_cat=.
	replace educ_cat = 1 if educ==1 | educ==2 //HS
	replace educ_cat = 2 if educ==3  //some college
	replace educ_cat = 3 if educ==4 | educ==5 //college degree
	replace educ_cat = 4 if educ==6 //grad

*Low educ - some college or less
gen loweduc = .
	replace loweduc = 1 if inrange(educ,1,3)
	replace loweduc = 0 if inrange(educ,4,6)

	
*Race variables
	gen race_cat = . 
		replace race_cat = 1 if race_1==1 & race_2==. & race_3==. & race_4==. & race_5==. & race_6==. //White only
		replace race_cat = 2 if race_2==1 & race_1==. & race_3==. & race_4==. & race_5==. & race_6==. //Black only
		replace race_cat = 3 if race_3==1 & race_1==. & race_2==. & race_4==. & race_5==. & race_6==. //American Indian or Alaska Native only
		replace race_cat = 4 if (race_4==1 | race_5==1) & (race_1==. & race_2==. & race_3==. & race_6==.) //Asian or Hawaiian/Pacific Islander only
		replace race_cat = 5 if race_6 ==1 //Other 
		
		*count total races marked
		egen totalraces = rowtotal(race_1 race_2 race_3 race_4 race_5 race_6)
		replace totalraces = 1 if totalraces==2 & race_4==1 & race_5==1 
		replace race_cat = 5 if totalraces>=2 & totalraces!=.
	
	

*Clean up other race free responses
replace race_cat = 5 if race_6_TEXT=="Bi-racial (African-American & Asian)"
replace race_cat = 5 if race_6_TEXT=="White/ Native American"
replace race_cat = 5 if race_6_TEXT=="mixed"
	
	
*Race-Ethnicity
	gen raceeth = .
		replace raceeth = 1 if race_cat==1 & latino==0 // NH White
		replace raceeth = 2 if race_cat==2 & latino==0 // NH Black
		replace raceeth = 3 if latino==1 //Latino, any race
		replace raceeth = 4 if inrange(race_cat, 3,5) & latino==0 //NH another race or multi-racial 
	

*4-level budget
gen budget_cat = .
	replace budget_cat = 1 if inrange(budget, 1, 3) //<=$100
	replace budget_cat = 2 if inrange(budget,4,5) // $101-$150
	replace budget_cat = 3 if inrange(budget, 6,7) //$151-$200
	replace budget_cat = 4 if inrange(budget,8,11) //>=$201


*Online features - replace missing as 0 (not checked), for Visit 2 survey only
forval x=1/12 {
	replace onlinefeatures_`x'=0 if onlinefeatures_`x'==. & Visit==2
	gen onlinefeatures_`x'_ = onlinefeatures_`x'
	drop onlinefeatures_`x'
}

*HH size
gen hhsize_cat = . 
	replace hhsize_cat = 1 if hhsize_main==1
	replace hhsize_cat = 2 if hhsize_main==2
	replace hhsize_cat = 3 if hhsize_main==3
	replace hhsize_cat = 4 if hhsize_main>=4 & hhsize_main!=.

*Children
gen children_cat = .
	replace children_cat = 1 if children_num ==0
	replace children_cat = 2 if children_num ==1
	replace children_cat = 3 if children_num ==2
	replace children_cat = 4 if children_num >=3 & children_num!=.

	

*Income - 4 level
gen income_4cat = .
	replace income_4cat = 1 if inrange(income_10cat, 1, 3) //less than $25k
	replace income_4cat = 2 if inrange(income_10cat, 4,5) //$25-50k
	replace income_4cat = 3 if inrange(income_10cat, 6,7) //$50-100k
	replace income_4cat = 4 if inrange(income_10cat, 8, 10) //$100k or more

	
*Difficulties with the study - replace missing as 0 (not checked), for Visit 2 survey only
forval x=1/9 {
	replace difficult_study_`x'=0 if difficult_study_`x'==. & Visit==2
}


*Reshape with store variable
reshape wide StartDate EndDate Status IPAddress Progress Durationinseconds Finished RecordedDate ResponseId RecipientLastName RecipientFirstName RecipientEmail ExternalReference LocationLatitude LocationLongitude DistributionChannel UserLanguage easy_use find_list difficult_13_TEXT participate_again easily_find enough pick_similar similar_usual felt_real whynotsim whynotreal soda dietsoda energy dietenergy sports dietsports water fj100 fruitdrink swtteacoff teacoff fruit veg friedpot nonfriedpot otherveg age_main budget budget_11_TEXT dietqual nfponline nfpstore hhsize_main children_num income_10cat difficult_study_1 difficult_study_2 difficult_study_3 difficult_study_4 difficult_study_5 difficult_study_6 difficult_study_7 difficult_study_8 difficult_study_9 difficult_study_9_TEXT anythingelse Visit id dupPID age_cat gender gender_cat gender_4_TEXT educ hhsize_cat children_cat latino race_1 race_2 race_3 race_4 race_5 race_6 race_6_TEXT soda_cat dietsoda_cat energy_cat dietenergy_cat sports_cat dietsports_cat water_cat fj100_cat fruitdrink_cat swtteacoff_cat teacoff_cat fruit_cat veg_cat friedpot_cat nonfriedpot_cat otherveg_cat woman educ_cat loweduc race_cat totalraces raceeth budget_cat income_4cat difficult_1_ difficult_2_ difficult_3_ difficult_4_ difficult_5_ difficult_6_ difficult_7_ difficult_8_ difficult_9_ difficult_10_ difficult_11_ difficult_12_ difficult_13_ onlinefeatures_1_ onlinefeatures_2_ onlinefeatures_3_ onlinefeatures_4_ onlinefeatures_5_ onlinefeatures_6_ onlinefeatures_7_ onlinefeatures_8_ onlinefeatures_9_ onlinefeatures_10_ onlinefeatures_11_ onlinefeatures_12_ participate_again_agree easily_find_agree enough_agree pick_similar_agree similar_usual_agree felt_real_agree easy_use_agree find_list_agree, i(PID) j(Store) string

*Create merged, constant variables within Store for Qs only asked at 1 visit
	*Start with quantitative variables

foreach v in soda dietsoda energy dietenergy sports dietsports water fj100 fruitdrink swtteacoff teacoff fruit veg friedpot nonfriedpot otherveg age_main budget dietqual nfponline nfpstore hhsize_main children_num income_10cat difficult_study_1 difficult_study_2 difficult_study_3 difficult_study_4 difficult_study_5 difficult_study_6 difficult_study_7 difficult_study_8 difficult_study_9   Visit  dupPID  age_cat gender gender_cat educ hhsize_cat children_cat latino race_1 race_2 race_3 race_4 race_5 race_6  soda_cat dietsoda_cat energy_cat dietenergy_cat sports_cat dietsports_cat water_cat fj100_cat fruitdrink_cat swtteacoff_cat teacoff_cat fruit_cat veg_cat friedpot_cat nonfriedpot_cat otherveg_cat woman educ_cat loweduc race_cat totalraces raceeth budget_cat income_4cat onlinefeatures_1_ onlinefeatures_2_ onlinefeatures_3_ onlinefeatures_4_ onlinefeatures_5_ onlinefeatures_6_ onlinefeatures_7_ onlinefeatures_8_ onlinefeatures_9_ onlinefeatures_10_ onlinefeatures_11_ onlinefeatures_12_ {
		gen `v' = .
		replace `v' = `v'Lolas if `v'Lolas!=.
		replace `v' = `v'Walmart if `v'Walmart!=.
		drop `v'Lolas
		drop `v'Walmart
	}

foreach v in budget_11_TEXT difficult_study_9_TEXT race_6_TEXT gender_4_TEXT  anythingelse id { 
	gen `v' = ""
	replace `v' = `v'Lolas if `v'Lolas!="" & `v'Lolas!="-99"
	replace `v' = `v'Walmart if `v'Walmart!="" & `v'Walmart!="-99"
	drop `v'Lolas
	drop `v'Walmart
}


*Save cleaned data
cd "$Data/IntermediateData"
save "Survey_all_clean.dta", replace
