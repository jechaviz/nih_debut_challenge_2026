module tests

import nih_debut_challenge_2026 as core

fn test_ckd_epi_stage_and_albuminuria() {
	egfr := core.egfr_ckd_epi_2021(72, 'male', 2.1)
	assert egfr > 30.0
	assert egfr < 40.0
	assert core.gfr_stage(egfr) == 'G3b'
	assert core.albuminuria_stage(410) == 'A3'
}

fn test_risk_and_actions_match_fixture_expectations() {
	summary := core.evaluate_cases(core.synthetic_cases())
	assert summary.case_count == 8
	assert summary.pass_rate == 100
	assert summary.very_high >= 2
}

fn test_validation_catches_bad_clinical_input() {
	issues := core.validate_case(core.CaseInput{
		id:               'bad'
		age:              40
		sex:              'unknown'
		creatinine_mg_dl: 0
		uacr_mg_g:        -1
		systolic_bp:      120
	})
	assert core.has_errors(issues)
}
