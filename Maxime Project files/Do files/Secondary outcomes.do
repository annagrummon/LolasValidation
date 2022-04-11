// Created: 11-1-21
// Modified: 12-9-21
// Analyst(s): Maxime Bercholz
// Project: Aim 3 of the Wellcome project
// Purpose: Secondary outcomes analysis

clear
cd "T:\Wellcome\Aim 3\Full launch"
run "Do files\Programs"
use "Data\Processed data\merged data"
alpha health_*, item
egen p_health = rowmean(health_*)
label variable p_health "Perceived healthfulness of specific RM products"
alpha envt_*, item
egen p_envt = rowmean(envt_*)
label variable p_envt "Perceived sustainability of specific RM products"
alpha cost_*, item // No scale achieves alpha > .7
mmetable energykcal saturatedfat salt pph risk_cancer risk_envt ce_health ce_envt ce_price p_health p_envt cost_* reduce_meat pol_tax pol_hwl pol_ewl, putexcelcmd(`"putexcel set "Results\Secondary outcomes.xlsx", sheet("OLS", replace) modify"')

// Log of important changes
// -----------------------------------------------------------------------------
// Date		Initials	Description of changes
// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------