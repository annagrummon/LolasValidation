*Save cleaned data
cd "$Data/IntermediateData"
save "Survey_all_clean.dta", replace

*Easy
label define easy_use 1 "Very difficult" 2 "Difficult" 3 "Neither difficult nor easy" 4 "Easy" 5 "Very easy"
label values easy_use* easy_use 

*Collapsed version
	label define easyagree 1 "easy or very easy" 0 "neither, difficulty or  very difficult"
	label values easy_use_agreeL easy_use_agreeW easyagree

*Found things on list
label define find_list 1 "None" 2 "Some things" 3 "Most things" 4 "Almost everything" 5 "Everything"
label values find_list* find_list

*label values
	label define agreelist 1 "most, almost everything, everything" 0 "none, some" 
	label values find_list_agreeL find_list_agreeW agreelist 

*List
label variable find_list_agreeLolas "Most, almost, everything on list"
label variable find_list_agreeWalmart "Most, almost, everything on list"

*Label difficulty variables
foreach store in Lolas Walmart {
	label variable difficult_1_`store' "Nothing difficult"
	label variable difficult_2_`store' "Finding types"
	label variable difficult_3_`store' "Finding brands"
	label variable difficult_4_`store' "Within budget"
	label variable difficult_5_`store' "Search bar"
	label variable difficult_6_`store' "Pages load"
	label variable difficult_7_`store' "Adding items"
	label variable difficult_8_`store' "Removing items"
	label variable difficult_9_`store' "Finding info"
	label variable difficult_10_`store' "Selecting quant"
	label variable difficult_11_`store' "Navigating site"
	label variable difficult_12_`store' "Checking out [Lola's]"
	label variable difficult_13_`store' "Other difficulty"
}


*Label participate again
label define participate_again 1 "Definitely not willing" 2 "Probably not willing" 3 "Probably willing" 4 "Definitely willing"
label values participate_again* participate_again

*Label values
	label define agree4pt 1 "definitely or probably willing" 0 "definitely or probably NOT willing"
	label values participate_again_agreeL participate_again_agreeW agree4pt 
	
*Define agree/disagree label
label define agreedisagree 1 "Strong disagree" 2 "Somewhat disagree" 3 "Neither agree nor disagree" 4 "Somewhat agree" 5 "Strongly agree"

*Label all agree/disagree process evaluation items
label values easily_findL easily_findW enoughL enoughW pick_similarL pick_similarW similar_usualL similar_usualW felt_realL felt_realW agreedisagree

*Label collapsed PE variables 
	label define agree5pt 1 "Somewhat or strongly agree" 0 "Neither, somewhat or strongly disagree"
	label values easily_find_agree* enough_agree* pick_similar_agree* similar_usual_agree* felt_real_agree* agree5pt 

*Label categorical FFQ/BEVQ variables
label define BEVQFFQ_cat 0 "<1 time/week" 1 "1 time/week" 2 "2-3 times/week" 5 "4-6 times/week" 7 "1 time/week" 14 "2 times/day" 21 "3+ times/week"
label values soda_cat dietsoda_cat energy_cat dietenergy_cat sports_cat dietsports_cat water_cat fj100_cat fruitdrink_cat swtteacoff_cat teacoff_cat fruit_cat veg_cat friedpot_cat nonfriedpot_cat otherveg_cat BEVQFFQ_cat


label define age_cat 1 "18-29 years" 2 "30-39 years" 3 "40-49 years" 4 "50+ years"
label values age_cat age_cat


*Gender
label define gender 1 "Woman" 2 "Man" 3 "Non-binary" 4 "Prefer to self-describe"
label values gender gender

*Gender 3-cat
	label define gender_cat 1 "Woman" 2 "Man" 3 "Non-binary or self-describe"
	label values gender_cat gender_cat

*Education
label define education 1 "Less than HS" 2 "HS/GED" 3 "Some college" 4 "Associate's" 5 "Bacherlor's" 6 "Graduate/professional"
label values educ education

	
label define educ_cat 1 "HS or less" 2 "Some college" 3 "College degree" 4 "Graduate degree"
label values educ_cat educ_cat

	label variable loweduc "Some college or less"
	
*Race
label define race_cat 1 "White" 2 "Black" 3 "Amer Ind Alas Native" 4 "Asian or Pacific Islander" 5 "Other or multi-racial"
label values race_cat race_cat
label define raceeth 1 "NH White" 2 "NH Black" 3 "Latino(a)" 4 "NH other or multi"
label values raceeth raceeth

	
*Budget for groceries
label define budget 1 "<=$50" 2 "$51-$75" 3 "$76-$100" 4 "$101-$125" 5 "$126-$150" 6 "$151-$175" 7 "$176-$200" 8 "$201-$250" 9 "$251-$300" 10 "$301-$400" 11 ">$400"
label values budget budget

label define budget_cat 1 "<=$100" 2 "$101-$150" 3 "$151-$200" 4 "$201 or more"
label values budget_cat budget_cat


label variable onlinefeatures_1_ "Search bar"
label variable onlinefeatures_2 "Sort function"
label variable onlinefeatures_3 "Product ratings"
label variable onlinefeatures_4 "Best sellers"
label variable onlinefeatures_5 "Nutrition information"
label variable onlinefeatures_6 "Shopping lists"
label variable onlinefeatures_7 "Recipes"
label variable onlinefeatures_8 "Past purchases"
label variable onlinefeatures_9 "Filtering"
label variable onlinefeatures_10 "Health ratings"
label variable onlinefeatures_11_ "Pages for diets"
label variable onlinefeatures_12_ "None"

*Diet quality
label define dietqual 1 "Poor" 2 "Fair" 3 "Good" 4 "Very good" 5 "Excellent"
label values dietqual dietqual

*NFP use
label define nfpuse 1 "Never" 2 "Rarely" 3 "Sometimes" 4 "Most of the time" 5 "Always"
label values nfponline nfpstore nfpuse

	
label define hhsize 1 "1" 2 "2" 3 "3" 4 "4 or more"
label values hhsize_cat hhsize

	
label define children_cat 1 "0" 2 "1" 3 "2" 4 "3 or more"
label values children_cat children_cat

*Income categories - 10 category variable
label define income_10cat 1 "Less than $10,000" 2 "$10,000 to $14,999" 3 "$15,000 to $24,999" 4 "$25,000 to $34,999" 5 "$35,000 to $49,999" 6 "$50,000 to $74,999" 7 "$75,000 to $99,999" 8 "$100,000 to $149,999"  9 "$150,000 to $199,999" 10 "$200,000 or more"
label values income_10cat income_10cat


label define income_4cat 1 "<$25,000" 2 "$25,000 to 49,999" 3 "$50,000 to $99,999" 4 "$100,000+"
label values income_4cat income_4cat	


label variable difficult_study_1 "Nothing difficult" 
label variable difficult_study_2 "Finding appt times"
label variable difficult_study_3 "Remembering appts"
label variable difficult_study_4 "Having 2 appts"
label variable difficult_study_5 "Internet/computer issues"
label variable difficult_study_6 "Shopping in Walmart"
label variable difficult_study_7 "Shopping in Lola's'"
label variable difficult_study_8 "Answering survey questions"
label variable difficult_study_9 "Other study difficulty"

*Save cleaned data
cd "$Data/IntermediateData"
save "Survey_all_labeled.dta", replace
