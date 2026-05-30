module nih_debut_challenge_2026

pub fn registration_payload() map[string]string {
	return {
		'competition':                          official_track
		'internal_track':                       internal_track
		'project_title':                        project_title
		'team_name':                            'PRIVATE_REQUIRED_UNDERGRAD_TEAM'
		'team_size':                            'PRIVATE_REQUIRED_3_TO_8'
		'captain_name':                         'PRIVATE_REQUIRED_US_CITIZEN_OR_PERMANENT_RESIDENT_FOR_NIBIB'
		'captain_email':                        'PRIVATE_REQUIRED'
		'institution':                          'PRIVATE_REQUIRED_US_COLLEGE_OR_UNIVERSITY'
		'faculty_sponsor':                      'PRIVATE_REQUIRED'
		'primary_prize_fit':                    primary_prize_fit
		'secondary_prize_fit':                  secondary_prize_fit
		'project_summary':                      'RenalCue is a community CKD triage software prototype that combines eGFR, UACR, blood pressure and red-flag checks into explainable routing recommendations for low-resource clinics.'
		'pdf_upload':                           'submission/final_pdf_private_required'
		'video_url':                            'PRIVATE_REQUIRED_YOUTUBE_OR_VIMEO'
		'eligible_undergraduate_team_required': 'true'
		'certification_form_required':          'true'
		'faculty_letter_required':              'true'
		'submission_execution':                 'official_portal_session_with_eligible_student_captain'
		'automation_scope':                     'draft_prepare_validate_upload_assist'
	}
}

pub fn outreach_markdown() string {
	return '# Undergraduate Team Outreach Pack\n\n' +
		'Status: `ready_for_student_partner_adoption`\n\n' + '## Ask\n\n' +
		'We need a 3-8 person undergraduate team enrolled full-time during the 2025-2026 academic year to own, test, record and submit RenalCue to NIH DEBUT 2026.\n\n' +
		'## What is ready\n\n' +
		'- Vlang biomedical software core with CKD-EPI, UACR staging, risk bands and validators.\n' +
		'- Synthetic data pipeline, test cases and generated evidence receipts.\n' +
		'- Vue3 CDN +
		SFC + UnoCSS demo for reviewers.\n' +
		'- Draft narrative, checklist, video outline, risk register and form map.\n\n' +
		'## What the student team must provide privately\n\n' +
		'- Team roster, signatures, citizenship/permanent-resident indication and under-18 consent if applicable.\n' +
		'- Faculty sponsor letter on department letterhead.\n' +
		'- Final video URL and any real stakeholder support letters.\n' +
		'- Final approval before online submission.\n'
}
