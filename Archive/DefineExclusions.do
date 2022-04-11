*Bring in merged data

cd "$Data"
use "MergedData.dta", clear

*Excluded Participants

gen exclude_all = .

gen exclude_all_why = ""

gen exclude_sens = .

gen exclude_sens_why =""

*Define exclude all PIDs
replace exclude_all = 1 if PID==9
replace exclude_all_why = "Did not follow instructions" if PID==9

replace exclude_all = 1 if PID==32
replace exclude_all_why = "Did not follow instructions" if PID==32

replace exclude_all = 1 if PID==143
replace exclude_all_why = "Did not follow instructions" if PID==143

replace exclude_all = 1 if PID==25
replace exclude_all_why = "Data not captured due to technical difficulties" if PID==25



*Define exclude sensitivity analysis PIDs
replace exclude_sens = 1 if PID==6
replace exclude_sens_why = "Not all purchases captured in Walmart due to technical glitch" if PID==6

replace exclude_sens = 1 if PID==34
replace exclude_sens_why = "Did not follow instructions - completed on phone" if PID==34

replace exclude_sens = 1 if PID==36
replace exclude_sens_why = "Data accuracy concerns due to technical difficulties for participant" if PID==36

replace exclude_sens = 1 if PID==31
replace exclude_sens_why = "Data accuracy concerns due to technical difficulties for participant" if PID==31

*Save
cd "$Data"
save ValidationData_all.dta, replace 
