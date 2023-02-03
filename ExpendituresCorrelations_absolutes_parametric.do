/*Expenditures and correlations*/

*Bring in data
cd "$Data"
use "ValidationData_all.dta", clear

*Drop folks who we are excluding from all analyses
drop if exclude_all==1

global catglist Bread Cereal Dairy Eggs Entrees FruitVeg NonSSBs MeatSeafood Nuts PastaRice SaltySnacks Sauces Sweets SSBs Other 

*Calculate mean and SE of total expenditures by category and store 

foreach catg in $catglist {
	foreach store in Lolas Walmart {
		mean Spend`catg'_ttl`store'
		mat rtable=r(table)
		mat Spend`catg'_ttlmean`store'=rtable[1,1]
		mat Spend`catg'_ttlSE`store'=rtable[2,1]
	}
}

*Calculate mean and SE of proportional expenditures by category and store 

foreach catg in $catglist {
	foreach store in Lolas Walmart {
		mean Spend`catg'_prop`store'
		mat rtable=r(table)
		mat Spend`catg'_propmean`store'=rtable[1,1]
		mat Spend`catg'_propSE`store'=rtable[2,1]
	}
}

*Calculate Pearson's r and pvalues by category
foreach catg in $catglist {
	pwcorr Spend`catg'_propLolas Spend`catg'_propWalmart, sig
	mat `catg'_r = r(rho)
	mat rsig=r(sig)
	mat `catg'_rhop = rsig[2,1]
}

*Conduct paired t-tests to examine differences in spending between stores
foreach catg in $catglist {
	ttest Spend`catg'_propLolas==Spend`catg'_propWalmart
	mat `catg'_ttestp=r(p)
}

*********************
*Output to excel
*********************

*Set the file
capture rm "$Results/ExpendituresCorrelations_abs_parametric.xlsx"
putexcel set "$Results/ExpendituresCorrelations_abs_parametric.xlsx", replace 

*Add column headers
putexcel A2=("Category")
putexcel B1=("Lola's")
putexcel B2=("Mean")
putexcel C2=("SE")
putexcel D1=("Walmart")
putexcel D2=("Median")
putexcel E2=("SE")



local row = 3
	foreach catg in $catglist {
		putexcel A`row' = ("`catg'")
		putexcel B`row' =matrix(Spend`catg'_ttlmeanLolas), nformat(#.#0)
		putexcel C`row' =matrix(Spend`catg'_ttlSELolas), nformat("(#.#0)")
		putexcel D`row' =matrix(Spend`catg'_ttlmeanWalmart), nformat(#.#0)
		putexcel E`row' =matrix(Spend`catg'_ttlSEWalmart), nformat("(#.#0)")
		
		*putexcel F`row'=matrix(`catg'_ttestp), nformat(0.###)
		*putexcel G`row'=matrix(`catg'_rho), nformat(#.#0)
		*putexcel H`row'=matrix(`catg'_rhop), nformat(0.#00)
		
		local ++row	
	}

