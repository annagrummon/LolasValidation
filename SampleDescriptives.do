*Sample Descriptives

*Bring in the data
use "$Data/ValidationData_all.dta"
	
*Remove the Sample Characteristics output file
	capture rm "$Results/SampleCharacteristics.xlsx"
		
*Set filename for Sample Characteristics table
	putexcel set "$Results/SampleCharacteristics.xlsx" , replace
	
*Add column headers to Excel file
	putexcel A1=("Characteristic"), bold
	putexcel B1=("%"), bold
	putexcel C1=("N"), bold
			
