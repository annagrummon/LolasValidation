// Created: 11-2-21
// Modified: 2-25-21
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Creating descriptive statistics tables

clear
cd "T:\Wellcome\Aim 3\Full launch"
use "Data\Processed data\merged data"

// Participant characteristics

quietly {
    putexcel set "Results\Descriptive statistics.xlsx", sheet("Table 1", replace) modify
	putexcel B1 = "Control"
	putexcel C1 = "WL"
	putexcel D1 = "T"
	putexcel E1 = "WLT"
	putexcel F1 = "All"
	local r 2
	forvalues i = 1/4 {
		summarize age if arm == `i'
		local mean = string(r(mean),"%4.1f")
		local sd = string(r(sd),"%4.1f")
		local cell = char(65 + `i') + string(`r')
		putexcel `cell' = "`mean' (`sd')"
	}
	summarize age
	local mean = string(r(mean),"%4.1f")
	local sd = string(r(sd),"%4.1f")
	putexcel A`r' = "Age* (n = `r(N)')"
	putexcel F`r' = "`mean' (`sd')"
	local ++r
	foreach v in education ethnicity gender grocery income meat online_shop political {
		tabulate `v' if !missing(arm), matcell(rowtotals)
		tabulate arm if !missing(`v'), matcell(coltotals)
		tabulate `v' arm, matcell(cellcounts)
		local N = r(N)
		putexcel A`r' = "`: variable label `v'' (n = `N')"
		forvalues i = 1/`r(r)' {
			local r2 = `r' + `i'
			putexcel A`r2' = "`: label (`v') `i''"
			forvalues j = 1/4 {
				local cellcount = cellcounts[`i',`j']
				local cellpercent = string(100 * cellcounts[`i',`j'] / coltotals[`j',1],"%4.1f")
				local cell = char(65 + `j') + string(`r2')
				putexcel `cell' = "`cellcount' (`cellpercent')"
			}
			local cellcount = rowtotals[`i',1]
			local cellpercent = string(100 * rowtotals[`i',1] / `N',"%4.1f")
			putexcel F`r2' = "`cellcount' (`cellpercent')"		
		}
		local r = `r2' + 1
	}
	tabulate arm, matcell(coltotals)
	local N = r(N)
	egen rownonmiss = rownonmiss(race_*), strok // Number of races selected including 'Race not listed' and self-described race
	count if rownonmiss > 0
	local N_race = r(N) // Consider observations with any race information as non-missing
	drop rownonmiss
	putexcel A`r' = "race (n = `N_race')"
	forvalues i = 1/6 {
		local r2 = `r' + `i'
		putexcel A`r2' = "`: variable label race_`i''"
		tabulate race_`i' arm, matcell(cellcounts)
		forvalues j = 1/4 {
			local cellcount = cellcounts[1,`j']
			local cellpercent = string(100 * cellcounts[1,`j'] / coltotals[`j',1],"%4.1f")
			local cell = char(65 + `j') + string(`r2')
			putexcel `cell' = "`cellcount' (`cellpercent')"
		}
		local cellpercent = string(100 * r(N) / `N',"%4.1f")
		putexcel F`r2' = "`r(N)' (`cellpercent')"
	}
	local r = `r2' + 1
	quietly foreach v in int_health int_envt1 {
		forvalues i = 1/4 {
			summarize `v' if arm == `i'
			local mean = string(r(mean),"%4.1f")
			local sd = string(r(sd),"%4.1f")
			local cell = char(65 + `i') + string(`r')
			putexcel `cell' = "`mean' (`sd')"
		}
		summarize `v'
		local mean = string(r(mean),"%4.1f")
		local sd = string(r(sd),"%4.1f")
		putexcel A`r' = "`: variable label `v'' (n = `r(N)')"
		putexcel F`r' = "`mean' (`sd')"
		local ++r
	}
	putexcel A`r' = "** Mean (SD), frequency (column %) otherwise."
	putexcel A`r' = "Date and time: $S_DATE, $S_TIME."
}

// Primary outcomes

replace frac_rm = frac_rm * 100
quietly {
    putexcel set "Results\Descriptive statistics.xlsx", sheet("Primary outcomes", replace) modify
	putexcel B1 = "`: label (arm) 1'"
	putexcel C1 = "`: label (arm) 2'"
	putexcel D1 = "`: label (arm) 3'"
	putexcel E1 = "`: label (arm) 4'"
	local r 2
	foreach v in redmeat frac_rm {
		count if !missing(`v',arm)
		putexcel A`r' = "`: variable label `v'' (n = `r(N)')"
		forvalues i = 1/4 {
			summarize `v' if arm == `i'
			local mean = string(r(mean),"%4.1f")
			local sd = string(r(sd),"%4.1f")
			local c = char(65 + `i')
			putexcel `c'`r' = "`mean' (`sd')"
		}
		local ++r
	}
	putexcel A`r' = "Means (SDs)."
	local ++r
	putexcel A`r' = "Date and time: $S_DATE, $S_TIME."
}
replace frac_rm = frac_rm / 100

// Secondary outcomes

quietly {
    putexcel set "Results\Descriptive statistics.xlsx", sheet("Secondary outcomes", replace) modify
	putexcel B1 = "`: label (arm) 1'"
	putexcel C1 = "`: label (arm) 2'"
	putexcel D1 = "`: label (arm) 3'"
	putexcel E1 = "`: label (arm) 4'"
	local r 2
	foreach v in energykcal saturatedfat salt {
		count if !missing(`v',arm)
		putexcel A`r' = "`: variable label `v''* (n = `r(N)')"
		forvalues i = 1/4 {
			summarize `v' if arm == `i'
			local mean = string(r(mean),"%4.1f")
			local sd = string(r(sd),"%4.1f")
			local c = char(65 + `i')
			putexcel `c'`r' = "`mean' (`sd')"
		}
		local ++r
	}
	foreach v of varlist pph risk_cancer risk_envt ce_health ce_envt ce_price health_* envt_* cost_* reduce_meat pol_tax pol_hwl pol_ewl {
		tabulate `v' if !missing(arm), matcell(rowtotals)
		tabulate arm if !missing(`v'), matcell(coltotals)
		tabulate `v' arm, matcell(cellcounts)
		count if !missing(`v',arm)
		putexcel A`r' = "`: variable label `v'' (n = `r(N)')"
		levelsof `v'
		tokenize `r(levels)'
		forvalues i = 1/`r(r)' {
			local r2 = `r' + `i'
			putexcel A`r2' = "`: label (`v') ``i'''"
			forvalues j = 1/4 {
				local cellcount = cellcounts[`i',`j']
				local cellpercent = string(100 * cellcounts[`i',`j'] / coltotals[`j',1],"%4.1f")
				local c = char(65 + `j')
				putexcel `c'`r2' = "`cellcount' (`cellpercent')"
			}
		}
		local r = `r2' + 1
	}
	putexcel A`r' = "* Mean (SD), frequency (column %) otherwise."
	local ++r
	putexcel A`r' = "Date and time: $S_DATE, $S_TIME."
}

// Other outcomes, all arms combined

quietly {
    putexcel set "Results\Descriptive statistics.xlsx", sheet("Other outcomes", replace) modify
	putexcel B1 = "N (%)"
	local r 2
	foreach v in process easily_find enough felt_real anna_1 anna_2 {
		tabulate `v' if !missing(arm), matcell(rowtotals)
		count if !missing(`v',arm)
		local n = r(N)
		putexcel A`r' = "`: variable label `v'' (n = `n')"
		local ++r
		levelsof `v'
		tokenize `r(levels)'
		forvalues i = 1/`r(r)' {
			putexcel A`r' = "`: label (`v') ``i'''"
			local cellcount = rowtotals[`i',1]
			local cellpercent = string(100 * rowtotals[`i',1] / `n',"%4.1f")
			putexcel B`r' = "`cellcount' (`cellpercent')"
			local ++r
		}
	}
	putexcel A`r' = "Date and time: $S_DATE, $S_TIME."
}

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
// 12-1-21	MB			Added Ns.
// -----------------------------------------------------------------------------