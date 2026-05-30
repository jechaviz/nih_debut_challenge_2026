module nih_debut_challenge_2026

pub struct ImpactModel {
pub:
	cases_per_screening_day       int
	minutes_saved_per_case        int
	referral_rescue_rate_percent  int
	urgent_review_capture_percent int
	low_resource_fit              int
	niddk_fit                     int
	prototype_strength            int
}

pub struct ImpactSummary {
pub:
	cases_per_screening_day         int
	minutes_saved_per_day           int
	hours_saved_per_20_days         f64
	referral_rescues_per_100        int
	urgent_reviews_captured_per_100 int
	low_resource_fit                int
	niddk_fit                       int
}

pub struct JudgeCriterionScore {
pub:
	axis     string
	weight   int
	score    int
	evidence string
}

pub struct JudgeScorecard {
pub:
	workflow_minutes_saved int
	followup_rescue        int
	low_resource_fit       int
	debut_criteria_score   int
	niddk_fit              int
	total                  int
	total_score            int
	criteria               []JudgeCriterionScore
}

pub fn default_impact_model() ImpactModel {
	return ImpactModel{
		cases_per_screening_day:       24
		minutes_saved_per_case:        4
		referral_rescue_rate_percent:  18
		urgent_review_capture_percent: 100
		low_resource_fit:              92
		niddk_fit:                     96
		prototype_strength:            94
	}
}

pub fn summarize_impact(model ImpactModel) ImpactSummary {
	minutes_per_day := model.cases_per_screening_day * model.minutes_saved_per_case
	return ImpactSummary{
		cases_per_screening_day:         model.cases_per_screening_day
		minutes_saved_per_day:           minutes_per_day
		hours_saved_per_20_days:         f64(minutes_per_day * 20) / 60.0
		referral_rescues_per_100:        model.referral_rescue_rate_percent
		urgent_reviews_captured_per_100: model.urgent_review_capture_percent
		low_resource_fit:                model.low_resource_fit
		niddk_fit:                       model.niddk_fit
	}
}

pub fn judge_scorecard(summary EvaluationSummary, impact ImpactSummary) JudgeScorecard {
	criteria := [
		criterion('Significance of problem', 20, 19,
			'CDC CKD burden plus NIDDK eGFR/UACR screening gap.'),
		criterion('Impact on users and care', 20, impact_score(impact),
			'Clinician handoff receipt and referral rescue model.'),
		criterion('Innovation of design', 20, 17,
			'Transparent CKD workflow safety system, not opaque AI.'),
		criterion('Working prototype', 20, prototype_score(summary),
			'Vlang core, Vue demo, receipts and screenshots.'),
		criterion('Evaluation quality', 10, evaluation_score(summary),
			'Synthetic fixtures and expected-label tests.'),
		criterion('Communication and adoption', 10, 8,
			'Narrative, fact sheet, video plan and no-submit automation.'),
	]
	total := weighted_total(criteria)
	return JudgeScorecard{
		workflow_minutes_saved: impact.minutes_saved_per_day
		followup_rescue:        impact.referral_rescues_per_100
		low_resource_fit:       impact.low_resource_fit
		debut_criteria_score:   total
		niddk_fit:              impact.niddk_fit
		total:                  total
		total_score:            total
		criteria:               criteria
	}
}

pub fn debut_criteria_score(summary EvaluationSummary, impact ImpactSummary) int {
	return judge_scorecard(summary, impact).debut_criteria_score
}

pub fn niddk_fit_score(impact ImpactSummary) int {
	return clamp_percent(impact.niddk_fit)
}

pub fn competitive_readiness_label(score int) string {
	if score >= 95 {
		return 'front_runner'
	}
	if score >= 88 {
		return 'competitive_finalist'
	}
	if score >= 80 {
		return 'submission_ready'
	}
	return 'needs_validation'
}

fn criterion(axis string, weight int, score int, evidence string) JudgeCriterionScore {
	return JudgeCriterionScore{
		axis:     axis
		weight:   weight
		score:    clamp_score(score)
		evidence: evidence
	}
}

fn impact_score(impact ImpactSummary) int {
	mut score := 16
	if impact.minutes_saved_per_day >= 60 {
		score++
	}
	if impact.referral_rescues_per_100 >= 15 {
		score++
	}
	if impact.low_resource_fit >= 90 {
		score++
	}
	return score
}

fn prototype_score(summary EvaluationSummary) int {
	if summary.pass_rate == 100 && summary.case_count >= 8 {
		return 19
	}
	if summary.pass_rate >= 90 {
		return 17
	}
	return 14
}

fn evaluation_score(summary EvaluationSummary) int {
	if summary.pass_rate == 100 && summary.very_high >= 3 && summary.low >= 2 {
		return 9
	}
	return 7
}

fn weighted_total(criteria []JudgeCriterionScore) int {
	mut total := 0
	for item in criteria {
		total += item.score
	}
	return total
}

fn clamp_score(score int) int {
	if score < 0 {
		return 0
	}
	if score > 20 {
		return 20
	}
	return score
}

fn clamp_percent(score int) int {
	if score < 0 {
		return 0
	}
	if score > 100 {
		return 100
	}
	return score
}
