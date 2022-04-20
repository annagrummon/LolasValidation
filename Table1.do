*Bring in data
cd "$Data"
use "ValidationData_all.dta", clear

*Learn about the data
codebook *

***************************************************************
*Calculate relevant statistics and store them in matrices
***************************************************************

		
	
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
	
	
	
	
	
