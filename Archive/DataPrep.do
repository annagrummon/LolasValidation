*Data Prep

*Screener Cleaning:

*encode fpl variables 
		*TK TK TK TK TK TK - check what HH sizes need to be included here. 
	foreach hhsize in 1 2 3 4 5 6 7 8 10 15 { 
			encode fpl_`hhsize', gen(fpl_`hhsize'_num)
		}

	gen fpl150 = .
	foreach hhsize in 1 2 3 4 5 6 7 8 10 15 { 
			replace fpl150 = 1 if fpl_`hhsize'_num==1
			replace fpl150 = 0 if inrange(fpl_`hhsize'_num, 2, 5)
			replace fpl150 = . if fpl_`hhsize'_num==. & hhsize_num == `hhsize'
		}
		
	gen fpl200 = .
	foreach hhsize in 1 2 3 4 5 6 7 8 10 15 { 
			replace fpl200 = 1 if fpl_`hhsize'_num==1 | fpl_`hhsize'_num==2
			replace fpl200 = 0 if inrange(fpl_`hhsize'_num, 3, 5)
			replace fpl200 = . if fpl_`hhsize'_num==. & hhsize_num == `hhsize'
		}

