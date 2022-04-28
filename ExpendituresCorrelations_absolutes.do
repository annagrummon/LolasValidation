/*Expenditures and correlations*/

*Bring in data
cd "$Data"
use "ValidationData_all.dta", clear

*Drop folks who we are excluding from all analyses
drop if exclude_all==1

global catglist Bread Cereal Dairy Eggs Entrees FruitVeg NonSSBs MeatSeafood Nuts PastaRice SaltySnacks Sauces Sweets SSBs Other 

*Calculate median and IQR total expenditures by category and store 

foreach catg in $catglist {
	foreach store in Lolas Walmart {
		*Median
		_pctile Spend`catg'_ttl`store', p(50)
		mat Spend`catg'ttlp50`store'=r(r1)
		
		*p25
		_pctile Spend`catg'_ttl`store', p(25)
		mat Spend`catg'ttlp25`store'=r(r1)
		
		*p75
		_pctile Spend`catg'_ttl`store', p(75)
		mat Spend`catg'ttlp75`store'=r(r1)
	}
}

*Calculate median and IQR proportion of expenditures by category and store 

foreach catg in $catglist {
	foreach store in Lolas Walmart {
		*Median
		_pctile Spend`catg'_prop`store', p(50)
		mat Spend`catg'ttlp50`store'=r(r1)
		
		*p25
		_pctile Spend`catg'_prop`store', p(25)
		mat Spend`catg'ttlp25`store'=r(r1)
		
		*p75
		_pctile Spend`catg'_prop`store', p(75)
		mat Spend`catg'ttlp75`store'=r(r1)
	}
}



*Calculate Spearman's rho and pvalues by category
foreach catg in $catglist {
	spearman Spend`catg'_propLolas Spend`catg'_propWalmart
	mat `catg'_rho = r(rho)
	mat `catg'_p = r(p)
	
}
*********************
*Output to excel
*********************

*Set the file
capture rm "$Results/ExpendituresCorrelations_abs.xlsx"
putexcel set "$Results/ExpendituresCorrelations_abs.xlsx", replace 

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
	foreach catg in $catglist {
		putexcel A`row' = ("`catg'")
		putexcel B`row' =matrix(Spend`catg'ttlp50Lolas), nformat(#.#0)
		putexcel C`row' =matrix(Spend`catg'ttlp25Lolas), nformat("(#.#0")
		putexcel D`row' =matrix(Spend`catg'ttlp75Lolas), nformat(", #.#0)")
		
		putexcel E`row' =matrix(Spend`catg'ttlp50Walmart), nformat(#.#0)
		putexcel F`row' =matrix(Spend`catg'ttlp25Walmart), nformat("(#.#0")
		putexcel G`row' =matrix(Spend`catg'ttlp75Walmart), nformat(", #.#0)")
		
		
		putexcel H`row'=matrix(`catg'_rho), nformat(#.#0)
		putexcel I`row'=matrix(`catg'_p), nformat(0.#00)
		
		local ++row	
	}

