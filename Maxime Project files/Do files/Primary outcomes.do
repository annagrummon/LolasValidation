// Created: 11-1-21
// Modified: 2-25-22
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Primary outcomes analysis

clear
cd "T:\Wellcome\Aim 3\Full launch"
run "Do files\Programs"
use "Data\Processed data\merged data"
keep id arm redmeat frac_rm age gender meat grocery online_shop ethnicity* race_* education income political int_*

// 1 (heading no longer used)

// 2 Univariate analysis

// 2.1 Two-sample t-tests

foreach v in redmeat frac_rm {
	forvalues i = 1/3 {
		forvalues j = 2/4 {
			if `j' > `i' ttest `v' if inlist(arm,`i',`j'), by(arm) unequal // Allow for heteroskedasticity by arm
		}
	}
}

// 2.2 A shortcut
// Easier to plot results with -marginsplot- after -regress- and -margins-
// Use robust standard errors as a way to relax common variance assumption, relaxed in t-tests above with the -unequal- option
// OLS with robust standard errors and two-sample t-tests may differ in theory but there is no difference in practice here

mmetable redmeat frac_rm, putexcelcmd(`"putexcel set "Results\Primary outcomes.xlsx", sheet("Summary", replace) modify"') modelopts(`"vce(robust)"') scale(100) scalevars(frac_rm) barplot // See Programs.do for details

// 3 Detailed regression analysis

// 3.1 Count of red meat items

summarize redmeat, detail // Slight underdispersion
histogram redmeat, discrete percent // No apparent zero inflation
tabstat redmeat, stats(variance mean) by(arm) format(%4.2f) nototal // Slight heteroskedasticity by arm

// 3.1.1 OLS (see 2.2)

regress redmeat i.arm, vce(robust)
margins arm, pwcompare(effects)
matrix mat1 = (r(table)[1,1...]\r(table)[5..6,1...])'
matrix rownames mat1 = Control WL T WLT
matrix colnames mat1 = Mean "95% CI ll" "95% CI ul"
matrix mat2 = (r(table_vs)[1,1...]\r(table_vs)[5..6,1...]\r(table_vs)[4,1...])'
matrix rownames mat2 = "WL v Control" "T v Control" "WLT v Control" "T v WL" "WLT v WL" "WLT v T"
matrix colnames mat2 = Contrast "95% CI ll" "95% CI ul" P
putexcel set "Results\Primary outcomes", sheet("Count (OLS)", replace) modify
putexcel A1 = "Unadjusted group means (n = `e(N)')"
putexcel A2 = matrix(mat1), names nformat(#.000)
local r = 4 + rowsof(mat1)
putexcel A`r' = "Contrasts of the above unadjusted group means"
local ++r
putexcel A`r' = matrix(mat2), names nformat(#.000)
local r = `r' + rowsof(mat2) + 2
putexcel A`r' = "Date and time: $S_DATE $S_TIME."

// 3.1.2 Poisson

glm redmeat i.arm, family(poisson) vce(robust)
margins arm, pwcompare(effects)
matrix mat1 = (r(table)[1,1...]\r(table)[5..6,1...])'
matrix rownames mat1 = Control WL T WLT
matrix colnames mat1 = Mean "95% CI ll" "95% CI ul"
matrix mat2 = (r(table_vs)[1,1...]\r(table_vs)[5..6,1...]\r(table_vs)[4,1...])'
matrix rownames mat2 = "WL v Control" "T v Control" "WLT v Control" "T v WL" "WLT v WL" "WLT v T"
matrix colnames mat2 = Contrast "95% CI ll" "95% CI ul" P
putexcel set "Results\Primary outcomes", sheet("Count (Poisson)", replace) modify
putexcel A1 = "Unadjusted group means (n = `e(N)')"
putexcel A2 = matrix(mat1), names nformat(#.000)
local r = 4 + rowsof(mat1)
putexcel A`r' = "Contrasts of the above unadjusted group means"
local ++r
putexcel A`r' = matrix(mat2), names nformat(#.000)
local r = `r' + rowsof(mat2) + 2
putexcel A`r' = "Date and time: $S_DATE $S_TIME."
 
// 3.1.3 ZIP
// Select inflation equation covariates by backward stepwise

zip redmeat i.arm, inflate(i.arm i.meat int_health int_envt1 i.income i.education i.gender) vce(robust)
zip redmeat i.arm, inflate(i.arm i.meat int_health int_envt1 i.income i.education) vce(robust)
zip redmeat i.arm, inflate(i.arm i.meat int_health int_envt1 i.education) vce(robust)
zip redmeat i.arm, inflate(i.arm int_health int_envt1 i.education) vce(robust)
margins arm, pwcompare(effects)
matrix mat1 = (r(table)[1,1...]\r(table)[5..6,1...])'
matrix rownames mat1 = Control WL T WLT
matrix colnames mat1 = Mean "95% CI ll" "95% CI ul"
matrix mat2 = (r(table_vs)[1,1...]\r(table_vs)[5..6,1...]\r(table_vs)[4,1...])'
matrix rownames mat2 = "WL v Control" "T v Control" "WLT v Control" "T v WL" "WLT v WL" "WLT v T"
matrix colnames mat2 = Contrast "95% CI ll" "95% CI ul" P
putexcel set "Results\Primary outcomes", sheet("Count (ZIP)", replace) modify
putexcel A1 = "Unadjusted group means (n = `e(N)')"
putexcel A2 = matrix(mat1), names nformat(#.000)
local r = 4 + rowsof(mat1)
putexcel A`r' = "Contrasts of the above unadjusted group means"
local ++r
putexcel A`r' = matrix(mat2), names nformat(#.000)
local r = `r' + rowsof(mat2) + 2
putexcel A`r' = "Date and time: $S_DATE $S_TIME."

// 3.2 Fraction of red meat items

summarize frac_rm, detail
histogram frac_rm, bin(10) percent
tabstat frac_rm, stats(variance mean) by(arm) format(%4.2f) nototal // Slight heteroskedasticity by arm

// 3.2.1 OLS (see 2.2)

regress frac_rm i.arm, vce(robust)
margins arm, pwcompare(effects)
matrix mat1 = (r(table)[1,1...]\r(table)[5..6,1...])'
matrix rownames mat1 = Control WL T WLT
matrix colnames mat1 = Mean "95% CI ll" "95% CI ul"
matrix mat2 = (r(table_vs)[1,1...]\r(table_vs)[5..6,1...]\r(table_vs)[4,1...])'
matrix rownames mat2 = "WL v Control" "T v Control" "WLT v Control" "T v WL" "WLT v WL" "WLT v T"
matrix colnames mat2 = Contrast "95% CI ll" "95% CI ul" P
putexcel set "Results\Primary outcomes", sheet("Frac (OLS)", replace) modify
putexcel A1 = "Unadjusted group means (n = `e(N)')"
putexcel A2 = matrix(mat1), names nformat(#.000)
local r = 4 + rowsof(mat1)
putexcel A`r' = "Contrasts of the above unadjusted group means"
local ++r
putexcel A`r' = matrix(mat2), names nformat(#.000)
local r = `r' + rowsof(mat2) + 2
putexcel A`r' = "Date and time: $S_DATE $S_TIME."

// 3.2.2 Fractional regression
// Note that heteroskedastic probit is not feasible because the covariates in the variance equation need to form a subset of the covariates in the main equation, but the only covariate is arm

fracreg probit frac_rm i.arm, vce(robust) 
margins arm, pwcompare(effects)
matrix mat1 = (r(table)[1,1...]\r(table)[5..6,1...])'
matrix rownames mat1 = Control WL T WLT
matrix colnames mat1 = Mean "95% CI ll" "95% CI ul"
matrix mat2 = (r(table_vs)[1,1...]\r(table_vs)[5..6,1...]\r(table_vs)[4,1...])'
matrix rownames mat2 = "WL v Control" "T v Control" "WLT v Control" "T v WL" "WLT v WL" "WLT v T"
matrix colnames mat2 = Contrast "95% CI ll" "95% CI ul" P
putexcel set "Results\Primary outcomes", sheet("Frac (Frac probit)", replace) modify
putexcel A1 = "Unadjusted group means (n = `e(N)')"
putexcel A2 = matrix(mat1), names nformat(#.000)
local r = 4 + rowsof(mat1)
putexcel A`r' = "Contrasts of the above unadjusted group means"
local ++r
putexcel A`r' = matrix(mat2), names nformat(#.000)
local r = `r' + rowsof(mat2) + 2
putexcel A`r' = "Date and time: $S_DATE $S_TIME."

// 3.2.3 Zero-inflated beta regression (not enough ones to estimate a zero-one-inflated model)
// Select inflation equation covariates by backward stepwise

zoib frac_rm i.arm, zeroinflate(i.arm i.meat int_health int_envt1 i.income i.education i.gender) noone vce(robust)
zoib frac_rm i.arm, zeroinflate(i.arm i.meat int_health int_envt1 i.education i.gender) noone vce(robust)
zoib frac_rm i.arm, zeroinflate(i.arm i.meat int_health int_envt1 i.education) noone vce(robust)
margins arm, pwcompare(effects)
matrix mat1 = (r(table)[1,1...]\r(table)[5..6,1...])'
matrix rownames mat1 = Control WL T WLT
matrix colnames mat1 = Mean "95% CI ll" "95% CI ul"
matrix mat2 = (r(table_vs)[1,1...]\r(table_vs)[5..6,1...]\r(table_vs)[4,1...])'
matrix rownames mat2 = "WL v Control" "T v Control" "WLT v Control" "T v WL" "WLT v WL" "WLT v T"
matrix colnames mat2 = Contrast "95% CI ll" "95% CI ul" P
putexcel set "Results\Primary outcomes", sheet("Frac (ZIB)", replace) modify
putexcel A1 = "Unadjusted group means (n = `e(N)')"
putexcel A2 = matrix(mat1), names nformat(#.000)
local r = 4 + rowsof(mat1)
putexcel A`r' = "Contrasts of the above unadjusted group means"
local ++r
putexcel A`r' = matrix(mat2), names nformat(#.000)
local r = `r' + rowsof(mat2) + 2
putexcel A`r' = "Date and time: $S_DATE $S_TIME."

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
// 11-14-21	MB			Now using -mean- for univariate analysis instead of
//						-poisson-.
// 11-22-21 MB			Now using -regress- (via -mmetable-, see Programs.do)
//						for univariate analysis to export and plot the results
//						more easily.
// -----------------------------------------------------------------------------