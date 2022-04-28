*Process Evaluation

*Bring in data
cd "$Data"
use "ValidationData_all.dta", clear

*Drop folks who we are excluding from all analyses
drop if exclude_all==1

*Create global list of process variables in output order (smallest to largest for Lola's)
global processvars enough easy_use easily_find felt_real similar_usual pick_similar find_list participate_again

*Generate proportions and store them
foreach processvar in $processvars {
	foreach store in Lolas Walmart {
		sum `processvar'_agree`store'
		mat `processvar'`store'=r(mean)
	}
}

*Output to excel
capture rm "$Results/ProcessEval_output.xlsx"
putexcel set "$Results/ProcessEval_output.xlsx"

putexcel A1=("Outcome")
putexcel B1=("Lola's proportion")
putexcel C1=("Walmart proportion")

local row=2
foreach processvar in $processvars {
	putexcel A`row'=("`processvar'")
	putexcel B`row'=matrix(`processvar'Lolas), nformat(##%)
	putexcel C`row'=matrix(`processvar'Walmart), nformat(##%)
	local ++row
}

