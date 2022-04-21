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
	
	count if age_cat==2
	mat age_cat_n2 = r(N)
	mat age_cat_prop2 = age_cat_n2[1,1] / age_cat_totaln[1,1]
	

	*Example of loop
	foreach level in 1 2 3 4 {
		count if age_cat==`level'
		mat age_cat_n`level' = r(N)
		mat age_cat_prop`level' = age_cat_n`level'[1,1] / age_cat_totaln[1,1]
	}
	

*Gender categories 
	*Count non-missing observations
	count if gender_cat!=. 
	mat gender_cat_totaln = r(N)
	
	*If you're unsure how levels are encoded (represented numerically, i.e., what numbers are associated with each level of the variable, you can type tab variablename, nolabel)
	tab gender_cat, nolabel
	
	foreach gender in 1 2 3 {
		count if gender_cat==`gender'
		mat gender_cat_n`gender' = r(N)
		mat gender_cat_prop`gender' = gender_cat_n`gender'[1,1] / gender_cat_totaln[1,1]
	}
	
	
/*syntax for foreach loops
	foreach nameoflocalvariable in list of things to loop over {
		everything inside the brackets will be repeated for each item in the list
		
	}
	
	foreach name in "Violet" "Anna Claire" {
		display "Hello `name'"
	}
	
	foreach university in "UNC" "NC State" "Duke" {
		display "`university' is the best!"
	}
	
	foreach number in 2 5 7 9 {
		di `number' + `number'
	}
	
*/
	
******************
*Export to Excel
******************

*Remove the output file. Include "capture" so the command runs even if this file doesn't exist. 
	capture rm "$Results/Table1.xlsx"
		
*Set filename for our Sample Characteristics table
	putexcel set "$Results/Table1.xlsx" , replace
	
*Add column headers. Make them bold
	putexcel A1=("Characteristic"), bold
	putexcel B1=("%"), bold
	putexcel C1=("N"), bold

*Add row labels
	putexcel A2 = ("Age")
	putexcel A3 = ("18-29 years")
	putexcel A4 = ("30-39 years")
	putexcel A5 = ("40-49 years")
	putexcel A6 = ("50 years or older")

	*To do: finish rest of row labels
	
	
*Add statistics to table
	putexcel B3 = matrix(age_cat_prop1), nformat(##%)
	putexcel C3 = matrix(age_cat_n1), nformat(##)
	
	putexcel B4 = matrix(age_cat_prop2), nformat(##%)
	putexcel C4 = matrix(age_cat_n2), nformat(##)
	
	putexcel B5 = matrix(age_cat_prop3), nformat(##%)
	putexcel C5 = matrix(age_cat_n3), nformat(##)
	
	putexcel B6 = matrix(age_cat_prop4), nformat(##%)
	putexcel C6 = matrix(age_cat_n4), nformat(##)
	
	
	*Gender
	putexcel B8 = matrix(gender_cat_prop1), nformat(##%)
	putexcel C8 = matrix(gender_cat_n1), nformat(##)
	
	
	**ANNA CLAIRE ADD OUTPUT FOR RACE, EDUC, INCOM
	***
	***
	
	***VIOLET ADD OUTPUT FOR BUDGET, HH SIZE, NUMBER OF CHILDREN
	
