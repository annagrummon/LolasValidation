*Check Screener

cd "$Data/RoboData"

/*
use Screener_Test.dta, clear

mvdecode *, mv(-99)

count
assert r(N)==100

tab consent
sum age
tab  frequency
assert eligib=="ineligible" if freq==0
tab shopmethod
assert shopmethod_TEXT!="" if shopmethod==6
tab hhld_shop
tab computer
assert elig=="ineligible" if computer==0
tab hhsize_num 
sum fpl_*

forval hhsize=1/20 {
	assert fpl_`hhsize' !=. if hhsize_num==`hhsize'
	assert fpl_`hhsize' ==. if hhsize_num!=`hhsize' & hhsize_num!=.
}

tab email
tab phone1
tab phone2
tab bestcontact_1
tab bestcontact_2
tab bestcontact_3
tab bestcontact_4

foreach x in 1 2 3 4 {
	destring bestcontact_`x', replace
}



tab first
tab last 
tab text
tab bestcontact_3 if text!=.
mdesc text if bestcontact_3==1

foreach x in 1 2 3  {
	destring time_`x', replace
}

foreach x in 1 2 3 {
	assert (bestcontact_1==1 | bestcontact_2==1) if time_`x'!=.
}

tab voicemail_cell
tab voicemail_home 

assert voicemail_cell!=. if bestcontact_1==1
assert voicemail_cell==. if bestcontact_1!=1
assert voicemail_home!=. if bestcontact_2==1
assert voicemail_home==. if bestcontact_2!=1

tab future


foreach var in email phone1 phone2 first last {
	assert `var'!="" if elig=="eligible"
}

*/

/*
*Check Lola's Visit 1

use "Main_Lolas_Visit1_Test.dta" , clear
mvdecode * , mv(-99)


assert inrange(easy_use, 1,5)

destring similar_usual, replace
destring felt_real, replace

assert whynotsim=="" if inrange(similar_usual, 3,5)
assert whynotreal=="" if inrange(felt_real, 3,5)



*Check Walmart Visit 1

use "Main_Walmart_Visit1_Test.dta" , clear
mvdecode * , mv(-99)


assert whynotsim=="" if inrange(similar_usual, 3,5)
assert whynotreal=="" if inrange(felt_real, 3,5)

*/

*Check Lola's Visit 2

use "Main_Lolas_Visit2_Test.dta" , clear
mvdecode * , mv(-99)

assert whynotsim=="" if inrange(similar_usual, 3,5)
assert whynotreal=="" if inrange(felt_real, 3,5)

*Walmart Visit 2

use "Main_Walmart_Visit2_Test.dta" , clear
mvdecode * , mv(-99)

assert whynotsim=="" if inrange(similar_usual, 3,5)
assert whynotreal=="" if inrange(felt_real, 3,5)
