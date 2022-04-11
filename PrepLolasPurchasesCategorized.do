/*Import and process hand-coded Lola's purchases in our food categories*/

cd "$Data/Lolas"

import excel "LolasFoods_handcoded.xlsx", firstrow clear

*Check that all products are in a category
egen numcat = rowtotal(Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice)

replace SSBs=0 if Product=="Bolthouse Farms Protein Keto With 15g Protein, Dark Chocolate, 11 Oz"

replace FruitVeg=1 if Product=="Dippin' Stix Sliced Apples & Peanut Butter, 2.75 Oz"

drop numcat
egen numcat = rowtotal(Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice)

assert numcat==1

*Drop variables we don't need
drop numcat 

cd "$Data/IntermediateData"
save LolasFoods_handcoded.dta, replace
	