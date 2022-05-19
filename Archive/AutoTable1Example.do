*Bring in data
webuse auto

*Learn about the data
codebook *

***************************************************************
*Calculate relevant statistics and store them in matrices
***************************************************************

	*Example 1: Mean and SD of mpg
	sum mpg //summarize mpg 
	mat mpg_mean = r(mean) //store a matrix called "mpg_mean" that contains the mean of mpg
	mat mpg_sd = r(sd) //store a matrix called "mpg_sd" that contains the SD of mpg
	
		*Let's check that worked
		matlist mpg_mean //This will display the matrix called mpg_mean 
		matlist mpg_sd
	
	************************************************
	*To do: Mean and SD of price
	************************************************
		sum price //summarize mpg 
	mat price_mean = r(mean) //store a matrix called "mpg_mean" that contains the mean of mpg
	mat price_sd = r(sd) //store a matrix called "mpg_sd" that contains the SD of mpg
	
		*Let's check that worked
		matlist price_mean //This will display the matrix called mpg_mean 
		matlist price_sd
	
	
	*Example 2: % and N of number of repairs
	*Stata doesn't store %s from tab easily. So we will calculate them by hand.
	*We will do this by counting nubmer of observations in each category of rep78.
	*Then we will divide those counts by the total number of observations with non-missing data on rep78 to get % in each category
	*Note that I updated this code from our meeting to revert back to storing these results as matrices. I will explain via email!
	
	count if rep78 !=. //count the number of observations that are not missing on the variable rep78 
	matrix rep78_totaln = r(N) //store this count in a matrix called "rep78_totaln"

	count if rep78==1 //count the number of observations that take on value 1 for rep78
	matrix rep78_n_1=r(N) //store this count in a matrix called "rep78_n_1"
		
	count if rep78==2 //and so on for rest of levels 2-5
	matrix rep78_n_2=r(N)
	
	count if rep78==3
	matrix rep78_n_3=r(N)
	
	count if rep78==4
	matrix rep78_n_4=r(N)
	
	count if rep78==5
	matrix rep78_n_5=r(N)
	
	/*The code below is updated from our meeting! Note that I added back in the [brackets]
	
	What's going on here, you ask? Well, recall above that we stores the numerator and denominator as matrices. Stata doesn't like to divide entire matrices by entire other matrices, b/c matrix division doesn't exist (truly!). BUT, Stata *will* allow us to divide a particular cell in a matrix by another particular cell in a matrix, because each cell of the matrix is a single number. And it's fine to divide numbers by other numbers (it's dividing whole matrices that's not possible). The brackets tell Stata which cell to use in our matrices. In our case, our matrices only have 1 cell, but Stata doesn't know that, so we still have to specify that we want to use the number stores in the first row and first column of the matrix. That's what the brackets do - they say, "find the number in matrixname[row number, column number]". So rep78_n_1[1,1] refers to the first row, first column of the matric called rep78_n_1. 
	
	FYI I remember the order of rows vs. columns by thinking of the soda "RC Cola." Row comes before column. (In our case, both row and column are 1, but as a general tip :-))
	
	So all the code below is doing is calculating our proportions by dividing the numbers we stored above, it was just clunky to do so b/c we stored them in matrices. But the matrices come in handy later. 
	*/
	
	mat rep78_prop_1 = rep78_n_1[1,1] / rep78_totaln[1,1]
	mat rep78_prop_2 = rep78_n_2[1,1] / rep78_totaln[1,1]
	mat rep78_prop_3 = rep78_n_3[1,1] / rep78_totaln[1,1]
	mat rep78_prop_4 = rep78_n_4[1,1] / rep78_totaln[1,1]
	mat rep78_prop_5 = rep78_n_5[1,1] / rep78_totaln[1,1]
	
	
/*We could have done the above set of commands with a loop, which I will teach you sometime :) Here is the code for that loop. You don't need to run this or understand it, but saving it here for reference. 
forval x=1/5 {
	count if rep78==`x'
	mat rep78_n_`x'=r(N)
	mat rep78_prop_`x'= rep78_n_`x'[1,1] / rep78_totaln[1,1]
}
*/
	
	*Let's check that our calculations of the proportions was successful
		matlist rep78_prop_1 
		matlist rep78_prop_2
		matlist rep78_prop_3 
		matlist rep78_prop_4 
		matlist rep78_prop_5 

	************************************************************
	*To do: Finish calcuating N and % for variable "foreign"	
	*************************************************************
	
	*Let's take a look at this variable
	tab foreign 
	tab foreign, nolabel //show the numeric variables not the labels
	
	*Let's get you started. First, count total observations that are non-missing for foreign and store
	count if foreign !=.
	matrix foreign_totaln = r(N)
	
	*Count number of observations that are domestic (foreign==0) and store as a matrix
	count if foreign==0
	matrix foreign_total_0=r(N)
	
	*Now your turn: count the number of observations that are foreign (foreign==1) and store...
	count if foreign==1
	matrix foreign_total_1=r(N)
	
	mat foreign_prop_1 = foreign_total_0[1,1] / foreign_totaln[1,1]
	mat foreign_prop_2 = foreign_total_1[1,1] / foreign_totaln[1,1]
	
******************
*Export to Excel
******************

*Remove the output file. Include "capture" so the command runs even if this file doesn't exist. 
	capture rm "$Results/AutoTable1VN.xlsx"
		
*Set filename for our Sample Characteristics table
	putexcel set "$Results/AutoTable1VN.xlsx" , replace
	
*Add column headers. Make them bold
	putexcel A1=("Characteristic"), bold
	putexcel B1=("Mean or %"), bold
	putexcel C1=("(SD) or (N)"), bold

*Add row labels
	*Example 1: MPG
	putexcel A2 = ("Gas mileage in MPG, mean (SD)")
	putexcel A3 = ("Price in USD, mean (SD)")
	putexcel A4 = ("Number of Repairs, % (N)")
	putexcel A5 = ("1")
	putexcel A6 = ("2")
	putexcel A7 = ("3")
	putexcel A8 = ("4")
	putexcel A9 = ("5")
	putexcel A10 = ("Domestic, % (N)")
	putexcel A11 = ("Foreign, % (N)")
	*To do: finish rest of row labels
	
	
*Add statistics to table
	*Example 1: MPG mean in cell B2 
	*Format to be a number with two significant digits.
	putexcel B2 = matrix(mpg_mean), nformat(#.#0)
		
	*And MPG SD in cell C2
	*Format to be a number with two sig digits and to be in parentheses
	putexcel C2 = matrix(mpg_sd), nformat("(#.#0)")
	
	putexcel B3 = matrix(price_mean), nformat(#.#0)
	putexcel C3 = matrix(price_sd), nformat("(#.#0)")
	
	
	************************************
	*To do: Add price results
	************************************
	
	
	
	

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
		
		
		putexcel B10 = matrix(foreign_prop_1), nformat(##%)
		putexcel B11 = matrix(foreign_prop_2), nformat(##%)
		
		putexcel C10 = matrix(foreign_total_0),  nformat("(##)")
		putexcel C11 = matrix(foreign_total_1),  nformat("(##)")
	************************************************************************
	*To do: Finish adding foreign/domestic statistics 
	************************************************************************
