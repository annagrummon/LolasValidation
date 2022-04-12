*Bring in data
webuse auto

*Learn about the data
codebook *

***************************************************************
*Calculate relevant statistics and store them in matrices
***************************************************************

	*Example 1: Mean and SD of mpg
	sum mpg 
	mat mpg_m = r(mean)
	mat mpg_sd = r(sd)
	
		*Let's check that worked
		matlist mpg_m
		matlist mpg_sd
	
	*To do: Mean and SD of price
	
	*Example 2: % and N of number of repairs
	*Stata doesn't store %s from tab easily. So we will calculate them by hand.
	*We will do this by counting nubmer of observations in each category of rep78.
	*Then we will divide those counts by the total number of observations with non-missing data on rep78 to get % in each category
	
	count if rep78!=.
	local rep78_totaln = r(N)
	
	forval x=1/5 {
		count if rep78==`x'
		mat rep78_n_`x'=r(N)
		mat rep78_prop_`x'= rep78_n_`x'[1,1] / `rep78_totaln'
	}
	
	*Let's check that worked
		matlist rep78_prop_1 
		matlist rep78_prop_2
		matlist rep78_prop_3 
		matlist rep78_prop_4 
		matlist rep78_prop_5 

	*To do: N and % for variable "foreign"	

	
	
******************
*Export to Excel
******************

*Remove the output file. Include "capture" so the command runs even if this file doesn't exist. 
	capture rm "$Results/AutoTable1.xlsx"
		
*Set filename for our Sample Characteristics table
	putexcel set "$Results/AutoTable1.xlsx" , replace
	
*Add column headers. Make them bold
	putexcel A1=("Characteristic"), bold
	putexcel B1=("Mean or %"), bold
	putexcel C1=("(SD) or (N)"), bold

*Add row labels
	*Example 1: MPG
	putexcel A2 = ("Gas mileage in MPG, mean (SD)")

	*To do: finish rest of row labels
	
	
*Add statistics to table
	*Example 1: MPG mean in cell B2 
	*Format to be a number with two significant digits.
	putexcel B2 = matrix(mpg_m), nformat(#.##)
	
	*And MPG SD in cell C2
	*Format to be a number with two sig digits and to be in parentheses
	putexcel C2 = matrix(mpg_sd), nformat("(#.##)")
	
	*To do: Add price results


	*Example 2: Repair history
		*Proportions - format as %s
		putexcel B5 = matrix(rep78_prop_1), nformat(##%)
		putexcel B6 = matrix(rep78_prop_2), nformat(##%)
		putexcel B7 = matrix(rep78_prop_3), nformat(##%)
		putexcel B8 = matrix(rep78_prop_4), nformat(##%)
		putexcel B9 = matrix(rep78_prop_5), nformat(##%)
		
		*N's - format with ()
		putexcel C5 = matrix(rep78_n_1), nformat("(##)")
		putexcel C6 = matrix(rep78_n_2),  nformat("(##)")
		putexcel C7 = matrix(rep78_n_3),  nformat("(##)")
		putexcel C8 = matrix(rep78_n_4),  nformat("(##)")
		putexcel C9 = matrix(rep78_n_5),  nformat("(##)")
		
	
	*To do: Finish adding foreign/domestic statistics 
	