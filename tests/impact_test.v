module tests

import nih_debut_challenge_2026 as core

fn test_impact_model_summarizes_workflow_value() {
	impact := core.summarize_impact(core.default_impact_model())
	assert impact.minutes_saved_per_day == 96
	assert impact.hours_saved_per_20_days == 32.0
	assert impact.niddk_fit >= 90
}

fn test_judge_scorecard_reaches_competitive_label() {
	summary := core.evaluate_cases(core.synthetic_cases())
	impact := core.summarize_impact(core.default_impact_model())
	scorecard := core.judge_scorecard(summary, impact)
	assert scorecard.total >= 90
	assert core.competitive_readiness_label(scorecard.total) == 'competitive_finalist'
}
