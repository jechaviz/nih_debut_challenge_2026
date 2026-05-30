module nih_debut_challenge_2026

import time

pub fn evaluate_cases(cases []CaseInput) EvaluationSummary {
	findings := cases.map(evaluate_case(it))
	pass_count := findings.filter(it.matches_expected_risk && it.matches_expected_action).len
	return EvaluationSummary{
		project:      project_title
		track:        internal_track
		generated_at: time.now().format_rfc3339()
		case_count:   cases.len
		pass_count:   pass_count
		pass_rate:    percent(pass_count, cases.len)
		very_high:    findings.filter(it.risk_band == 'very_high').len
		high:         findings.filter(it.risk_band == 'high').len
		moderate:     findings.filter(it.risk_band == 'moderate').len
		low:          findings.filter(it.risk_band == 'low').len
		findings:     findings
	}
}

pub fn readiness_report(version string, summary EvaluationSummary) ReadinessReport {
	return ReadinessReport{
		generated_at: time.now().format_rfc3339()
		package_name: 'nih_debut_challenge_2026'
		product:      project_title
		version:      version
		status:       'ready_for_undergraduate_team_submission'
		checks:       {
			'synthetic_cases':   summary.case_count.str()
			'case_pass_rate':    '${summary.pass_rate}%'
			'judge_score':       judge_scorecard(summary, summarize_impact(default_impact_model())).total.str()
			'competitive_label': competitive_readiness_label(judge_scorecard(summary,
				summarize_impact(default_impact_model())).total)
			'niddk_fit':         '${default_impact_model().niddk_fit}%'
			'low_resource_fit':  '${default_impact_model().low_resource_fit}%'
			'clinical_scope':    'CKD triage, not autonomous diagnosis'
			'privacy':           'synthetic only, no PHI'
			'section_508':       'web demo designed for keyboard and readable contrast'
		}
		blockers:     [
			'Eligible 3-8 undergraduate student team must own final submission.',
			'Faculty sponsor letter and signatures are private external artifacts.',
			'Video link must be recorded by the student team before upload.',
		]
		artifacts:    [
			'data/synthetic_cases.csv',
			'evidence/readiness_report_v.json',
			'evidence/case_results_v.json',
			'evidence/impact_model_v.json',
			'evidence/judge_scorecard_v.json',
			'submission/generated/nih_submission_manifest.json',
		]
	}
}

pub fn manifest_payload(version string) SubmissionManifest {
	return SubmissionManifest{
		version:           version
		project:           project_title
		internal_track:    internal_track
		status:            'ready_for_undergraduate_team_submission'
		primary_prize_fit: primary_prize_fit
		secondary_fit:     secondary_prize_fit
		required_pdf:      'submission/project_narrative_6page_draft.md'
		video_outline:     'docs/video_outline.md'
		website:           'C:/git/websites/nih_debut_challenge_2026'
		product_core:      'C:/git/v_projects/nih_debut_challenge_2026'
		final_submit_gate: 'eligible_team_captain_authorization_required'
	}
}

fn percent(part int, whole int) int {
	if whole <= 0 {
		return 0
	}
	return int(f64(part) / f64(whole) * 100.0)
}
