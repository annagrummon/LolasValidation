*Bring in data
cd "$Data"
use "ValidationData_all.dta", clear

drop if exclude_all==1

*Learn about the data
codebook *

***************************************************************
*Calculate relevant statistics and store them in matrices
***************************************************************

*Age categories
	*First count total observations with non-missing age
	count if age_cat!=.
	mat age_cat_totaln = r(N)
	
	count if age_cat==1
	mat age_cat_n1 = r(N)
	mat age_cat_prop1 = age_cat_n1[1,1] / age_cat_totaln[1,1]
	
	
	foreach name in "Violet" "Anna Claire" {
		display "Hello `name'"
	}
	
	*Example of loop
	foreach level in 1 2 3 4 {
		count if age_cat==`level'
		mat age_cat_n`level' = r(N)
		mat age_cat_prop`level' = age_cat_n`level'[1,1] / age_cat_totaln[1,1]
	}
	

	
******************
*Export to Excel
******************

*Remove the output file. Include "capture" so the command runs even if this file doesn't exist. 
	capture rm "$Results/Table1.xlsx"
		
*Set filename for our Sample Characteristics table
	putexcel set "$Results/Table1.xlsx" , replace
	
*Add column headers. Make them bold
	putexcel A1=("Characteristic"), bold
	putexcel B1=("Mean or %"), bold
	putexcel C1=("(SD) or (N)"), bold

*Add row labels
	*Example 1: MPG
	putexcel A2 = ("Age")
	putexcel A3 = ("18-29 years")

	*To do: finish rest of row labels
	
	
*Add statistics to table
	
	
	
	
	
