module tests

import nih_debut_challenge_2026 as core

fn test_impact_model_summarizes_workflow_value() {
	impact := core.summarize_impact(core.default_impact_model())
	assert impact.minutes_saved_per_day == 96
	assert impact.hours_saved_per_20_days == 32.0
	assert impact.referral_rescues_per_100 == 18
	assert impact.low_resource_fit >= 90
	assert impact.niddk_fit >= 90
}

fn test_judge_scorecard_reaches_competitive_label() {
	summary := core.evaluate_cases(core.synthetic_cases())
	impact := core.summarize_impact(core.default_impact_model())
	scorecard := core.judge_scorecard(summary, impact)
	assert scorecard.total >= 90
	assert scorecard.total_score == scorecard.total
	assert scorecard.workflow_minutes_saved == 96
	assert scorecard.followup_rescue == 18
	assert scorecard.low_resource_fit == 92
	assert scorecard.debut_criteria_score == scorecard.total
	assert core.debut_criteria_score(summary, impact) == scorecard.total
	assert core.niddk_fit_score(impact) == 96
	assert core.competitive_readiness_label(scorecard.total) == 'competitive_finalist'
}
