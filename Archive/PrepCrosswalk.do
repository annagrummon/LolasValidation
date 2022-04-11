*Import Lolas Crosswalk
cd "$Data"
import excel "CrosswalkAnalysisCategories_v1.xlsx", sheet("categories_organized") firstrow clear

egen DeptAisleShelf = concat(Department Aisle Shelf), punc(-)

gen review = . 
	*No categories, or more than 1 category
	replace review = 1 if NumberCategories ==0
	replace review = 1 if NumberCategories > 1 & NumberCategories!=.
	*Notes indicate needs review
	replace review = 1 if Notes=="review"
	
	*No review needed if 1 category and no notes
	replace review = 0 if NumberCat==1 & Notes==""
	


