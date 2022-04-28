*Correlation between FFQ and purchases
*Process Evaluation

*Bring in data
cd "$Data"
use "ValidationData_all.dta", clear

*Drop folks who we are excluding from all analyses
drop if exclude_all==1


*Calculate total consumption per week
egen ttlssbs = rowtotal(soda energy sports fruitdrink swtteacoff), missing
egen nonssbs = rowtotal(dietsoda dietenergy dietsports water fj100 teacoff), missing

*Excludes fried potatoes
egen ttlfv = rowtotal(fruit veg nonfriedpot otherveg), missing
