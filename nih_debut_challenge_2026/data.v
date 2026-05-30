module nih_debut_challenge_2026

import strconv
import vcsv

pub fn synthetic_cases() []CaseInput {
	return [
		CaseInput{
			id:                  'RC-001'
			age:                 44
			sex:                 'female'
			creatinine_mg_dl:    0.8
			uacr_mg_g:           12
			has_diabetes:        false
			has_hypertension:    false
			systolic_bp:         118
			expected_risk_band:  'low'
			expected_action_key: 'routine_prevention'
		},
		CaseInput{
			id:                  'RC-002'
			age:                 59
			sex:                 'male'
			creatinine_mg_dl:    1.1
			uacr_mg_g:           88
			has_diabetes:        true
			has_hypertension:    true
			systolic_bp:         146
			expected_risk_band:  'moderate'
			expected_action_key: 'repeat_labs_and_primary_care'
		},
		CaseInput{
			id:                  'RC-003'
			age:                 67
			sex:                 'female'
			creatinine_mg_dl:    1.4
			uacr_mg_g:           48
			has_diabetes:        true
			has_hypertension:    false
			systolic_bp:         136
			expected_risk_band:  'very_high'
			expected_action_key: 'nephrology_referral'
		},
		CaseInput{
			id:                  'RC-004'
			age:                 72
			sex:                 'male'
			creatinine_mg_dl:    2.1
			uacr_mg_g:           410
			has_diabetes:        true
			has_hypertension:    true
			systolic_bp:         158
			expected_risk_band:  'very_high'
			expected_action_key: 'nephrology_referral'
		},
		CaseInput{
			id:                  'RC-005'
			age:                 81
			sex:                 'female'
			creatinine_mg_dl:    3.2
			uacr_mg_g:           620
			has_diabetes:        false
			has_hypertension:    true
			systolic_bp:         166
			expected_risk_band:  'very_high'
			expected_action_key: 'urgent_clinician_review'
		},
		CaseInput{
			id:                  'RC-006'
			age:                 63
			sex:                 'male'
			creatinine_mg_dl:    4.8
			uacr_mg_g:           700
			has_diabetes:        true
			has_hypertension:    true
			systolic_bp:         188
			symptoms:            ['confusion']
			expected_risk_band:  'very_high'
			expected_action_key: 'urgent_clinician_review'
		},
		CaseInput{
			id:                  'RC-007'
			age:                 53
			sex:                 'female'
			creatinine_mg_dl:    1.0
			uacr_mg_g:           360
			has_diabetes:        false
			has_hypertension:    true
			systolic_bp:         142
			expected_risk_band:  'high'
			expected_action_key: 'nephrology_referral'
		},
		CaseInput{
			id:                  'RC-008'
			age:                 38
			sex:                 'male'
			creatinine_mg_dl:    1.0
			uacr_mg_g:           25
			has_diabetes:        false
			has_hypertension:    true
			systolic_bp:         151
			expected_risk_band:  'low'
			expected_action_key: 'repeat_labs_and_primary_care'
		},
	]
}

pub fn cases_csv(cases []CaseInput) string {
	columns := ['id', 'age', 'sex', 'creatinine_mg_dl', 'uacr_mg_g', 'has_diabetes',
		'has_hypertension', 'systolic_bp', 'symptoms', 'expected_risk_band', 'expected_action_key']
	mut lines := [columns.join(',')]
	for item in cases {
		lines << [
			item.id,
			item.age.str(),
			item.sex,
			item.creatinine_mg_dl.str(),
			item.uacr_mg_g.str(),
			item.has_diabetes.str(),
			item.has_hypertension.str(),
			item.systolic_bp.str(),
			item.symptoms.join('|'),
			item.expected_risk_band,
			item.expected_action_key,
		].map(vcsv.escape_cell(it)).join(',')
	}
	return lines.join('\n') + '\n'
}

pub fn read_cases_csv(path string) ![]CaseInput {
	rows := vcsv.read_file(path)!
	mut cases := []CaseInput{}
	for row in rows {
		cases << CaseInput{
			id:                  row['id'] or { '' }
			age:                 strconv.atoi(row['age'] or { '0' }) or { 0 }
			sex:                 row['sex'] or { '' }
			creatinine_mg_dl:    strconv.atof64(row['creatinine_mg_dl'] or { '0' }) or { 0 }
			uacr_mg_g:           strconv.atof64(row['uacr_mg_g'] or { '0' }) or { 0 }
			has_diabetes:        parse_bool(row['has_diabetes'] or { 'false' })
			has_hypertension:    parse_bool(row['has_hypertension'] or { 'false' })
			systolic_bp:         strconv.atoi(row['systolic_bp'] or { '0' }) or { 0 }
			symptoms:            split_symptoms(row['symptoms'] or { '' })
			expected_risk_band:  row['expected_risk_band'] or { '' }
			expected_action_key: row['expected_action_key'] or { '' }
		}
	}
	return cases
}

fn parse_bool(value string) bool {
	return value.trim_space().to_lower() in ['true', '1', 'yes', 'y']
}

fn split_symptoms(value string) []string {
	mut out := []string{}
	for item in value.split('|') {
		clean := item.trim_space()
		if clean != '' {
			out << clean
		}
	}
	return out
}
