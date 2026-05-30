module nih_debut_challenge_2026

pub const project_title = 'RenalCue: Community CKD Triage Software'
pub const internal_track = 'student_partner_track'
pub const official_track = 'NIH DEBUT Challenge 2026'
pub const primary_prize_fit = 'NIDDK Kidney Technology Development Prize'
pub const secondary_prize_fit = 'Healthcare Technologies for Low-Resource Settings Prize'

pub struct CaseInput {
pub:
	id                  string
	age                 int
	sex                 string
	creatinine_mg_dl    f64
	uacr_mg_g           f64
	has_diabetes        bool
	has_hypertension    bool
	systolic_bp         int
	symptoms            []string
	expected_risk_band  string
	expected_action_key string
}

pub struct ValidationIssue {
pub:
	field    string
	message  string
	severity string
}

pub struct CaseFinding {
pub:
	id                      string
	age                     int
	sex                     string
	egfr_ml_min_1_73m2      f64
	gfr_stage               string
	albuminuria_stage       string
	risk_band               string
	action_key              string
	recommendation          string
	validation_issues       []ValidationIssue
	expected_risk_band      string
	expected_action_key     string
	matches_expected_risk   bool
	matches_expected_action bool
}

pub struct EvaluationSummary {
pub:
	project      string
	track        string
	generated_at string
	case_count   int
	pass_count   int
	pass_rate    int
	very_high    int
	high         int
	moderate     int
	low          int
	findings     []CaseFinding
}

pub struct ReadinessReport {
pub:
	generated_at string
	package_name string
	product      string
	version      string
	status       string
	checks       map[string]string
	blockers     []string
	artifacts    []string
}

pub struct SubmissionManifest {
pub:
	version           string
	project           string
	internal_track    string
	status            string
	primary_prize_fit string
	secondary_fit     string
	required_pdf      string
	video_outline     string
	website           string
	product_core      string
	final_submit_gate string
}
