// Created: 11-17-21
// Modified: 2-25-21
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Programs for various uses throughout project

// Deviance and Pearson goodness-of-fit tests for GLM Poisson

capture program drop gof
program define gof
	local pd = 1 - chi2(`e(df)',`e(deviance)') // P value for deviance test statistic
	local pp = 1 - chi2(`e(df)',`e(deviance_p)') // P value for Pearson test statistic
	display ///
		_newline as text "Goodness-of-fit test statistic" _skip(3) "Prob > chi2(`e(df)')" ///
		_newline as text "Deviance = `: display %8.3f `e(deviance)''" _skip(14) "`: display %6.4f `pd''" ///
		_newline as text "Pearson  = `: display %8.3f `e(deviance_p)''" _skip(14) "`: display %6.4f `pp''"
end gof

// Frequency-weighted scatter plot

capture program drop wscatter
program define wscatter
	syntax varlist (max = 2), [options(string)]
	preserve
	keep `varlist'
	tokenize `varlist'
    bysort `1' `2': generate w = _N
	keep `1' `2' w
	duplicates drop
	scatter `1' `2' [fweight = w], `options'
	restore
end wscatter

// Residual diagnostics after glm, family(poisson)

capture program drop res
program define res
	quietly {
	    predict anscombe, anscombe
		predict deviance, deviance
		predict pearson, pearson
		noisily summarize anscombe deviance pearson
		noisily qnorm anscombe, msize(small) mfcolor(%50) mlwidth(thin) name(qqplot, replace)
		predict fitted
		foreach r in anscombe deviance pearson {
			noisily lowess `r' fitted, msize(small) mfcolor(%50) mlwidth(thin) name(`r', replace)
		}
		drop fitted anscombe deviance pearson
	}
end res

// Means and main effects table

capture program drop mmetable
program define mmetable
	syntax varlist [if], putexcelcmd(string) [modelopts(string) scale(real 1) scalevars(varlist) barplot]
	marksample touse
	quietly {
		`putexcelcmd'
		putexcel B1 = "`: label (arm) 1'"
		putexcel C1 = "`: label (arm) 2'"
		putexcel D1 = "`: label (arm) 3'"
		putexcel E1 = "`: label (arm) 4'"
		local r 2
		local anyrobust 0
		foreach v of varlist `varlist' {
			if strpos("`modelopts'","robust") == 0 {
				regress `v' i.arm if `touse'
				matrix results = (r(table)[1,5],r(table)[1,2..4]\r(table)[5..6,5],r(table)[5..6,2..4])'
				estat hettest
				if r(p) < .05 {
					regress `v' i.arm if `touse', vce(robust)
					matrix results = (r(table)[1,5],r(table)[1,2..4]\r(table)[5..6,5],r(table)[5..6,2..4])'
				}
			}
			else {
				regress `v' i.arm if `touse', `modelopts'
				matrix results = (r(table)[1,5],r(table)[1,2..4]\r(table)[5..6,5],r(table)[5..6,2..4])'
			}
			if inlist("`scalevars'","`v'") matrix results = results * `scale'
			if "`e(vce)'" == "robust" {
				putexcel A`r' = "`: variable label `v''* (n = `e(N)')"
				local anyrobust 1
			}
			else putexcel A`r' = "`: variable label `v'' (n = `e(N)')"
			putexcel B`r' = "`: display %3.1f results[1,1]' (`: display %3.1f results[1,2]', `: display %3.1f results[1,3]')"
			test (3.arm = 2.arm) (4.arm = 2.arm) (4.arm = 3.arm), mtest
			local A
			local B
			local C
			local c 65
			if r(mtest)[1,3] < .05 {
				local g = char(`c')
				local `g' = "2 3"
				local ++c
			}
			if r(mtest)[2,3] < .05 {
				local g = char(`c')
				local `g' = "2 4"
				local ++c
			}
			if r(mtest)[3,3] < .05 {
				local g = char(`c')
				local `g' = "3 4"
				local ++c
			}
			forvalues i = 2/4 {
				local script
				if strpos("`A'","`i'") > 0 local script A
				if strpos("`B'","`i'") > 0 local script = "`script'B"
				if strpos("`C'","`i'") > 0 local script = "`script'C"
				local cell = char(65 + `i') + "`r'"
				putexcel `cell' = "`: display %3.1f results[`i',1]'`script' (`: display %3.1f results[`i',2]', `: display %3.1f results[`i',3]')"
			}
			local ++r
			if "`barplot'" == "barplot" {
				margins arm
				marginsplot, recast(bar) play("Graph recordings\group means") name(`v', replace)
			}
		}
		if `anyrobust' == 1 {
			putexcel A`r' = "* Robust standard errors used."
			local ++r
		}
		putexcel A`r' = "Date and time: $S_DATE $S_TIME."
	}
end mmetable

// Moderation results table

capture program drop modtable
program define modtable
	syntax varlist, putexcelcmd(string) model(string) [modelopts(string) intertest scale(real 1)]
	quietly {
		if "`intertest'" == "intertest" capture matrix drop intertest
	    tokenize `varlist'
		local depvar `1'
		macro shift
		local moderators `*'
		`putexcelcmd'
		putexcel A1 = "Moderation analysis"
		putexcel B2 = "`: label (arm) 1'"
		putexcel C2 = "`: label (arm) 2'"
		putexcel D2 = "`: label (arm) 3'"
		putexcel E2 = "`: label (arm) 4'"
		local r 2
		local anyrobust 0
		foreach v in `moderators' {
			levelsof `v'
			local q = r(r)
			tokenize `r(levels)' // New
			if "`modelopts'" == "" {
				`model' `depvar' arm##`v'
				if "`model'" == "regress" {
					estat hettest
					if r(p) < .05 `model' `depvar' arm##`v', vce(robust)
				}
			}
			else if strpos("`modelopts'","robust") == 0 & "`model'" == "regress" {
				estat hettest
				if r(p) < .05 `model' `depvar' arm##`v', `modelopts' vce(robust)
			}
			else `model' `depvar' arm##`v', `modelopts'
			testparm arm#`v'
			if "`intertest'" == "intertest" matrix intertest = nullmat(intertest)\r(p)
			local ++r
			if "`e(vce)'" == "robust" {
				putexcel A`r' = "`: variable label `v''* (n = `e(N)')"
				local anyrobust 1
			}
			else putexcel A`r' = "`: variable label `v'' (n = `e(N)')"
			margins `v', at(arm = (1))
			matrix control = (r(table)[1,1...]\r(table)[5..6,1...])' * `scale'
			margins `v', dydx(arm) post
			matrix effects_b = (r(table)[1,`q' + 1..2 * `q']\r(table)[1,2 * `q' + 1..3 * `q']\r(table)[1,3 * `q' + 1...])' * `scale'
			matrix effects_l = (r(table)[5,`q' + 1..2 * `q']\r(table)[5,2 * `q' + 1..3 * `q']\r(table)[5,3 * `q' + 1...])' * `scale'
			matrix effects_u = (r(table)[6,`q' + 1..2 * `q']\r(table)[6,2 * `q' + 1..3 * `q']\r(table)[6,3 * `q' + 1...])' * `scale'
			contrast `v', atequations noeffects
			matrix ps = r(p)[1,2...]
			putexcel C`r' = "P = `: display %5.3f r(p)[1,2]'"
			putexcel D`r' = "P = `: display %5.3f r(p)[1,3]'"
			putexcel E`r' = "P = `: display %5.3f r(p)[1,4]'"
			local ++r
			local cmax 0
			forvalues i = 2/4 {
				if ps[1,`i' - 1] < .05 {
					local c 65
					pwcompare `v', equation(`i'.arm) effects
					local q2 = `q' - 1
					forvalues j = 1/`q2' {
						local j2 = `j' + 1
						forvalues k = `j2'/5 {
							if r(table_vs)[4,`: colnumb r(table_vs) ``k''vs``j''.`v''] < .05 { // Single quotes for k and j without tokenize
								local g = char(`c')
								local `g' = "``g'' `i'_``j'' `i'_``k''" // Ibid.
								local cmax = max(`cmax',`c')
								local ++c
							}
						}
					}
				}
			}
			forvalues i = 1/`q' {
				putexcel A`r' = "`: label (`v') ``i'''"
				putexcel B`r' = "`: display %3.1f control[`i',1]' (`: display %3.1f control[`i',2]', `: display %3.1f control[`i',3]')"
				forvalues j = 2/4 {
					local script
					if `cmax' > 0 {
						if `cmax' == 65 & strpos("`A'","`j'_``i''") > 0 local script A // Ibid. (i)
						else forvalues k = 65/`cmax' {
							local g = char(`k')
							if strpos("``g''","`j'_``i''") > 0 local script = "`script'`g'" // Ibid. (i)
						}
					}
					local cell = char(65 + `j') + "`r'"
					putexcel `cell' = "`: display %3.1f effects_b[`i',`j' - 1]'`script' (`: display %3.1f effects_l[`i',`j' - 1]', `: display %3.1f effects_u[`i',`j' - 1]')"
				}
				local ++r
			}
			if `cmax' > 0 {
				if `cmax' == 65 local A
				else forvalues i = 65/`cmax' {
					local g = char(`i')
					local `g'
				}
			}
		}
		if `anyrobust' == 1 {
			putexcel A`r' = "* Robust standard errors used."
			local ++r
		}
		putexcel A`r' = "Date and time: $S_DATE $S_TIME."
		if "`intertest'" == "intertest" {
			matrix rownames intertest = `moderators'
			matrix colnames intertest = P
			noisily matrix list intertest, title("P values from Wald tests of joint significance of the interaction coefficients")
		}
	}
end modtable