module nih_debut_challenge_2026

pub fn validate_case(input CaseInput) []ValidationIssue {
	mut issues := []ValidationIssue{}
	if input.id.trim_space() == '' {
		issues << issue('id', 'case id is required', 'error')
	}
	if input.age < 18 || input.age > 95 {
		issues << issue('age', 'age should be within adult prototype bounds 18-95', 'warning')
	}
	if input.sex.trim_space().to_lower() !in ['female', 'f', 'woman', 'male', 'm', 'man'] {
		issues << issue('sex', 'sex must be female/male for CKD-EPI creatinine equation', 'error')
	}
	if input.creatinine_mg_dl <= 0.1 || input.creatinine_mg_dl > 20.0 {
		issues << issue('creatinine_mg_dl', 'creatinine is outside supported validation range',
			'error')
	}
	if input.uacr_mg_g < 0.0 || input.uacr_mg_g > 10000.0 {
		issues << issue('uacr_mg_g', 'UACR is outside supported validation range', 'error')
	}
	if input.systolic_bp < 70 || input.systolic_bp > 260 {
		issues << issue('systolic_bp', 'systolic blood pressure is outside supported range',
			'warning')
	}
	return issues
}

pub fn has_errors(issues []ValidationIssue) bool {
	return issues.any(it.severity == 'error')
}

fn issue(field string, message string, severity string) ValidationIssue {
	return ValidationIssue{
		field:    field
		message:  message
		severity: severity
	}
}
