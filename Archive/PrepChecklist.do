************************************
*Data Prep: Visit Checklist
************************************

*Goals: Clean, Reshape to Wide

*Bring in data
cd "$Data/Qualtrics"
import excel "Checklist.xlsx",  firstrow clear

cd "$Data/IntermediateData"
save "Checklist.dta", replace

assert id==id_2
drop id_2 

assert visitnum==visitnum_2
drop visitnum_2 
rename visitnum Visit

//MAYBE THE ARM ISN'T RIGHT WAY TO ID WHICH STORE THEY ARE IN?
assert arm_1==arm_2
drop arm_2

gen Store = ""
replace Store = "Walmart" if arm_1==1
replace Store = "Lolas" if arm_1==2

drop arm_1 

gen PID = id

destring RA, replace
label define RAs 4 "Anna Claire" 5 "Violet"
label values RA RAs

****
**Clean PID/Duplicates
****

drop if PID=="test"
drop if PID=="-99"

*Replace PIDs without leading 0's as needed
replace PID="1" if PID=="001"
replace PID="10" if PID=="0010"
replace PID="7" if PID=="007"

*Destring PID
foreach v in PID  {
	destring `v', replace
}

*Drop practice checklists - before first participant on Nov 5.
drop if Cofc(StartDate) < Cmdyhms(11,5,2021,1,0,0)

*Tag duplicate PID and Store
duplicates tag PID Store, gen(PIDStoreDup)

*Drop if not finished and duplicate
drop if PIDStoreDup!=0 & zoomlocked_1==""

*TK TK Fix Duplicates
drop PIDStoreDup
duplicates tag PID Store, gen(PIDStoreDup)

*Drop rows that are identical on PID, Store, Visit, and issues notes. We only need one record of these. 
duplicates drop PID Store Visit issues_2_TEXT, force





*Destring issues
destring issues, replace

mvdecode *, mv(-99)

*TK Create flags for PIDs to potentially exclude in sensitivity analyses due to issues recorded in checklist

*Gen flag for id didn't complete Lola's, should be excluded from analysis
gen exclude_checklist = .
	replace exclude_checklist=1 if PID== & issues_2_TEXT==
	
gen exclude_checklist_why = ""
	replace exclude_checklist_why = "" if PID==




*Drop variables we don't need
drop EndDate IPAddress Progress Durationinseconds Finished RecordedDate ResponseId RecipientLastName RecipientFirstName RecipientEmail ExternalReference LocationLatitude LocationLongitude DistributionChannel UserLanguage id zoomlocked_1 consentsent_4 consentreviewed_4 verbalconsent_4 communicationconsent_4 listlinksent_ACT_4 listlinksent_VN_4 listinstructread_1 listfilename listpdfsent_4 lolassurvey1sent_4 lolassurvey2sent_4 listpdfsent_2lo_1 shopping_instruction_4 shopping_instructin2_4 listclear_lolas_AC_4 listclear_lolas_VN_4 lolaschkconsent_1 listpdfsent_2wal_1 walmartpw_ACT walmartpw_VN location_4 walmarttask_4 walmarttask2_1 listclear_walmart_AC_4 listclear_walmart_VN_4 walmartchkconsent_1 walmartbasketcheck_4 walmartbasketcheck_7 Q72_1 walmartsurvey1sent_4 walmartsurvey2sent_4 walmartcartsave_Id walmartcartsave_Name walmartcartsave_Size walmartcartsave_Type nextvisit timestillworks newtime emailupdated_4 emailupdated_7 email newwalmartpw walmartpurchases_4 gc1amt gc2amt gc_file_Id gc_file_Name gc_file_Size gc_file_Type

*TK TK REMOVE LATER
duplicates drop PID Store, force


*RESHAPE USING STORE - tk cannot complete b/c of duplicates
reshape wide StartDate RA Visit issues issues_2_TEXT anythingelse, i(PID) j(Store) string

cd "$Data/IntermediateData"
save Checklist.dta, replace
