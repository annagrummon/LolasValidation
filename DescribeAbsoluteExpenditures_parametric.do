/*Expenditures and correlations*/

*Bring in data
cd "$Data"
use "ValidationData_all.dta", clear

*Drop folks who we are excluding from all analyses
drop if exclude_all==1

global catglist Bread Cereal Dairy Eggs Entrees FruitVeg NonSSBs MeatSeafood Nuts PastaRice SaltySnacks Sauces SSBs Sweets  Other 

*Calculate mean and SE of total expenditures by category and store 

foreach catg in All $catglist {
	foreach store in Lolas Walmart {
		sum Spend`catg'_ttl`store'
		mat rmean=r(mean)
		mat rsd=r(sd)
		mat Spend`catg'_ttlmean`store'=rmean[1,1]/100
		mat Spend`catg'_ttlSD`store'=rsd[1,1]/100
	}
}


*********************
*Output to excel
*********************

*Set the file
capture rm "$Results/DescribeExpenditures_abs_parametric.xlsx"
putexcel set "$Results/DescribeExpenditures_abs_parametric.xlsx", replace 

*Add column headers
putexcel A2=("Category")
putexcel B1=("Lola's")
putexcel B2=("Mean")
putexcel C2=("SD")
putexcel D1=("Walmart")
putexcel D2=("Mean")
putexcel E2=("SD")



local row = 3
	foreach catg in $catglist All {
		putexcel A`row' = ("`catg'")
		putexcel B`row' =matrix(Spend`catg'_ttlmeanLolas), nformat(#.#0)
		putexcel C`row' =matrix(Spend`catg'_ttlSDLolas), nformat("(#.#0)")
		putexcel D`row' =matrix(Spend`catg'_ttlmeanWalmart), nformat(#.#0)
		putexcel E`row' =matrix(Spend`catg'_ttlSDWalmart), nformat("(#.#0)")
		
		local ++row	
	}

