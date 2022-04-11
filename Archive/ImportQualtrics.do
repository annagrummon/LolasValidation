*Import Robodatasets

cd "$Data/Qualtrics"

foreach filename in Screener_Test Main_Walmart_Visit1 Main_Walmart_Visit2 Main_Lolas_Visit1 Main_Lolas_Visit2 {
	
	import excel "`filename'.xlsx",  firstrow clear
	save "`filename'.dta", replace

}
