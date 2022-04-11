************************************
*Data Prep: Walmart Selections (includes food categorizations)
************************************

*Bring in the data
foreach RA in ACT VN { 
	cd "$Data/WalmartPurchases/Categorized"
	import excel "WalmartPurchasesData_`RA'.xlsx", firstrow clear
	rename Priceperitem TotalPrice 

	save "$Data/IntermediateData/WalmartPurchasesData_`RA'.dta",  replace 

}

cd "$Data/IntermediateData"
use "WalmartPurchasesData_ACT.dta", clear

*Clean up Price Data
	*Replace missing price w/ Walmart current price
	replace TotalPrice="4.76" if PID==12 & Product==" Lucky Foods Seoul Vegan Kimchi, 14 oz"

	*Drop row that had all missing data
	drop if PID==82 & ItemNumber==24

	*Other price cannot be recovered b/c not enough information. Drop product.
	drop if PID==50 & ItemNumber==1

	destring TotalPrice, replace

*Append with Violet's data
append using "WalmartPurchasesData_VN.dta"

*Drop rows that are entirely missing
drop if PID==. 

destring Quantity, replace

replace Quantity=2 if PID==21 & Product=="Fresh, Green Bell Pepper, 1 Each"
replace Quantity=6 if PID==100 & ItemNumber==110
replace TotalPrice=.5 if PID==100 & ItemNumber==110


*Fill in missing Quantity data based on PDF of trip
replace Quantity=1 if PID==61 & ItemNumber==19

*Fix implausible prices based on current Walmart Prices and likely errors or other issues
replace TotalPrice=1.44 if PID==36 & Product=="Great Value Fat Free Half and Half, 32 fl oz" //looked like decimal was off  by 1 
replace TotalPrice=3.59 if PID==49 & Product=="Tinkyada Shells Brown Rice Pasta, 16 Oz" //looked like surge pricing. Replace with current price.
replace TotalPrice=3.29 if PID==49 & Product=="Tinkyada Gluten Free Organic Brown Rice Pasta Spirals, 12-Ounce (Pack of 6)" //same as above - used single item price

replace TotalPrice=7.98 if PID==80 & Product=="Cheetos Popcorn Tin, Flamin' Hot and Cheddar, 14 oz" //similar - current price is only 7.98, not 30.

*Convert to cents to avoid precision issues with 
foreach var in TotalPrice {
    replace `var' = round(`var' * 100,1) 
}

*For each row, create a variable for total spent on each item = q * p
gen Spending=TotalPrice*Quantity 
assert Spending==TotalPrice*Quantity 

*Ensure all foods have a category
	egen NumCat = rowtotal(Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice Alcohol)

	replace FruitVeg=1 if (Product=="Fresh Cilantro, Bunch" | Product=="2# Bag Limes") & NumCat==0
	replace SSBs=1 if (Product=="(12 Count) Gatorade Frost Thirst Quencher Sports Drink, Glacier Freeze, 12 oz Bottles" | Product=="(8 Bottles) Gatorade Thirst Quencher Sports Drink, Glacier Cherry, 20 fl oz" | Product=="A&W Caffeine-Free, Low Sodium Root Beer Soda Pop, 12 Fl Oz, 12 Pack Cans") & NumCat==0
	replace NonSSBs=1 if (Product=="(6 Pack) LIFEWTR Premium Purified Bottled Water, pH Balanced with Electrolytes For Taste, 1 Liter Bottles (Packaging May Vary)" | Product=="7UP Zero Sugar Lemon Lime Soda, 2 L bottle" | Product=="8 Bottles) Gatorade G Zero Thirst Quencher, Orange, 20 fl oz" | Product=="A&W Zero Sugar Root Beer Soda, 12 fl oz cans, 12 pack" | Product=="A&W Zero Sugar Root Beer Soda, 2 L bottle" | Product=="AHA Blueberry Pomegranate Sparkling Water, 12 Fl Oz, 8 Pack Cans" | Product=="Alkaline Water with Himalayan Minerals & Electrolytes, 1 Gallon") & NumCat==0
	replace Entrees=1 if Product=="(Chilled) Freshness Guaranteed No Antibiotics Ever Traditional Rotisserie Chicken, 1 Count" & NumCat==0
	replace MeatSeafood=1 if Product=="4 Cans) Great Value Chunk Light Tuna in Water, 5 oz" & NumCat==0
	replace SaltySnacks=1 if Product=="ACT II Butter Lovers Microwave Popcorn, 2.75 Oz, 12 Ct" & NumCat==0
	replace Dairy=1 if Product=="Activia Probiotic Strawberry & Blueberry Variety Pack Yogurt, 4 Oz. Cups, 12 Count" & NumCat==0
	replace Other=1 if (Product=="Great Value Vegetable Oil, 1 gal" | Product=="Great Value Vegetable Oil, 48 fl oz") & NumCat==0
	
	drop NumCat
	egen NumCat = rowtotal(Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice Alcohol)
	assert NumCat==1
	

*For each row, assign spending to a category
foreach catg in Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice Alcohol { 
	gen Spend`catg'=Spending if `catg'==1 
	replace Spend`catg'=0 if `catg'==0 
}

*For each id and category, calculate total spending in that category for that participant
foreach catg in Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice Alcohol { 
	bysort PID: egen Spend`catg'_ttl = total(Spend`catg')
}

*Calculate spending on alcohol (for descriptives)
egen SpendAlcohol_AllParticipants = total(SpendAlcohol)

*Calculate total spending all categories (for descriptives)
egen SpendAll_AllParticipants = total(Spending)

*Calculate % spending on Alcohol and store as global
global SpendPropAlcohol_AllParticipants = SpendAlcohol_AllParticipants/SpendAll_AllParticipants

*Drop alcohol variables
drop SpendAlcohol_AllParticipants SpendAll_AllParticipants SpendAlcohol_ttl 

*Drop alcohol spending
drop if Alcohol==1

*For each id, calculate total spending overall
bysort PID: egen SpendAll_ttl = total(Spending) 

*Keep one row per participant
duplicates drop PID, force

*Drop variables we don't need
drop ItemNumber Product Brand TotalPrice Quantity Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice Spending SpendBread SpendCereal SpendDairy SpendEggs SpendEntrees SpendFruitVeg SpendMeatSeafood SpendNonSSBs SpendSaltySnacks SpendSauces SpendSSBs SpendSweets SpendOther SpendNuts SpendPastaRice

*For each id and category, calculate proportion of spending in that category (% of total) for that participant
foreach catg in Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice {  
	gen Spend`catg'_prop = Spend`catg'_ttl / SpendAll_ttl
}

*Rename variables to include Walmart suffix
foreach v in SpendBread_ttl SpendCereal_ttl SpendDairy_ttl SpendEggs_ttl SpendEntrees_ttl SpendFruitVeg_ttl SpendMeatSeafood_ttl SpendNonSSBs_ttl SpendSaltySnacks_ttl SpendSauces_ttl SpendSSBs_ttl SpendSweets_ttl SpendOther_ttl SpendNuts_ttl SpendPastaRice_ttl SpendAll_ttl SpendBread_prop SpendCereal_prop SpendDairy_prop SpendEggs_prop SpendEntrees_prop SpendFruitVeg_prop SpendMeatSeafood_prop SpendNonSSBs_prop SpendSaltySnacks_prop SpendSauces_prop SpendSSBs_prop SpendSweets_prop SpendOther_prop SpendNuts_prop SpendPastaRice_prop {
	rename `v' `v'Walmart
}

cd "$Data/IntermediateData"
save "WalmartPurchases_clean.dta", replace
