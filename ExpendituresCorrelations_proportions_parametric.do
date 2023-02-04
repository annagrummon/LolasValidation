/*Expenditures and correlations*/

*Bring in data
cd "$Data"
use "ValidationData_all.dta", clear

*Drop folks who we are excluding from all analyses
drop if exclude_all==1

global catglist Bread Cereal Dairy Eggs Entrees FruitVeg NonSSBs MeatSeafood Nuts PastaRice SaltySnacks Sauces SSBs Sweets Other 

*Calculate mean and SD of proportional expenditures by category and store 

foreach catg in $catglist {
	foreach store in Lolas Walmart {
		sum Spend`catg'_prop`store'
		mat Spend`catg'_propmean`store'=r(mean)
		mat Spend`catg'_propSD`store'=r(sd)
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
capture rm "$Results/ExpendituresCorrelations_prop_parametric.xlsx"
putexcel set "$Results/ExpendituresCorrelations_prop_parametric.xlsx", replace 

*Add column headers
putexcel A2=("Category")
putexcel B1=("Lola's")
putexcel B2=("Mean")
putexcel C2=("SD")
putexcel D1=("Walmart")
putexcel D2=("Median")
putexcel E2=("SD")
putexcel F2=("pvalue for ttest")
putexcel G2=("Pearson's r")
putexcel H2=("p-value for r")


local row = 3
	foreach catg in $catglist {
		putexcel A`row' = ("`catg'")
		putexcel B`row' =matrix(Spend`catg'_propmeanLolas), nformat(0.0%)
		putexcel C`row' =matrix(Spend`catg'_propSDLolas), nformat("(0.0%)")
		putexcel D`row' =matrix(Spend`catg'_propmeanWalmart), nformat(0.0%)
		putexcel E`row' =matrix(Spend`catg'_propSDWalmart), nformat("(0.0%)")
		
		putexcel F`row'=matrix(`catg'_ttestp), nformat(0.00)
		putexcel G`row'=matrix(`catg'_r), nformat(#.#0)
		putexcel H`row'=matrix(`catg'_rhop), nformat(0.000)
				
		*Replace pvalues <0.001 with "<0.001" 
		local p = `catg'_rhop[1,1]
		if `p'<0.001 {
			putexcel H`row'=("<0.001")
		}
	
		local ++row	
	}

*Overwrite format for p-diffs that need 3 decimals
foreach cell in "F9" "F13" {
	putexcel `cell', overwritef nformat(0.000)
}
