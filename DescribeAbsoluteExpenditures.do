/*Expenditures and correlations*/

*Bring in data
cd "$Data"
use "ValidationData_all.dta", clear

*Drop folks who we are excluding from all analyses
drop if exclude_all==1

*Calculate median and IQR total expenditures by category and store 

foreach catg in $catglist All {
	foreach store in Lolas Walmart {
		*Calculate pctiles and store in matrices
		*Divide by 100 to get amounts in $ (vs. cents)
		*Median
		_pctile Spend`catg'_ttl`store', p(50)
		mat Spend`catg'ttlp50`store'=r(r1)/100
		
		*p25
		_pctile Spend`catg'_ttl`store', p(25)
		mat Spend`catg'ttlp25`store'=r(r1)/100
		
		*p75
		_pctile Spend`catg'_ttl`store', p(75)
		mat Spend`catg'ttlp75`store'=r(r1)/100
	}
}

*********************
*Output to excel
*********************

*Set the file
capture rm "$Results/DescribeAbsoluteExpenditures.xlsx"
putexcel set "$Results/DescribeAbsoluteExpenditures.xlsx", replace 

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

local row = 3
	foreach catg in $catglist All {
		putexcel A`row' = ("`catg'")
		putexcel B`row' =matrix(Spend`catg'ttlp50Lolas), nformat(0.00)
		putexcel C`row' =matrix(Spend`catg'ttlp25Lolas), nformat("(0.00")
		putexcel D`row' =matrix(Spend`catg'ttlp75Lolas), nformat(", 0.00)")
		
		putexcel E`row' =matrix(Spend`catg'ttlp50Walmart), nformat(0.00)
		putexcel F`row' =matrix(Spend`catg'ttlp25Walmart), nformat("(0.00")
		putexcel G`row' =matrix(Spend`catg'ttlp75Walmart), nformat(", 0.00)")
		
	
		local ++row	
	}

