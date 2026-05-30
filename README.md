# NIH DEBUT Challenge 2026 Core

Vlang core for `RenalCue`, a DEBUT-ready biomedical software MVP that validates
low-resource chronic kidney disease triage workflows with synthetic data.

## Commands

```powershell
$env:VMODULES='C:\git\v_projects\lib'
v run .\cmd\debutckd generate
v run .\cmd\debutckd eval --json
v run .\cmd\debutckd qa
v run .\cmd\debutckd serve --port 4286
```

## Scope

- Synthetic case generation with no PHI.
- CKD-EPI 2021 creatinine eGFR calculation.
- GFR and albuminuria staging.
- KDIGO-style risk banding.
- Referral and repeat-test recommendations for student prototype review.
- Static web demo data, evidence receipts and submission manifest generation.

This software is a student prototype and not a medical device release.
