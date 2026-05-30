module nih_debut_challenge_2026

pub fn evaluate_case(input CaseInput) CaseFinding {
	issues := validate_case(input)
	if has_errors(issues) {
		return CaseFinding{
			id:                      input.id
			age:                     input.age
			sex:                     input.sex
			validation_issues:       issues
			expected_risk_band:      input.expected_risk_band
			expected_action_key:     input.expected_action_key
			matches_expected_risk:   false
			matches_expected_action: false
		}
	}
	egfr := egfr_ckd_epi_2021(input.age, input.sex, input.creatinine_mg_dl)
	gfr := gfr_stage(egfr)
	albuminuria := albuminuria_stage(input.uacr_mg_g)
	risk := risk_band(gfr, albuminuria)
	action := action_key(input, egfr, risk)
	return CaseFinding{
		id:                      input.id
		age:                     input.age
		sex:                     input.sex
		egfr_ml_min_1_73m2:      egfr
		gfr_stage:               gfr
		albuminuria_stage:       albuminuria
		risk_band:               risk
		action_key:              action
		recommendation:          recommendation_text(action)
		validation_issues:       issues
		expected_risk_band:      input.expected_risk_band
		expected_action_key:     input.expected_action_key
		matches_expected_risk:   risk == input.expected_risk_band
		matches_expected_action: action == input.expected_action_key
	}
}

pub fn action_key(input CaseInput, egfr f64, risk string) string {
	if input.symptoms.any(it in ['chest_pain', 'confusion', 'severe_shortness_of_breath'])
		|| input.systolic_bp >= 180 || egfr < 15.0 {
		return 'urgent_clinician_review'
	}
	if egfr < 30.0 || input.uacr_mg_g > 300.0 || risk == 'very_high' {
		return 'nephrology_referral'
	}
	if risk in ['high', 'moderate'] || input.has_diabetes || input.has_hypertension {
		return 'repeat_labs_and_primary_care'
	}
	return 'routine_prevention'
}

pub fn recommendation_text(action string) string {
	return match action {
		'urgent_clinician_review' {
			'Escalate for same-day clinician review; confirm values and assess red flags.'
		}
		'nephrology_referral' {
			'Prepare nephrology referral packet with eGFR, UACR, blood pressure and context.'
		}
		'repeat_labs_and_primary_care' {
			'Repeat confirmatory UACR/eGFR and route to primary care CKD management.'
		}
		else {
			'Continue routine prevention education and annual kidney risk screening.'
		}
	}
}
