module main

import json
import local_http_core as http_core
import net.http
import nih_debut_challenge_2026 as core
import os
import project_line_guard
import time

const default_worth_it = 'C:/git/v_projects/contests/worth_it/nih_debut_challenge_2026'
const default_site = 'C:/git/websites/nih_debut_challenge_2026'
const default_port = 4286
const product_version = '1.0.0'

struct StaticHandler {
	site_root string
}

fn main() {
	args := os.args[1..].filter(it != '--')
	cmd := if args.len == 0 { 'help' } else { args[0] }
	exit_code := match cmd {
		'generate' {
			run_generate(args[1..])
		}
		'eval' {
			run_eval(args[1..])
		}
		'qa' {
			run_qa(args[1..])
		}
		'form' {
			run_form(args[1..])
		}
		'serve' {
			run_serve(args[1..])
		}
		'help', '--help', '-h' {
			print_help()
		}
		else {
			eprintln('unknown command: ${cmd}')
			print_help()
			1
		}
	}

	if exit_code != 0 {
		exit(exit_code)
	}
}

fn run_generate(args []string) int {
	worth_it := flag_value(args, '--worth-it', default_worth_it)
	site := flag_value(args, '--site', default_site)
	cases := core.synthetic_cases()
	summary := core.evaluate_cases(cases)
	impact := core.summarize_impact(core.default_impact_model())
	scorecard := core.judge_scorecard(summary, impact)
	readiness := core.readiness_report(product_version, summary)
	ensure_dirs([
		os.join_path(worth_it, 'data'),
		os.join_path(worth_it, 'evidence'),
		os.join_path(worth_it, 'submission', 'generated'),
		os.join_path(site, 'src', 'data'),
	]) or { return fail(err.msg()) }
	write_text(os.join_path(worth_it, 'data', 'synthetic_cases.csv'), core.cases_csv(cases)) or {
		return fail(err.msg())
	}
	write_json(os.join_path(worth_it, 'evidence', 'case_results_v.json'), summary) or {
		return fail(err.msg())
	}
	write_json(os.join_path(worth_it, 'evidence', 'readiness_report_v.json'), readiness) or {
		return fail(err.msg())
	}
	write_json(os.join_path(worth_it, 'evidence', 'impact_model_v.json'), impact) or {
		return fail(err.msg())
	}
	write_json(os.join_path(worth_it, 'evidence', 'judge_scorecard_v.json'), scorecard) or {
		return fail(err.msg())
	}
	write_json(os.join_path(worth_it, 'submission', 'generated', 'nih_submission_manifest.json'),
		core.manifest_payload(product_version)) or { return fail(err.msg()) }
	write_json(os.join_path(worth_it, 'submission', 'generated',
		'nih_registration_payload.redacted.json'), core.registration_payload()) or {
		return fail(err.msg())
	}
	write_text(os.join_path(worth_it, 'submission', 'student_partner_outreach_pack.md'),
		core.outreach_markdown()) or { return fail(err.msg()) }
	write_json(os.join_path(site, 'src', 'data', 'cases.json'), cases) or { return fail(err.msg()) }
	write_json(os.join_path(site, 'src', 'data', 'case_results.json'), summary) or {
		return fail(err.msg())
	}
	write_json(os.join_path(site, 'src', 'data', 'readiness_report.json'), readiness) or {
		return fail(err.msg())
	}
	write_json(os.join_path(site, 'src', 'data', 'impact_model.json'), impact) or {
		return fail(err.msg())
	}
	write_json(os.join_path(site, 'src', 'data', 'judge_scorecard.json'), scorecard) or {
		return fail(err.msg())
	}
	println('generated RenalCue synthetic data, evidence and submission artifacts')
	return 0
}

fn run_eval(args []string) int {
	input_path := flag_value(args, '--input', '')
	cases := if input_path != '' {
		core.read_cases_csv(input_path) or { return fail(err.msg()) }
	} else {
		core.synthetic_cases()
	}
	summary := core.evaluate_cases(cases)
	if has_flag(args, '--json') {
		println(json.encode_pretty(summary))
		return 0
	}
	println('# RenalCue CKD Triage Evaluation')
	println('')
	println('- cases: ${summary.case_count}')
	println('- pass rate: ${summary.pass_rate}%')
	println('- very high risk: ${summary.very_high}')
	println('- high risk: ${summary.high}')
	println('- moderate risk: ${summary.moderate}')
	println('- low risk: ${summary.low}')
	return 0
}

fn run_qa(args []string) int {
	worth_it := flag_value(args, '--worth-it', default_worth_it)
	site := flag_value(args, '--site', default_site)
	product := os.dir(os.dir(os.dir(@FILE)))
	limit := flag_value(args, '--line-limit', '600').int()
	near_limit := flag_value(args, '--near-limit', '560').int()
	mut failures := []string{}
	for target in [product, site, worth_it] {
		if !os.exists(target) {
			failures << 'missing target: ${target}'
			continue
		}
		report := project_line_guard.audit_line_caps(project_line_guard.GuardOptions{
			root:       target
			limit:      limit
			near_limit: near_limit
		})
		for item in report.failures {
			failures << '${item.rel} has ${item.lines} lines'
		}
		for item in scan_text_line_caps(target, limit) {
			failures << item
		}
	}
	for item in required_artifacts(worth_it, site) {
		if !os.exists(item) {
			failures << 'missing artifact: ${item}'
		}
	}
	summary := core.evaluate_cases(core.synthetic_cases())
	if summary.pass_rate != 100 {
		failures << 'synthetic test cases must pass expected labels'
	}
	if failures.len > 0 {
		eprintln('qa failed:')
		for item in failures {
			eprintln('- ${item}')
		}
		return 2
	}
	println('qa passed: clinical fixtures, required artifacts and line caps ok')
	return 0
}

fn run_form(args []string) int {
	worth_it := flag_value(args, '--worth-it', default_worth_it)
	dry_run := has_flag(args, '--dry-run') || !has_flag(args, '--submit')
	preview := {
		'target':               'https://oms.aws.venturewell.org/go/debut-2026'
		'draft_mode':           dry_run.str()
		'generated_at':         time.now().format_rfc3339()
		'submission_execution': 'official_portal_session_with_eligible_student_captain'
		'payload':              json.encode(core.registration_payload())
	}
	out_path := os.join_path(worth_it, 'evidence', 'registration_payload_preview_v.json')
	write_json(out_path, preview) or { return fail(err.msg()) }
	if dry_run {
		println('dry-run preview written: ${out_path}')
		return 0
	}
	println('submission execution packet written: ${out_path}')
	println('open the official DEBUT portal session and apply the prepared payload with the eligible student captain')
	return 0
}

fn run_serve(args []string) int {
	site := flag_value(args, '--site', default_site)
	port := flag_value(args, '--port', default_port.str()).int()
	if !os.exists(os.join_path(site, 'index.html')) {
		eprintln('site index not found: ${site}')
		return 2
	}
	println('serving ${site} at http://127.0.0.1:${port}')
	mut server := http.Server{
		addr:                 '127.0.0.1:${port}'
		handler:              StaticHandler{site}
		show_startup_message: false
	}
	server.listen_and_serve()
	return 0
}

fn (handler StaticHandler) handle(req http.Request) http.Response {
	path := http_core.request_path(req.url)
	mut rel := path.trim_left('/')
	if rel == '' {
		rel = 'index.html'
	}
	if rel.contains('..') || os.is_abs_path(rel) {
		return http_core.forbidden_response(security_headers())
	}
	full_path := os.join_path(handler.site_root, rel)
	if os.exists(full_path) && os.is_file(full_path) {
		return http_core.file_response(full_path, cache_for(rel), security_headers())
	}
	return http_core.file_response(os.join_path(handler.site_root, 'index.html'), 'no-cache',
		security_headers())
}

fn ensure_dirs(paths []string) ! {
	for path in paths {
		os.mkdir_all(path)!
	}
}

fn write_text(path string, content string) ! {
	os.mkdir_all(os.dir(path))!
	os.write_file(path, content)!
}

fn write_json[T](path string, value T) ! {
	write_text(path, json.encode_pretty(value))!
}

fn flag_value(args []string, name string, fallback string) string {
	for i, item in args {
		if item == name && i + 1 < args.len {
			return args[i + 1]
		}
		prefix := name + '='
		if item.starts_with(prefix) {
			return item[prefix.len..]
		}
	}
	return fallback
}

fn has_flag(args []string, name string) bool {
	return args.any(it == name)
}

fn required_artifacts(worth_it string, site string) []string {
	return [
		os.join_path(worth_it, 'TASK_STATUS.md'),
		os.join_path(worth_it, 'docs', 'official_requirements.md'),
		os.join_path(worth_it, 'docs', 'clinical_need.md'),
		os.join_path(worth_it, 'docs', 'undergraduate_team_required.md'),
		os.join_path(worth_it, 'docs', 'test_cases.md'),
		os.join_path(worth_it, 'docs', 'checklist.md'),
		os.join_path(worth_it, 'submission', 'SUBMISSION_PACKET.md'),
		os.join_path(worth_it, 'submission', 'project_narrative_6page_draft.md'),
		os.join_path(worth_it, 'submission', 'nih_submission_payload.template.json'),
		os.join_path(site, 'index.html'),
	]
}

fn scan_text_line_caps(root string, limit int) []string {
	mut failures := []string{}
	for path in collect_text_files(root) {
		line_count := os.read_file(path) or { '' }.split_into_lines().len
		if line_count > limit {
			failures << '${relative_path(root, path)} has ${line_count} lines'
		}
	}
	return failures
}

fn collect_text_files(root string) []string {
	mut files := []string{}
	collect_text_files_into(root, mut files)
	files.sort()
	return files
}

fn collect_text_files_into(dir string, mut files []string) {
	for name in os.ls(dir) or { []string{} } {
		path := os.join_path(dir, name)
		if os.is_dir(path) {
			if should_skip_dir(name) {
				continue
			}
			collect_text_files_into(path, mut files)
		} else if is_text_file(name) {
			files << path
		}
	}
}

fn should_skip_dir(name string) bool {
	return name.to_lower() in ['.git', '.cache', 'bin', 'build', 'dist', 'node_modules', 'out',
		'tmp']
}

fn is_text_file(name string) bool {
	lower := name.to_lower()
	return lower.ends_with('.v') || lower.ends_with('.vue') || lower.ends_with('.js')
		|| lower.ends_with('.css') || lower.ends_with('.html') || lower.ends_with('.md')
		|| lower.ends_with('.json') || lower.ends_with('.toml') || lower.ends_with('.ps1')
		|| lower.ends_with('.yml') || lower.ends_with('.yaml') || lower.ends_with('.csv')
}

fn relative_path(root string, path string) string {
	root_clean := os.real_path(root).replace('\\', '/').trim_right('/')
	path_clean := os.real_path(path).replace('\\', '/')
	prefix := root_clean + '/'
	if path_clean.starts_with(prefix) {
		return path_clean[prefix.len..]
	}
	return path_clean
}

fn cache_for(rel string) string {
	if rel.ends_with('.js') || rel.ends_with('.vue') || rel.ends_with('.css')
		|| rel.ends_with('.json') {
		return 'no-cache'
	}
	return 'public, max-age=300'
}

fn security_headers() http_core.LocalSecurityHeaders {
	return http_core.LocalSecurityHeaders{
		content_security_policy: "default-src 'self' https://unpkg.com https://cdn.jsdelivr.net; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://unpkg.com https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; connect-src 'self'; img-src 'self' data:; font-src 'self' data:"
	}
}

fn fail(message string) int {
	eprintln(message)
	return 1
}

fn print_help() int {
	println('debutckd commands: generate | eval | qa | form | serve')
	return 0
}
