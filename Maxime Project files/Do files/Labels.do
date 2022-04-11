// Created: 11-15-21
// Modified: 2-25-22
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Defining and assigning value and variable labels

// Value labels

label define arm ///
	1 "Control" ///
	2 "WL" ///
	3 "T" ///
	4 "WLT", modify

label define education ///
	1 "Less than high school" ///
	2 "High school diploma" ///
	3 "Associate or technical degree" ///
	4 "4-year college degree" ///
	5 "Graduate degree", modify

label define ethnicity ///
	1 "Not of Hispanic, Latino, or Spanish origin" ///
	2 "Mexican, Mexican American, or Chicano" ///
	3 "Cuban" ///
	4 "Other", modify

label define income ///
	1 "< $10,000" ///
	2 "$10,000-$14,999" ///
	3 "$15,000-$24,999" ///
	4 "$25,000-$34,999" ///
	5 "$35,000-$49,999" ///
	6 "$50,000-$74,999" ///
	7 "$75,000-$99,999" ///
	8 "$100,000-$149,999" ///
	9 "$150,000-$199,999" ///
	10 "> $199,999", modify

label define online_shop ///
	1 "None" ///
	2 "Less than half" ///
	3 "About half" ///
	4 "More than half" ///
	5 "All", modify

label define political ///
	1 "Liberal" ///
	2 "Moderate" ///
	3 "Conservative", modify

label define likert_healthy ///
	1 "Very unhealthy" ///
	2 "Somewhat unhealthy" ///
	3 "Neither healthy nor unhealthy" ///
	4 "Somewhat healthy" ///
	5 "Very healthy", modify

label define likert_not ///
	1 "Not at all" ///
	2 "Very little" ///
	3 "Somewhat" ///
	4 "Quite a bit" ///
	5 "A great deal", modify

label define likert_agree ///
	1 "Strongly disagree" ///
	2 "Disagree" ///
	3 "Neither agree nor disagree" ///
	4 "Agree" ///
	5 "Strongly agree", modify
	
label define likert_bad ///
	1 "Very bad" ///
	2 "Somewhat bad" ///
	3 "Neither bad nor good" ///
	4 "Somewhat good" ///
	5 "Very good", modify

label define likert_cost ///
	1 "Very inexpensive" ///
	2 "Somewhat inexpensive" ///
	3 "Neither inexpensive nor expensive" ///
	4 "Somewhat expensive" ///
	5 "Very expensive", modify

label define likert_easy ///
	1 "Very difficult" ///
	2 "Difficult" ///
	3 "Neither difficult nor easy" ///
	4 "Easy" ///
	5 "Very easy", modify

capture label values arm arm
capture label values education education
capture label values ethnicity ethnicity
capture label values grocery grocery
capture label values income income
capture label values online_shop online_shop
capture label values political political
capture label values pph likert_healthy
capture label values ce_health ce_envt ce_price reduce_meat risk_cancer risk_envt likert_not
capture label values health_* envt_* likert_bad
capture label values cost_* likert_cost
capture label values easily_find enough felt_real anna* pol_tax pol_hwl pol_ewl likert_agree
capture label values process likert_easy

// Variable labels

capture label variable age "Age"
capture label variable arm "Arm"
capture label variable durationinseconds "Questionnaire completion time"
capture label variable education "Education level"
capture label variable ethnicity "Ethnicity"
capture label variable ethnicity_4_text "Country of ethnic origin"
capture label variable finished "Completed the questionnaire"
capture label variable gender "Gender"
capture label variable gender_text "Self-described gender"
capture label variable grocery "Household groceries done by the subject"
capture label variable income "Household income in the last 12 months"
capture label variable meat "Red meat consumption in the last 30 days"
capture label variable online_shop "Share of groceries done online in the last 30 days"
capture label variable political "Political orientation"
capture label variable race_1 "White"
capture label variable race_2 "Black or African American"
capture label variable race_3 "American Indian or Alaskan Native"
capture label variable race_4 "Asian"
capture label variable race_5 "Pacific Islander"
capture label variable race_6 "Race not listed"
capture label variable race_6_text "Self-described race"
capture label variable pph "Perceived healthfulness of eating red meat"
capture label variable risk_cancer "Perceived risk of cancer from eating red meat"
capture label variable risk_envt "Perceived environmental harm of eating red meat"
capture label variable ce_health "Thinking about the health harms of products while shopping"
capture label variable ce_envt "Thinking about the environmental harm of products while shopping"
capture label variable ce_price "Thinking about the price of products while shopping"
foreach product in burger pizza ham {
	capture label variable health_`product' "Perceived health benefits or harms of the `product' product"
	capture label variable envt_`product' "Perceived environmental benefits or harms of the `product' product"
	capture label variable cost_`product' "Perceived cost of the `product' product"
}
capture label variable reduce_meat "Intention to reduce red meat consumption in the next 30 days"
capture label variable pol_tax "Support for a tax on red meat products"
capture label variable pol_hwl "Support for a health WL on red meat products"
capture label variable pol_hwl "Support for a health WL on red meat products"
capture label variable pol_ewl "Support for an enviromnental WL on red meat products"
capture label variable easily_find "Products were easy to find"
capture label variable enough "There were enough food and beverage options in the store"
capture label variable felt_real "The store was realistic"
capture label variable anna_1 "I would pick similar products in a real store"
capture label variable anna_2 "I picked similar products to what I usually buy"
capture label variable process "Difficulty using the store"