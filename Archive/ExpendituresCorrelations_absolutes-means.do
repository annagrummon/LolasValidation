/*Expenditures and correlations*/

*Bring in data
cd "$Data"
use "ValidationData_all.dta", clear

*Drop folks who we are excluding from all analyses
drop if exclude_all==1

global catglist Bread Cereal Dairy Eggs Entrees FruitVeg NonSSBs MeatSeafood Nuts PastaRice SaltySnacks Sauces Sweets SSBs Other 

*Rescale all ttl variables to be in dollars not cents
foreach catg in $catglist {
	foreach store in Lolas Walmart {
		gen Spend`catg'_ttl`store'_usd = Spend`catg'_ttl`store'/100
	}
}

*Calculate Mean and SD total expenditures by category and store 
foreach catg in $catglist {
	foreach store in Lolas Walmart {
		*Mean and SD
		sum Spend`catg'_ttl`store'_usd
		mat Spend`catg'ttlmean`store'=r(mean)
		mat Spend`catg'ttlsd`store'=r(sd)
	}
}


*Calculate Spearman's rho and pvalues by category for total expenditures
foreach catg in $catglist {
	spearman Spend`catg'_ttlLolas Spend`catg'_ttlWalmart
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
putexcel B2=("Mean")
putexcel C2=("SD")
putexcel D2=("Walmart")
putexcel D2=("Mean")
putexcel E2=("SD")
putexcel F2=("Spearman's rho")
putexcel G2=("p-value")

local row = 3
	foreach catg in $catglist {
		putexcel A`row' = ("`catg'")
		putexcel B`row' =matrix(Spend`catg'ttlmeanLolas), nformat(#.#0)
		putexcel C`row' =matrix(Spend`catg'ttlsdLolas), nformat("(#.#0)")
		
		putexcel D`row' =matrix(Spend`catg'ttlmeanWalmart), nformat(#.#0)
		putexcel E`row' =matrix(Spend`catg'ttlsdWalmart), nformat("(#.#0)")
		
		putexcel F`row'=matrix(`catg'_rho), nformat(#.#0)
		putexcel G`row'=matrix(`catg'_p), nformat(0.#00)
		
		local ++row	
	}

