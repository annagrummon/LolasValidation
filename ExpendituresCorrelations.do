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
		mat Spend`catg'propp50`store'=r(r1)
		
		*p25
		_pctile Spend`catg'_prop`store', p(25)
		mat Spend`catg'propp25`store'=r(r1)
		
		*p75
		_pctile Spend`catg'_prop`store', p(75)
		mat Spend`catg'propp75`store'=r(r1)
	}
}



*Calculate Spearman's rho and pvalues by category
foreach catg in $catglist {
	spearman Spend`catg'_propLolas Spend`catg'_propWalmart
	mat `catg'_rho = r(rho)
	mat `catg'_p = r(p)
	
}

*Output to excel
	foreach category in 
	putexcel C2 = matrix(mpg_sd), nformat("(#.#0)")
	
	putexcel B3 = matrix(price_mean), nformat(#.#0)
	putexcel C3 = matrix(price_sd), nformat("(#.#0)")
	