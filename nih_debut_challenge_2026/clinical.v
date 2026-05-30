module nih_debut_challenge_2026

import math

pub fn egfr_ckd_epi_2021(age int, sex string, creatinine_mg_dl f64) f64 {
	normalized_sex := sex.trim_space().to_lower()
	k := if normalized_sex in ['female', 'f', 'woman'] { 0.7 } else { 0.9 }
	alpha := if normalized_sex in ['female', 'f', 'woman'] { -0.241 } else { -0.302 }
	sex_factor := if normalized_sex in ['female', 'f', 'woman'] { 1.012 } else { 1.0 }
	ratio := creatinine_mg_dl / k
	value := 142.0 * math.pow(min_f64(ratio, 1.0), alpha) * math.pow(max_f64(ratio, 1.0), -1.2) * math.pow(0.9938,
		f64(age)) * sex_factor
	return round_to(value, 1)
}

pub fn gfr_stage(egfr f64) string {
	if egfr >= 90.0 {
		return 'G1'
	}
	if egfr >= 60.0 {
		return 'G2'
	}
	if egfr >= 45.0 {
		return 'G3a'
	}
	if egfr >= 30.0 {
		return 'G3b'
	}
	if egfr >= 15.0 {
		return 'G4'
	}
	return 'G5'
}

pub fn albuminuria_stage(uacr_mg_g f64) string {
	if uacr_mg_g < 30.0 {
		return 'A1'
	}
	if uacr_mg_g <= 300.0 {
		return 'A2'
	}
	return 'A3'
}

pub fn risk_band(gfr string, albuminuria string) string {
	if gfr in ['G1', 'G2'] {
		return match albuminuria {
			'A1' { 'low' }
			'A2' { 'moderate' }
			else { 'high' }
		}
	}
	if gfr == 'G3a' {
		return match albuminuria {
			'A1' { 'moderate' }
			'A2' { 'high' }
			else { 'very_high' }
		}
	}
	if gfr == 'G3b' {
		return if albuminuria == 'A1' { 'high' } else { 'very_high' }
	}
	return 'very_high'
}

fn min_f64(a f64, b f64) f64 {
	return if a < b { a } else { b }
}

fn max_f64(a f64, b f64) f64 {
	return if a > b { a } else { b }
}

fn round_to(value f64, places int) f64 {
	scale := math.pow(10.0, f64(places))
	return math.round(value * scale) / scale
}
