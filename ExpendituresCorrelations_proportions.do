/*Expenditures and correlations*/

*Bring in data
cd "$Data"
use "ValidationData_all.dta", clear

*Drop folks who we are excluding from all analyses
drop if exclude_all==1


*Calculate median and IQR proportion of expenditures by category and store 

foreach catg in $catglist_ordered {
	foreach store in Lolas Walmart {
		*Median
		_pctile Spend`catg'_prop`store', p(50)
		mat Spend`catg'prop50`store'=r(r1)
		
		*p25
		_pctile Spend`catg'_prop`store', p(25)
		mat Spend`catg'prop25`store'=r(r1)
		
		*p75
		_pctile Spend`catg'_prop`store', p(75)
		mat Spend`catg'prop75`store'=r(r1)
	}
}



*Calculate Spearman's rho and pvalues by category
foreach catg in $catglist_ordered {
	di "Category is `catg'"
	spearman Spend`catg'_propLolas Spend`catg'_propWalmart
	mat `catg'_rho = r(rho)
	mat `catg'_p = r(p)
	
}



*********************
*Output to excel
*********************

*Set the file
capture rm "$Results/ExpendituresCorrelations.xlsx"
putexcel set "$Results/ExpendituresCorrelations.xlsx", replace 

*Add column headers
putexcel A2=("Category")
putexcel B1=("Lola's")
putexcel B2=("Median")
putexcel C2=("p25")
putexcel D2=("p75")
putexcel E1=("Walmart")
putexcel E2=("Median")
putexcel F2=("p25")
putexcel G2=("p75")
putexcel H2=("Spearman's rho")
putexcel I2=("p-value")

local row = 3
	foreach catg in $catglist_ordered {
		putexcel A`row' = ("`catg'")
		putexcel B`row' =matrix(Spend`catg'prop50Lolas), nformat(0.0%)
		putexcel C`row' =matrix(Spend`catg'prop25Lolas), nformat("(0.0%")
		putexcel D`row' =matrix(Spend`catg'prop75Lolas), nformat(", 0.0%)")
		
		putexcel E`row' =matrix(Spend`catg'prop50Walmart), nformat(0.0%)
		putexcel F`row' =matrix(Spend`catg'prop25Walmart), nformat("(0.0%")
		putexcel G`row' =matrix(Spend`catg'prop75Walmart), nformat(", 0.0%)")
		
		
		putexcel H`row'=matrix(`catg'_rho), nformat(#.#0)
		putexcel I`row'=matrix(`catg'_p), nformat(0.#00)
		
		local ++row	
	}

