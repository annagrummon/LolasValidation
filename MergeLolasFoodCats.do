/*Merge Lola's Purchase Data with Food Categories*/

*Start by bringing in the purchase data
cd "$Data/IntermediateData"
use "LolasPurchases_all.dta", clear

*Merge purchase data with Crosswalk of DeptAisleShelf food categories
merge m:1 DeptAisleShelf using "$Data/IntermediateData/Crosswalk.dta"
assert _merge!=1 if Action!="Summary"
drop if _merge==2 //Drop if in using (Crosswalk) only

drop _merge

*Merge with handcoded purchases 
merge m:1 DeptAisleShelf Product using "$Data/IntermediateData/LolasFoods_handcoded.dta", force
drop _merge 

*Clean up

replace Dairy=1 if Product=="ChobaniÂ® Non-Fat Greek Yogurt, Plain 32oz"
replace Dairy=1 if Product=="Greek Gods Honey Greek Yogurt, 32 Oz. Tub"
replace Sweets=1 if Product=="Kraft Trios Snackfulls Colby And Monterey Jack, Semisweet Chocolate And Banana Chips, 2.25 Oz Package"
replace Sweets=1 if Product=="Perfect Bar, Dark Chocolate Peanut Butter W/ Sea Salt, 15g Protein, 2.3 Oz, 4 Ct"
replace SaltySnacks=1 if Product=="Philadelphia Bagel Chips & Garden Vegetable Cream Cheese Dip, 2.5 Oz Package"
replace SaltySnacks=1 if Product=="Philadelphia Bagel Chips And Strawberry Cream Cheese Dip, 2.5 Oz Package"
replace SaltySnacks=1 if Product=="SargentoÂ® Balanced BreaksÂ®, Colby-Jack Natural Cheese, Sea-Salted Peanuts And Blueberry Juice-Infused Dried Cranberries, 3-Pack"
replace SaltySnacks=1 if Product=="SargentoÂ® Balanced BreaksÂ®, Gouda Natural Cheese, Honey Roasted Peanuts And Dried Cranberries, 3-Pack"
replace Entrees=1 if Product=="Buttermilk Waffles, 24 Count, 29.6 Oz"
replace Entrees=1 if Product=="Buttermilk Waffles, 24 Count, 29.6 Oz" | Product=="Kellogg's Eggo Frozen Blueberry Waffles Easy Breakfast 12.3 Oz 10 Ct" | Product=="Kellogg's Eggo Frozen Buttermilk Waffles Easy Breakfast 29.6 Oz 24 Ct" | Product=="Kellogg's Eggo Homestyle Waffles Easy Breakfast 12.3 Oz 10 Ct" | Product=="Kellogg's Eggo, Frozen Waffles, Buttermilk, Easy Breakfast, 12.3 Oz, 10 Ct" | Product=="Kellogg's Eggo, Frozen Waffles, Homestyle, Family Pack, 2 Ct, 29.6 Oz" | Product=="Kellogg's Eggo Chocolatey Chip Waffles Easy Breakfast 12.3 Oz 10 Ct" | Product=="Kellogg's Eggo Chocolatey Chip Waffles Easy Breakfast 12.3 Oz 10 Ct"
replace Entrees=1 if Product=="Nasoya Organic Thai Basil Vegetable Dumplings, 9 Oz" | Product=="Imagine Foods Soup, Creamy Butternut Squash, 32 Fl Oz" | Product=="Imagine Foods Tomato Soup - Tomato Soup - Case Of 12 - 32 Oz." | Product=="Aunt Jemima Buttermilk Complete Pancake & Waffle Mix, 80 Oz Box" | Product=="KrusteazÂ® Light & Fluffy Buttermilk Complete Pancake Mix 32 Oz. Box" | Product=="Kellogg's Eggo Chocolatey Chip Waffles Easy Breakfast 12.3 Oz 10 Ct"
replace Sweets=1 if Product=="Traditional 9"" Pie Crusts, 15 Oz, 2 Count"
replace Sweets=1 if Product=="Whipped Topping, 16 Oz"
replace Meat=1 if Product=="All Natural* 85% Lean/15% Fat Angus Ground Beef Patties 4 Count, 1.33 Lb"
replace Entree=1 if Product=="Beef Stir Fry, 0.6 - 1.12 Lb"
replace Meat=1 if Product=="Gardein Ultimate Plant-Based Beefless Burger Frozen Patties, Vegan, Frozen, 12 Oz. 4-Count"
replace Sauces=1 if Product=="Jack Daniel's Pulled Beef With Jack Daniel's Barbeque Sauce, 16 Oz"
replace Entrees=1 if Product=="Marie Callender's Swedish Meatballs Bowl, Frozen Meals, 11.5 Oz."
replace Meat=1 if Product=="Boneless Skinless Chicken Breast, 3 Lb. (Frozen)"
replace Meat=1 if Product=="Chicken Breast Tenderloins, 3 Lb. (Frozen)"
replace Entrees=1 if Product=="Festive Ground Turkey Italian Roll, Frozen 1.0 Lbs"
replace Entrees=1 if Product=="TysonÂ® Any'tizersÂ® Popcorn Chicken, 24 Oz. (Frozen)"
replace Entrees=1 if Product=="TysonÂ® Fully Cooked Crispy Chicken Strips, 25 Oz. (Frozen)"
replace Entrees=1 if Product=="Caulipower Cauliflower Pizza Crusts, 2 Pack, 11 Oz (Frozen)"
replace Other=1 if Product=="Chatham Village, Croutons, Cheese & Garlic Large Cut, 5 Oz."
replace SaltySnacks=1 if Product=="Fresh Gourmet Crispy Onions, 3.5 Oz"
replace SaltySnacks=1 if Product=="Fresh Gourmet Red Peppers Salad Toppings, 3.5 Oz" | Product=="Fresh Gourmet Tri-Color Tortilla Strips, 3.5oz" | Product=="Fresh Gourmet Wonton Strips, 3.5oz"
replace FruitVeg =1 if Product=="Dippin' Stix Sliced Apples & Peanut Butter, 2.75 Oz" | Product=="Fruit & Cheese Snack Tray, 5.5 Oz" | Product=="Vegetable Tray With Meat And Cheese 38oz" | Product=="Dippin' Stix Sliced Apples & Peanut Butter, 2.75 Oz"
replace Sweets=1 if Product=="Cranberries & Glazed Walnuts 3.5 Oz"
replace SaltySnacks=1 if Product=="Emerald Nuts Natural Walnuts & Almonds With Dried Cherries, 100 Calorie Packs, 10 Ct" | Product=="Indulgent Trail Mix, 26 Oz." | Product=="Takis Fuego Flavored Tortilla Chips, 9.9 Oz" 
replace Sweets=1 if Product=="Perfect Bar, Peanut Butter, 17g Protein, 2.5 Oz, 4 Ct" | Product=="Pillsbury Refrigerated Pie Crusts, 2 Ct, 14.1 Oz Box" | Product=="Traditional 9"" Pie Crusts, 15 Oz, 2 Count" | Product=="Clif Bar Energy Bars, Chocolate Brownie, 9g Protein Bar, 6 Ct, 2.4 Oz (Packaging May Vary)" | Product=="Nature Valley Sweet & Salty Nut Chewy Granola Bars, Peanut, 6 Ct, 7.4 Oz" | Product=="Pop-Tarts Bites, Tasty Filled Pastry Bites, Frosted Strawberry, 14.1 Oz, 10 Ct" | Product=="Clif Builders Protein Bars, Gluten Free, 20g Protein, Chocolate Peanut Butter Flavor, 6 Ct, 2.4 Oz" | Product=="Quaker Chewy Granola Bars, 3 Flavor Variety Pack (36 Pack)" | Product=="Sunbelt Bakery Family Pack Chocolate Chip Chewy Granola Bars, 10.56 Oz" | Product=="Clif Kid Zbar Organic Granola Bars, Kids Snacks, Chocolate Brownie, 18 Ct, 1.27 Oz"

replace Meat = 1 if Product=="Boneless Skinless Chicken Breast, 5 Lb. (Frozen)" | Product == "Turtle Island Tofurky Deli Slices, 5.5 Oz" 

replace Sweets=1 if strpos(Product,"Traditional 9"" Pie Crusts, 15 Oz, 2 Count")

replace Other=1 if Product=="Nasoya Vegan Kimchi 14oz" 

replace Entree=1 if Product=="Veggie Chickn Nuggets" 

replace Sauce=1 if Product=="Heinz Organic Certified Tomato Ketchup, 14 Oz. Bottle" | Product=="Organic Ranch Dressing & Dip, 12 Fl Oz" | Product=="Organic Tomato Ketchup, 20 Oz" | Product=="Hoisin Sauce" | Product=="Original Syrup, 24 Fl Oz" | Product=="Aunt Jemima Butter Rich Syrup, 24 Oz Bottle" | Product=="Kikkoman Less Sodium Soy Sauce, 15 Oz" | Product=="Pizza Sauce, 23.9 Oz" | Product=="Smucker's Strawberry Jam, 32-Ounce" | Product=="Fischer's Honey 100% Natural Clover Honey Bear, Pure Honey, 12 Oz" | Product=="Hellmann's Real Mayonnaise Real Mayo Squeeze Bottle 20 Oz"

replace Nuts=1 if Product=="Organic Crunchy Stir And Enjoy Peanut Butter, 16 Oz" | Product=="Smucker's Organic Creamy Natural Peanut Butter, 16 Oz" | Product=="Organic Creamy Stir Peanut Butter, 16 Oz" | Product=="Organic Crunchy Stir And Enjoy Peanut Butter, 16 Oz" | Product=="Organic Creamy Stir Peanut Butter, 16 Oz" | Product=="Organic Crunchy Stir And Enjoy Peanut Butter, 16 Oz" | Product=="Jif Creamy Peanut Butter, 40-Ounce" | Product=="Peter Pan Original Peanut Butter Creamy Peanut Butter 40 Oz"

replace Pasta=1 if Product=="Gluten-Free Organic Brown Rice & Quinoa Penne Pasta, 16 Oz"

replace NonSSBs=1 if Product=="Gt's Enlightened Organic & Raw Kombucha Gingerade, 16 Fl. Oz." | Product=="Gt's Synergy Trilogy Kombucha Drink Organic & Raw, 16 Fl Oz" | Product=="Organic 100% Tart Cherry Juice" | Product=="Suja Organic Uber Greens, Cold Pressed Green Juice, 13.5 Oz" | Product=="Topo Chico Topo Chico Mineral Water, 12 Fl Oz"

replace SSBs=1 if Product=="Kevita Master Brew Kombucha, Pineapple Peach, 15.2 Oz Bottle" 

replace Pasta=1 if Product=="Nasoya Pasta Zero Shirataki Spaghetti 8 Oz. Bag" | Product=="Organic White Quinoa, 16 Oz"

replace FruitVeg=1 if Product=="Organic Black Beans, Canned 15 Oz" | Product=="Organic Chick Pea Garbanzo Beans, 15 Oz" | Product=="Organic No Salt Added Cut Green Beans, 14.5 Oz"

replace Other=1 if Product=="Organic Poultry Seasoning, 1.2 Oz" | Product=="Organic Extra Virgin Olive Oil 25.5 Fl Oz" | Product=="Organic Extra Virgin Olive Oil 51 Fl Oz" | Product=="Organic Italian Seasoning, 0.6 Oz" | Product=="Organic Oregano Leaves, 0.5 Oz" | Product=="Organic Tarragon, 0.4 Oz" | Product=="Organic Extra Virgin Olive Oil 25.5 Fl Oz" | Product=="Organic Extra Virgin Olive Oil 51 Fl Oz" | Product=="Organic Garlic Powder, 2.5 Oz" | Product=="Organic Herbs De Provence, 0.6 Oz" | Product=="Organic Raw Unfiltered Apple Cider Vinegar, 32 Fl Oz" | Product=="Argo 100% Pure Corn Starch, 16 Oz" | Product=="Carnation Evaporated Lowfat 2% Milk 12 Fl. Oz. Can" | Product=="Mccormick All Natural Pure Vanilla Extract, 2 Fl Oz" | Product=="Mccormick Gourmet Organic Pure Vanilla Extract, 2 Fl Oz" | Product=="Sweetened Coconut Flakes, 14 Oz" | Product=="All Purpose Flour, 25 Lbs" | Product=="All-Purpose Flour, 5 Lb" | Product=="All-Purpose Unbleached Flour, 5 Lb"

replace Other = 1 if Product=="Gold Medal Flour All-Purpose, 5 Lb Bag" | Product=="Maseca Tamal Gluten Free Instant Corn Masa Mix, 4.4 Lb" | Product=="Pillsbury Best All Purpose Flour, 5 Lb" | Product=="(250 Packets) Equal Zero Calorie Sweetener Packets, Sugar Substitute" | Product=="C&H 2lb Dark Brown Sugar Poly" | Product=="Florida Crystals Organic Raw Cane Sugar, 6 Lbs" | Product=="No Calorie Sweetener, 250 Count, 8.82 Oz" | Product=="Pure Granulated Sugar, 4 Lb" | Product=="Sugar In The Raw Turbinado Cane Sugar, 4 Lb" | Product=="Thai Kitchen Gluten Free Lite Coconut Milk, 13.66 Fl Oz" | Product=="Savia Coconut Milk, 13.5 Fl Oz" | Product=="Extra Spearmint Sugarfree Gum, Value Pack (8 Packs Total)" | Product=="Juicy Fruit Original Bubble Gum, Multipack (3 Packs)"

replace Cereal=1 if Product=="Annie's Breakfast Cereal, Cocoa Bunnies, Certified Organic, 10 Oz Box" | Product=="Cascadian Farm Organic Cinnamon Crunch Cereal 9.2 Oz" | Product=="Cascadian Farm, Organic Breakfast Cereal, Granola Oats & Honey, 16 Oz" | Product=="Nature's Path, Instant Oatmeal, Blueberry Cinnamon Flax, Organic, 8 Packets" | Product=="Organic Honey Crunch & Oats Breakfast Cereal, 14 Oz" | Product=="Organic Honey Nut Toasted Oats Breakfast Cereal, 12.25 Oz" | Product=="Organic Toasted Oats Breakfast Cereal, 12 Oz" | Product=="Organic Cinnamon Squares Breakfast Cereal, 12.2 Oz" | Product=="General Mills, Honey Nut Cheerios Gluten Free Breakfast Cereal, Family Size 19.5 Oz"




replace SSBs=0 if Product=="(12 Bottles) Lipton Diet Green Tea Citrus Iced Tea, 16.9 Fl Oz" 

replace SSBs=0 if Product=="(12 Cans) Red Bull Sugar Free Energy Drink, 8.4 Fl Oz" 
replace NonSSB=0 if Product=="(18 Count) Gatorade Thirst Quencher Sports Drink, Variety Pack (Fierce Grape, Strawberry, Berry), 12 Fl Oz" 
replace SSBs=0 if Product=="(6 Bottles) Gold Peak Diet Iced Tea, 16.9 Fl Oz" 
replace SSBs=0 if Product=="Apple & Eve 100% Juice, Variety Pack, 6.75 Fl Oz, Pack Of 32" | Product=="Aquafina Purified Water, 16.9 Fl Oz Bottles, 32 Count" | Product=="Bubly Sparkling Water, Cherry, 12 Oz Cans., 8 Count" | Product=="Diet Coke Soda Soft Drink, 12 Fl Oz, 24 Pack" | Product=="Ice Mountain Brand 100% Natural Spring Water, 16.9-Ounce Bottles (Pack Of 32)" | Product=="Juicy Juice Variety Pack 100% Juice, 6.75 Fl. Oz., 32 Count" | Product=="Lacroix Sparkling Water - Razz-Cranberry 8pk/12 Fl Oz Cans, 8 / Pack (Quantity)" | Product=="Nestle Pure Life Purified Water, 16.9 Fl Oz. Plastic Bottled Water (Pack Of 32)" | Product=="Purified Drinking Water Value Pack, 16.9 Fl Oz, 40 Count" | Product=="Purified Drinking Water, 16.9 Fl. Oz., 24 Count" | Product=="Sparkling IceÂ® Naturally Flavored Sparkling Water, Black Raspberry 17 Fl Oz, (Pack Of 12)" | Product=="Starbucks Cold Brew Coffee, Black Unsweetened, 11 Oz Glass Bottle" | Product=="Starbucks, Unsweetened Iced Coffee, 48 Fl. Oz." | Product=="Stok Unsweetened Cold Brew Coffee, 48 Fl. Oz." | Product == "Bolthouse Farms 100% Pomegranate Fruit Juice, 52 Oz" | Product=="Bolthouse Farms Green Goodness Fruit And Vegetable Juice, 52 Oz" | Product=="Bolthouse Farms Multi-V Goodness Cherry Fruit Juice With Vitamins, 11 Oz" | Product=="Bolthouse Farms Strawberry Banana Fruit Juice Smoothie, 11 Oz" 

replace SSBs=0 if Product=="Dole Orange Strawberry Banana 100% Juice, 59 Fl. Oz." | Product=="Dole, 100% Juice Pineapple Orange, 59 Fl. Oz." | Product=="Dole, 100% Pineapple Orange Banana, 59 Fl. Oz." | Product=="Naked Juice Boosted Smoothie, Green Machine, 46 Oz Bottle" | Product=="Naked Juice Fruit Smoothie, Mighty Mango, 64 Oz Bottle" | Product=="Naked Juice Fruit Smoothie, Pina Colada, 64 Oz Bottle" | Product=="Naked Juice Fruit Smoothie, Strawberry Banana, 15.2 Oz Bottle" | Product=="Pom Wonderful 100% Pomegranate Juice, 48 Ounce" | Product=="Bolthouse Farms Carrot Ginger Turmeric Vegetable Juice, 11 Oz" | Product=="Dole Orange Strawberry Banana 100% Juice, 59 Fl. Oz." | Product=="Bolthouse Farms Green Goodness Fruit And Vegetable Juice, 52 Oz" | Product=="Dole, 100% Juice Pineapple Orange, 59 Fl. Oz." | Product=="Dole, 100% Pineapple Orange Banana, 59 Fl. Oz." | Product=="Florida's Natural No Pulp Orange Juice 52 Oz." | Product=="Homemaker, Premium Squeezed Original Orange Juice, 59 Oz." | Product=="Simply Apple Juice, 52 Fl Oz" | Product=="Simply Orange High Pulp Orange Juice, 52 Fl Oz" | Product=="Tropicana, 100% Orange Juice Calcium + Vitamin D, No Pulp, 89 Fl. Oz." 

replace SSBs=0 if Product=="(6 Cans) Dole 100% Pineapple Juice, Canned Pineapple Juice, 6 Fl Oz" | Product=="100% Pure Orange Juice With Pulp, 59 Fl Oz" | Product=="Dole, 100% Pineapple Orange Banana, 59 Fl. Oz." | Product=="Florida's Natural With Pulp Orange Juice 52 Oz." | Product=="Homemaker, Premium Squeezed Original Orange Juice, 59 Oz." | Product=="Minute Maid Orange Juice, Fruit Juice Drink, 59 Fl Oz" | Product=="Mott's 100% Apple Juice, 64 Fl Oz Bottle" | Product=="No Pulp 100% Pure Orange Juice, 59 Fl Oz" | Product=="Ocean Spray 100% Juice,Cranberry, 101.4 Fl. Oz." | Product=="Orange Juice" | Product=="Original 100% Orange Juice, 64 Fl Oz" | Product=="Simply Apple Juice, 52 Fl Oz" | Product=="Simply Orange High Pulp Orange Juice, 52 Fl Oz" | Product=="Simply Orange Pulp Free Orange Juice, 2.63 Liters" | Product=="Simply Orange Pulp Free Orange Juice, 52 Fl Oz" | Product=="Tropicana Original No Pulp 100% Orange Juice, 52 Fl. Oz." | Product=="Tropicana Pure Premium, Homestyle, Some Pulp 100% Orange Juice, 89 Fl. Oz." | Product=="Tropicana Trop 50 No Pulp Orange Juice, 52 Fl. Oz." | Product=="Tropicana, 100% Orange Juice Calcium + Vitamin D, No Pulp, 89 Fl. Oz." | Product=="Juicy Juice 100% Apple Juice, 6.75 Fl. Oz., 8 Count" | Product=="Juicy Juice Variety Pack 100% Juice, 6.75 Fl. Oz., 32 Count"

replace SSBs=0 if Product=="Diet Dr Pepper Soda, 7.5 Fl. Oz., 6 Count" | Product=="Diet Mountain Dew Soda, 16.9 Oz Bottles, 6 Count" | Product=="Sprite Zero Sugar Lemon Lime Diet Soda Pop Soft Drink, 2 Liters" | Product=="Coke Zero Sugar Diet Soda Soft Drink, 12 Fl Oz, 24 Pack" | Product=="Coke Zero Sugar Diet Soda Soft Drink, 2 Liters" | Product=="Diet Coke Soda Soft Drink, 12 Fl Oz, 24 Pack" | Product=="Diet Coke Soda Soft Drink, 16.9 Fl Oz, 6 Pack" | Product=="Canada Dry Diet Ginger Ale, 0.5 L, 6 Count" | Product=="Diet Ginger Ale, 67.6 Fl Oz" | Product=="Diet A&W Root Beer, 2 L Bottle" | Product=="Dr Pepper Diet Soda, 12 Fl. Oz., 24 Count" | Product=="Aha Sparkling Water, Blueberry Pomegranate Flavored Water, Zero Calories, Sodium Free, No Sweeteners, 12 Fl Oz, 8 Pack" | Product=="Bubly Sparkling Water, Watermelon, 12 Oz Cans, 8 Count" | Product=="Clear American Black Cherry Sparkling Water, 33.8 Fl Oz"

replace SSBs=0 if Product=="Lacroix Sparkling Water - Cerise LimÃ³n (Cherry Lime) 8pk/12 Fl Oz Cans, 8 / Pack (Quantity)" | Product== "Lacroix Sparkling Water - Lemon 8pk/12 Fl Oz Cans, 8 / Pack (Quantity)" | Product=="Lacroix Sparkling Water - Limoncello 8pk/12 Fl Oz Cans, 8 / Pack (Quantity)" | Product=="Lacroix Sparkling Water - Pamplemousse 8pk/12 Fl Oz Cans, 8 / Pack (Quantity)" | Product=="Lacroix Sparkling Water - Tangerine 8pk/12 Fl Oz Cans, 8 / Pack (Quantity)" | Product=="S.pellegrino Sparkling Natural Mineral Water, 16.9 Fl Oz. Plastic Bottles (12 Count)" | Product=="(18 Count) Gatorade Zero Sugar Thirst Quencher, 3 Flavor Variety Pack, 12 Fl Oz" | Product=="(8 Count) Gatorade G Zero Thirst Quencher, Glacier Freeze, 20 Fl Oz" | Product=="Gatorade G Zero Thirst Quencher, Glacier Cherry, 32 Oz Bottle" | Product=="Propel Flavored Electrolyte Water Variety Pack, 16.9 Oz Bottles, 18 Count" | Product=="Pure Leaf Real Brewed Tea, Unsweetened Black Iced Tea, 59 Oz Bottle" | Product=="Unsweet Brewed Iced Tea, 128 Fl Oz" | Product=="Celestial Seasonings Herbal Tea Bags, Fruit Tea Sampler" | Product=="Lipton Gallon-Sized Iced Unsweetened Tea, Tea Bags 24 Oz 24 Count" | Product=="Lipton Gallon-Sized Iced Unsweetened Tea, Tea Bags 24 Oz 24 Count" | Product=="Tazo Zen Tea Bags Green Tea, 20 Tea Bags" | Product=="Tazo Zen Tea Green Tea Bags 48 Count" | Product=="Clear American Peach Sparkling Water, 33.8 Fl Oz" | Product=="Essentia Water; Better Rehydration* 1 Liter Bottles, Case Of 6" | Product=="Fiji Natural Artesian Water, 50.7 Fl. Oz." | Product=="Propel Berry Water Beverage 20 Fl. Oz. Bottle" | Product=="Smartwater Vapor Distilled Premium Water Bottle, 1 Liter" | Product=="Kool Aid Jammers Tropical Punch Artificially Flavored Drink, 10 Ct. Box" | Product=="(1 Bottle) Starbucks Cold Brew Coffee, Signature Black Multi-Serve Concentrate, 32 Fl Oz" | Product=="Monster Java Lo-Ball Coffee + Energy Drink, 15 Fl. Oz." | Product=="Rapid Fire Original Keto Coffee Instant Coffee Mix, 7.93 Oz Canister" | Product=="Naked Juice Fruit Smoothie, Strawberry Banana, 64 Oz Bottle" | Product=="Bai Coconut Flavored Water, Puna Coconut Pineapple, Antioxidant Infused Drink, 18 Fluid Ounce Bottle" | Product=="Bolthouse Farms Protein Keto With 15g Protein, Dark Chocolate, 11 Oz" | Product=="Gts Living Foods Organic & Raw Gingerade Kombucha 48 Oz" | Product=="Bolthouse Farms Berry Boost Fruit Juice Smoothie, 11 Oz" | Product=="Gt's Synergy Organic Kombucha Watermelon Wonder, 16 Fl Oz" | Product=="Bang Sour Heads Energy Drink, 16 Fl. Oz."

replace SSBs=0 if Product=="Naked Juice Boosted Smoothie, Blue Machine, 64 Oz Bottle" | Product=="Naked Juice Boosted Smoothie, Green Machine, 15.2 Oz Bottle" | Product=="Kool-Aid Jammers Artificially Flavored Drink, Zero Sugar Tropical Punch, 10 Ct. Box" | Product=="Coke Zero Sugar Diet Soda Soft Drink, 20 Fl Oz" | Product=="Peach Mango Green Tea Drink Mix, 0.08 Oz, 10 Count" | Product=="Stur Simply Strawberry Watermelon Liquid Water Enhancer, 1.62 Fl Oz" | Product=="Bang Blue Razz 4pk" | Product=="(12 Count) Gatorade Zero Sugar Thirst Quencher, Grape, 12 Fl Oz" | Product=="Kool Aid Jammers Tropical Punch Artificially Flavored Drink, 10 Ct. Box"

foreach Product in "Capri Sun Fruit Punch Flavored Juice Drink Blend, 30 Ct. Box" "Capri Sun Pacific Cooler Mixed Fruit Flavored Juice Drink Blend, 30 Ct. Box" "Coca-Cola Soda Soft Drink, 7.5 Fl Oz, 10 Pack" "Sam's Cola Soda, 12 Fl Oz, 24 Count" "Sprite Lemon Lime Soda Soft Drinks, 12 Fl Oz, 24 Pack" "Sprite Lemon Lime Soda Soft Drinks, 7.5 Fl Oz, 10 Pack" "Califia Farms Mocha Cold Brew Coffee With Almond Milk, Dairy Free, 48 Oz" "Dunkin Donuts French Vanilla Iced Coffee, 13.7 Fl. Oz." "Dunkin' Donuts French Vanilla Iced Coffee Bottles, 9.4 Fl Oz, 4 Pack" "International Delight Mocha Iced Coffee, Half Gallon" "International Delight Vanilla Iced Coffee, Half Gallon" "Starbucks Doubleshot Espresso & Cream, 6.5 Fl. Oz, (4-Pack)" "Starbucks Frappuccino Almond Milk Vanilla 13.7 Fluid Ounces Glass Bottle" "Starbucks Nitro Cold Brew, Vanilla Sweet Cream, 9.6 Oz Can" "Folgers French Vanilla Flavored Cappuccino, Instant Coffee Beverage Mix, 16-Ounce" "Hills Bros. White Chocolate Caramel Cappuccino Instant Coffee Mix, 16 Ounce Canister" "Snapple All Natural Apple Flavor, 6 Fl. Oz., 6 Count" "Goodbelly Probiotics Blueberry Acai Juice Drink, 1 Quart" "Kevita Sparkling Probiotic Drink, Lemon Ginger, 15.2 Oz Bottle" "Kevita Sparkling Probiotic, Lemon Ginger, 40 Oz Bottle" "Kevita Strawberry Acai Coconut Sparkling Probiotic Drink, 15.2 Fl. Oz."  "Minute Maid Premium Fruit Punch, 1.8 Quart, 59 Fl. Oz." "Minute Maid, Premium Berry Punch, 59 Fl. Oz." "Minute Maid, Premium Fruit Punch, 128 Fl. Oz." "Minute Maid, Premium Strawberry Lemonade, 59 Fl. Oz." "Minute Maid, Premium Tropical Punch, 59 Fl. Oz." "Simply Cranberry Cocktail Fruit Juice, 52 Fl Oz" "Simply Fruit Punch Juice, 52 Fl Oz" "Simply Lemonade With Raspberry, All Natural Non-Gmo, 52 Fl Oz" "Simply Lemonade, All Natural Non-Gmo, 52 Fl Oz" "Hawaiian Punch Fruit Juicy Red, 1 Gallon" "Kool Aid Jammers Tropical Punch Artificially Flavored Drink, 10 Ct. Box" "Kool-Aid Jammers Tropical Punch, Grape & Cherry Variety Pack, 30 Ct. Box" "Minute Maid Premium Fruit Punch, 1.8 Quart, 59 Fl. Oz." "Minute Maid, Premium Berry Punch, 59 Fl. Oz." "Minute Maid, Premium Fruit Drink Peach, 59 Fl. Oz." "Minute Maid, Premium Fruit Drink Watermelon, 59 Fl. Oz." "Minute Maid, Premium Mango Punch, 59 Oz." "Minute Maid, Premium Strawberry Lemonade, 59 Fl. Oz." "Minute Maid, Premium Tropical Punch, 59 Fl. Oz." "Simply Fruit Punch Juice, 52 Fl Oz" "Simply Lemonade With Raspberry, All Natural Non-Gmo, 2.63 Liters" "Simply Lemonade With Raspberry, All Natural Non-Gmo, 52 Fl Oz" "Simply Lemonade, All Natural Non-Gmo, 52 Fl Oz" "Coca-Cola Soda Soft Drink, 7.5 Fl Oz, 6 Pack" "Sprite Lemon Lime Soda Soft Drinks, 7.5 Fl Oz, 10 Pack" "Gosling's Ginger Beer, 6 Pack, 12 Fl Oz" "7up Lemon Lime Soda, 2 L Bottle" "Coca-Cola Cherry Soda Soft Drink, 2 Liters" "Fanta Caffeine-Free Orange Soda, 20 Fl. Oz." "Mountain Dew Voltage Raspberry Citrus Flavor And Ginseng Soda 20 Fl. Oz. Bottle" "Mountain Dew, 12 Oz Cans, 24 Count" "Mtn Dew Code Red, 20.0 Fl Oz" "Mtn Dew Frost Bite, 16.9 Oz Bottles, 6 Count" "Mtn Dew Liberty Brew, 20 Oz Bottle" "Sprite Lemon Lime Soda Soft Drink, 2 Liters" "Sprite Lemon Lime Soda Soft Drinks, 16.9 Fl Oz, 6 Pack" "Sunkist Orange Soda, 7.5 Fl Oz Mini Cans, 10 Pack" "Coca-Cola Orange Vanilla Soda Soft Drinks, 12 Fl Oz, 12 Pack" "Coca-Cola Soda Soft Drink, 12 Fl Oz, 12 Pack" "Coca-Cola Soda Soft Drink, 16.9 Fl Oz, 6 Pack" "Coca-Cola Soda Soft Drink, 2 Liters" "Pepsi Soda, 12 Oz Cans, 24 Count" "Pepsi Soda, 16.9 Oz Bottles, 12 Count" "Pepsi Soda, 2 Liter Bottle" "Pepsi Wild Cherry Flavored Soda, 2 L" "Pepsi Wild Cherry Flavored Soda, 7.5 Fl Oz, 6 Pack" "Sam's Cola Soda, 12 Fl Oz, 12 Count" "Sam's Cola, 67.6 Oz, 2 Liter" "Canada Dry Ginger Ale, .5 L Bottles, 6 Pack" "Canada Dry Ginger Ale, 2 L Bottle" "A&W Caffeine-Free Root Beer, 0.5 L, 6 Count" "Dr Pepper Soda, 7.5 Fl. Oz., 6 Count" "(4 Cans) Red Bull Energy Drink, 8.4 Fl Oz" "Bodyarmor Sports Drink,Watermelon Strawberry, 16 Fl. Oz., 1 Count" "(12 Count) Gatorade Thirst Quencher Sports Drink, Cool Blue, 12 Fl Oz" "(12 Count) Gatorade Thirst Quencher Sports Drink, Fruit Punch, 12 Fl Oz" "(8 Count) Gatorade Frost Thirst Quencher Sports Drink, Glacier Freeze, 20 Fl Oz" "(8 Count) Gatorade Thirst Quencher Sports Drink, Cool Blue, 20 Fl Oz" "Bodyarmor Sports Drink, Strawberry Banana, 16 Fl. Oz., 1 Count" "Powerade Mountain Berry Blast, 20 Fl Oz, 8 Pack" "Arizona Green Tea With Ginseng & Honey Tea, 1 Gallon" "Gold Peak Sweetened Black Iced Tea Drink, 89 Fl Oz" "Milo's All Natural Famous Sweet Tea, 1 Gallon, 128 Fl. Oz." "Natural Lemon Flavor Iced Tea Drink Mix, 66.1 Oz" "Oregon Chai Powdered Mix Chai Tea Latte The Original" "Nestle Rich Milk Chocolate Hot Cocoa Mix 6-0.71 Oz. Packets" "Ovaltine Rich Chocolate Drink Mix 18 Oz. Canister" "Swiss Miss Marshmallow Hot Cocoa Mix (30) 1.38 Ounce Envelopes" "Swiss Miss Marshmallow Hot Cocoa Mix (8) 1.38 Ounce Envelopes" "Swiss Miss Milk Chocolate Flavor Hot Cocoa Mix 1.38 Oz. 30-Count" "Welch's Concord Grape Fruit Juice Cocktail, 59 Fl. Oz." "Coca-Cola Cherry Soda Soft Drink, 20 Fl Oz" "Mtn Dew Soda 12-16.9 Fl. Oz. Bottles" "Coca-Cola Soda Soft Drink, 12 Fl Oz, 24 Pack" "(12 Count) Gatorade Thirst Quencher Sports Drink, Lemon Lime, 12 Fl Oz" "(8 Count) Gatorade Thirst Quencher Sports Drink, Lemon Lime, 20 Fl Oz" {
	replace NonSSB=0 if Product=="`Product'"
	
}

replace NonSS=1 if Product=="Kool Aid Jammers Tropical Punch Artificially Flavored Drink, 10 Ct. Box"

replace SSB=0 if Product=="Yoo-Hoo Chocolate Drink, 11 Fl. Oz., 12 Count"
replace NonSS=0 if Product=="Yoo-Hoo Chocolate Drink, 11 Fl. Oz., 12 Count"
replace Dairy=1 if Product=="Yoo-Hoo Chocolate Drink, 11 Fl. Oz., 12 Count"

replace SSB=0 if Product=="Talenti Dairy-Free Cold Brew Coffee Sorbetto, 1 Pint"
replace NonSS=0 if Product=="Talenti Dairy-Free Cold Brew Coffee Sorbetto, 1 Pint"
replace Sweet=1 if Product=="Talenti Dairy-Free Cold Brew Coffee Sorbetto, 1 Pint"

replace SSB=0 if Product=="Danimals Strawberry Explosion & Birthday Cake Variety Pack Smoothies, 3.1 Oz. Bottles, 12 Count"
replace NonSS=0 if Product=="Danimals Strawberry Explosion & Birthday Cake Variety Pack Smoothies, 3.1 Oz. Bottles, 12 Count"
replace Dairy=1 if Product=="Danimals Strawberry Explosion & Birthday Cake Variety Pack Smoothies, 3.1 Oz. Bottles, 12 Count"


replace SSB=0 if Product=="Yoo-Hoo Chocolate Drink, 6.5 Fl. Oz., 32 Count"
replace NonSS=0 if Product=="Yoo-Hoo Chocolate Drink, 6.5 Fl. Oz., 32 Count"
replace Dairy=1 if Product=="Yoo-Hoo Chocolate Drink, 6.5 Fl. Oz., 32 Count"


replace SSB=0 if Product=="Instant Nonfat Dry Milk, 64 Oz"
replace NonSS=0 if Product=="Instant Nonfat Dry Milk, 64 Oz"
replace Other=1 if Product=="Instant Nonfat Dry Milk, 64 Oz"



replace SSB=0 if Product=="Instant Nonfat Dry Milk, 3.2 Oz, 10 Count"
replace NonSS=0 if Product=="Instant Nonfat Dry Milk, 3.2 Oz, 10 Count"
replace Other=1 if Product=="Instant Nonfat Dry Milk, 3.2 Oz, 10 Count"

replace SSB=0 if Product=="Nestle Nido Fortificada Whole Milk Powder 12.6 Oz. Canister Powdered Milk Mix"
replace NonSS=0 if Product=="Nestle Nido Fortificada Whole Milk Powder 12.6 Oz. Canister Powdered Milk Mix"
replace Other=1 if Product=="Nestle Nido Fortificada Whole Milk Powder 12.6 Oz. Canister Powdered Milk Mix"

replace SSB=0 if Product=="Core Power 8 Fl Oz 4 Pack - 24g Chocolate Core Power Protein Drink By Fairlife Milk"
replace NonSS=0 if Product=="Core Power 8 Fl Oz 4 Pack - 24g Chocolate Core Power Protein Drink By Fairlife Milk"
replace Dairy=1 if Product=="Core Power 8 Fl Oz 4 Pack - 24g Chocolate Core Power Protein Drink By Fairlife Milk"


replace SSB=0 if Product=="Hershey's Cocoa Powder 100% Cacao, Natural Unsweetened Chocolate, 8 Oz."
replace NonSS=0 if Product=="Hershey's Cocoa Powder 100% Cacao, Natural Unsweetened Chocolate, 8 Oz."
replace Other=1 if Product=="Hershey's Cocoa Powder 100% Cacao, Natural Unsweetened Chocolate, 8 Oz."


replace SSB=0 if Product=="Jet-Puffed Miniature Marshmallows, 16 Oz Bag"
replace NonSS=0 if Product=="Jet-Puffed Miniature Marshmallows, 16 Oz Bag"
replace Sweets=1 if Product=="Jet-Puffed Miniature Marshmallows, 16 Oz Bag"

replace SSB=0 if Product=="Activia Probiotic Dailies Strawberry & Blueberry Yogurt Drink, Variety Pack, 3.1 Oz., 8 Count"
replace NonS=0 if Product=="Activia Probiotic Dailies Strawberry & Blueberry Yogurt Drink, Variety Pack, 3.1 Oz., 8 Count"

replace SSB=0 if Product=="ChobaniÂ® Greek Yogurt Drink, Strawberry Banana 7oz"
replace NonSS=0 if Product=="ChobaniÂ® Greek Yogurt Drink, Strawberry Banana 7oz"

replace SSB=0 if Product=="Fairlife 2% Reduced-Fat Chocolate Milk, 11.5 Fl. Oz."
replace NonSSB=0 if Product=="Fairlife 2% Reduced-Fat Chocolate Milk, 11.5 Fl. Oz."

replace SSB=0 if Product=="Lifeway Plain Kefir, Low Fat Milk Protein Probiotic Drink, 32 Oz."
replace NonS=0 if Product=="Lifeway Plain Kefir, Low Fat Milk Protein Probiotic Drink, 32 Oz."

replace SSB=0 if Product=="Siggi's Vanilla Whole Milk Yogurt Drink, 8 Fl. Oz."
replace NonS=0 if Product=="Siggi's Vanilla Whole Milk Yogurt Drink, 8 Fl. Oz."

replace Entree=0 if Product=="Beef Stir Fry, 0.6 - 1.12 Lb"
replace Meat=1 if Product=="Beef Stir Fry, 0.6 - 1.12 Lb"

replace Sauce=0 if Product=="Organic Crunchy Stir And Enjoy Peanut Butter, 16 Oz" | Product=="Smucker's Organic Creamy Natural Peanut Butter, 16 Oz"

egen numcat = rowtotal(Bread Cereal Dairy Eggs Entrees FruitVeg MeatSeafood NonSSBs SaltySnacks Sauces SSBs Sweets Other Nuts PastaRice)


cd "$Data/IntermediateData"
save LolasPurchases_all_coded.dta, replace
	