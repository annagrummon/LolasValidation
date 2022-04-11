************************************
*Data Prep: Merged Lola's Data
************************************

*Bring in categorized data
cd "$Data/IntermediateData"
use "LolasPurchases_all_coded.dta", clear


*Drop Summary actions - not needed b/c we will derive total spending. 

*First, retain total time taken by expanding this value across all rows for an id
bysort id: egen ShopTime_ms = max(TotalTimeTaken)

drop TotalTimeTaken

*Now drop Summary actions
drop if Action=="Summary"

*For each row, create a variable for total spent on each item = q * p
gen Spending=TotalPrice*Quantity 
assert Spending==TotalPrice*Quantity 

*For each row, assign spending to a category
foreach catg in Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice { 
	gen Spend`catg'=Spending if `catg'==1 
	replace Spend`catg'=0 if `catg'==0 
}

*For each id and category, calculate total spending in that category for that participant
foreach catg in Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice { 
	bysort id: egen Spend`catg'_ttl = total(Spend`catg')
}

*For each id, calculate total spending overall
bysort id: egen SpendAll_ttl = total(Spending) 

*Keep one row per participant
duplicates drop id, force

*For each id and category, calculate proportion of spending in that category (% of total) for that participant
foreach catg in Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice {  
	gen Spend`catg'_prop = Spend`catg'_ttl / SpendAll_ttl
}


*Drop variables we don't need
drop EventIndex UTCTimestamp ParticipantPublicID Action Category Product Quantity TotalPrice PackSize PackUnit updated servingspercontainer servingsize EnergyKCAL Fat SaturatedFat TransFat Carbohydrates Sugar Salt Fibre Protein Ingredients redmeat ShelfRank Aisle Department Shelf DeptAisleShelf  Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice Notes NumberCategories review SaltySnacks notes Spending SpendBread SpendCereal SpendDairy SpendEggs SpendEntrees SpendFruitVeg SpendMeatSeafood SpendNonSSBs SpendSaltySnacks SpendSauces SpendSSBs SpendSweets SpendOther SpendNuts SpendPastaRice


*Rename variables to include Lolas suffix
foreach v in SpendBread_ttl SpendCereal_ttl SpendDairy_ttl SpendEggs_ttl SpendEntrees_ttl SpendFruitVeg_ttl SpendMeatSeafood_ttl SpendNonSSBs_ttl SpendSaltySnacks_ttl SpendSauces_ttl SpendSSBs_ttl SpendSweets_ttl SpendOther_ttl SpendNuts_ttl SpendPastaRice_ttl SpendAll_ttl SpendBread_prop SpendCereal_prop SpendDairy_prop SpendEggs_prop SpendEntrees_prop SpendFruitVeg_prop SpendMeatSeafood_prop SpendNonSSBs_prop SpendSaltySnacks_prop SpendSauces_prop SpendSSBs_prop SpendSweets_prop SpendOther_prop SpendNuts_prop SpendPastaRice_prop {
	rename `v' `v'Lolas
}

cd "$Data/IntermediateData"
save "LolasPurchases_all_clean.dta", replace
