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
	
*Latino(a)
	*Count non-missing observations
	count if latino!=.
	mat latino_totaln = r(N)
	
	*Count number Latino
	count if latino==1
	mat latino_n1 = r(N)
	
	*Calculate proportion Latino
	mat latino_prop1 = latino_n1[1,1] / latino_totaln[1,1]
	
*Income<200% FPL
	*Count non-missing observations
	count if fpl200!=.
	mat fpl200_totaln = r(N)
	
	*Count number Latino
	count if fpl200==1
	mat fpl200_n1 = r(N)
	
	*Calculate proportion Latino
	mat fpl200_prop1 = fpl200_n1[1,1] / fpl200_totaln[1,1]
	
	
*TO DO: Finish rest of calculations for remaining demographics and store
	
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
    putexcel A7 = ("Gender")
    putexcel A8 = ("Female")
    putexcel A9 = ("Male")
	putexcel A10 = ("Non-binary or another gender")
	putexcel A12 = ("Race")
	putexcel A13 = ("White")
	putexcel A14 = ("Black or African American")
	putexcel A15 = ("American Indian or Alaska Native")
	putexcel A16 = ("Asian or Pacific Islander")	
	putexcel A17 = ("Other or Multiracial")
	putexcel A18 = ("Education")
	putexcel A19 = ("High school diploma or less")
	putexcel A20 = ("Some college")
	putexcel A21 = ("College graduate or associates degree")
	putexcel A22 = ("Graduate degree")
	putexcel A23 = ("Household  income, annual")
	putexcel A24 = ("$0 to $24,999")
	putexcel A25 = ("$25,000 to $49,999")
	putexcel A26 = ("$50,000 to $99,999")
	putexcel A27 = ("$100,000 or more")
	putexcel A29 = ("Usual weekly grocery budget")
	putexcel A30 = ("$100 or less")
	putexcel A31 = ("$101 to $150")
	putexcel A32 = ("$151 to $200")
	putexcel A33 = ("$201 or more")
	putexcel A34 = ("Household size")
	putexcel A35 = ("1")
	putexcel A36 = ("2")
	putexcel A37 = ("3")
	putexcel A38 = ("4 or more")
	putexcel A39 = ("Number of children")
	putexcel A40 = ("0")
	putexcel A41 = ("1")
	putexcel A42 = ("2")
	putexcel A43 = ("3 or more")
	*To do: finish rest of row labels
	putexcel A11=("Latino(a) or Hispanic")
	
	
	putexcel A28=("Household income <200% FPL")
	
	
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
	putexcel B9 = matrix(gender_cat_prop2), nformat(##%)
	putexcel C9 = matrix(gender_cat_n2), nformat(##)
	putexcel B10 = matrix(gender_cat_prop3), nformat(##%)
	putexcel C10 = matrix(gender_cat_n3), nformat(##)
	
	*Latino or Hispanic
	putexcel B11 = matrix(latino_prop1), nformat(##%)
	putexcel C11 = matrix(latino_n1), nformat(##)
	
**ANNA CLAIRE ADD OUTPUT FOR RACE, EDUC, INCOM

*RACE
	count if race_cat!=.
	mat race_cat_totaln = r(N)
	
	foreach race in 1 2 3 4 5 {
	count if race_cat==`race'
	mat race_cat_n`race' = r(N)
	mat race_cat_prop`race' = race_cat_n`race'[1,1] / race_cat_totaln[1,1]
	}
	
	
*EDUC
	count if educ_cat!=.
	mat educ_cat_totaln = r(N)
	
	foreach educ in 1 2 3 4 {
	count if educ_cat==`educ'
	mat educ_cat_n`educ' = r(N)
	mat educ_cat_prop`educ' = educ_cat_n`educ'[1,1] / educ_cat_totaln[1,1]
	}
	
*INCOM
	count if income_4cat!=.
	mat incom_cat_totaln = r(N)
	
	foreach incom in 1 2 3 4 {
	count if income_4cat==`incom'
	mat incom_cat_n`incom' = r(N)
	mat incom_cat_prop`incom' = incom_cat_n`incom'[1,1] / incom_cat_totaln[1,1]
	}
	
	*Race
	putexcel B13 = matrix(race_cat_prop1), nformat(##%)
	putexcel C13 = matrix(race_cat_n1), nformat(##)
	putexcel B14 = matrix(race_cat_prop2), nformat(##%)
	putexcel C14 = matrix(race_cat_n2), nformat(##)
	putexcel B15 = matrix(race_cat_prop3), nformat(##%)
	putexcel C15 = matrix(race_cat_n3), nformat(##)
	putexcel B16 = matrix(race_cat_prop4), nformat(##%)
	putexcel C16 = matrix(race_cat_n4), nformat(##)
	putexcel B17 = matrix(race_cat_prop5), nformat(##%)
	putexcel C17 = matrix(race_cat_n5), nformat(##)
	
	*Education
	putexcel B19 = matrix(educ_cat_prop1), nformat(##%)
	putexcel C19 = matrix(educ_cat_n1), nformat(##)
	putexcel B20 = matrix(educ_cat_prop2), nformat(##%)
	putexcel C20 = matrix(educ_cat_n2), nformat(##)
	putexcel B21 = matrix(educ_cat_prop3), nformat(##%)
	putexcel C21 = matrix(educ_cat_n3), nformat(##)
	putexcel B22 = matrix(educ_cat_prop4), nformat(##%)
	putexcel C22 = matrix(educ_cat_n4), nformat(##)		
	
	*Income
	putexcel B24 = matrix(incom_cat_prop1), nformat(##%)
	putexcel C24 = matrix(incom_cat_n1), nformat(##)
	putexcel B25 = matrix(incom_cat_prop2), nformat(##%)
	putexcel C25 = matrix(incom_cat_n2), nformat(##)
	putexcel B26 = matrix(incom_cat_prop3), nformat(##%)
	putexcel C26 = matrix(incom_cat_n3), nformat(##)
	putexcel B27 = matrix(incom_cat_prop4), nformat(##%)
	putexcel C27 = matrix(incom_cat_n4), nformat(##)	
	
	***VIOLET ADD OUTPUT FOR BUDGET, HH SIZE, NUMBER OF CHILDREN
	*Note that Anna added income<200% FPL below
	
	count if budget_cat!=. 
	mat budget_cat_totaln = r(N)
	tab budget_cat, nolabel
	foreach budget in 1 2 3 4 {
	count if budget_cat==`budget'
	mat budget_cat_n`budget' = r(N)
	mat budget_cat_prop`budget' = budget_cat_n`budget'[1,1] / budget_cat_totaln[1,1]
	}
	
	count if hhsize_cat!=. 
	mat hhsize_cat_totaln = r(N)
	tab hhsize_cat
	foreach hhsize in 1 2 3 4 {
	count if hhsize_cat==`hhsize'
	mat hhsize_cat_n`hhsize' = r(N)
	mat hhsize_cat_prop`hhsize' = hhsize_cat_n`hhsize'[1,1] / hhsize_cat_totaln[1,1]
	}
	
	count if children_cat!=. 
	mat children_cat_totaln = r(N)
	tab children_cat
	foreach children in 1 2 3 4 {
	count if children_cat==`children'
	mat children_cat_n`children' = r(N)
	mat children_cat_prop`children' = children_cat_n`children'[1,1] / children_cat_totaln[1,1]
	}
	
	putexcel B30 = matrix(budget_cat_prop1), nformat(##%)
	putexcel C30 = matrix(budget_cat_n1), nformat(##)
	
	putexcel B31 = matrix(budget_cat_prop2), nformat(##%)
	putexcel C31 = matrix(budget_cat_n2), nformat(##)
	
	putexcel B32 = matrix(budget_cat_prop3), nformat(##%)
	putexcel C32 = matrix(budget_cat_n3), nformat(##)
	
	putexcel B33 = matrix(budget_cat_prop4), nformat(##%)
	putexcel C33 = matrix(budget_cat_n4), nformat(##)
	
	putexcel B35 = matrix(hhsize_cat_prop1), nformat(##%)
	putexcel C35 = matrix(hhsize_cat_n1), nformat(##)
	
	putexcel B36 = matrix(hhsize_cat_prop2), nformat(##%)
	putexcel C36 = matrix(hhsize_cat_n2), nformat(##)
	
	putexcel B37 = matrix(hhsize_cat_prop3), nformat(##%)
	putexcel C37 = matrix(hhsize_cat_n3), nformat(##)
	
	putexcel B38 = matrix(hhsize_cat_prop4), nformat(##%)
	putexcel C38 = matrix(hhsize_cat_n4), nformat(##)
	
	putexcel B40 = matrix(children_cat_prop1), nformat(##%)
	putexcel C40 = matrix(children_cat_n1), nformat(##)
	
	putexcel B41 = matrix(children_cat_prop2), nformat(##%)
	putexcel C41 = matrix(children_cat_n2), nformat(##)
	
	putexcel B42 = matrix(children_cat_prop3), nformat(##%)
	putexcel C42 = matrix(children_cat_n3), nformat(##)
	
	putexcel B43 = matrix(children_cat_prop4), nformat(##%)
	putexcel C43 = matrix(children_cat_n4), nformat(##)
	
	*Income less than 200% FPL
	putexcel B28=matrix(fpl200_prop1), nformat(##%)
	putexcel C28=matrix(fpl200_n1), nformat(##)
	
