# 3D Aircraft Tracking with an Extended Kalman Filter

EN4594 — Autonomous Systems mini project, University of Moratuwa, Semester 07.

This project estimates an aircraft's 3D position and velocity from noisy virtual-radar measurements using one Extended Kalman Filter (EKF). Matching MATLAB and Python implementations support MATLAB Online testing, local experiments, and interactive trajectory visualization.

The state is `[east, north, up, vx, vy, vz]`. A constant-velocity motion model uses continuous white-acceleration process noise. The radar measures slant range, azimuth and elevation. The implementation includes an analytical measurement Jacobian, angle wrapping, correlated two-observation initialization, variable sampling intervals, prediction through outages, and a Joseph covariance update. Internal units are metres, seconds and radians.

## Project status

The latest assignment review is recorded in [ASSIGNMENT_COMPLIANCE_REVIEW.md](ASSIGNMENT_COMPLIANCE_REVIEW.md). Existing verification includes 23 automated tests, audits of 13 returned MATLAB runs, and an additional replay of 60 flight configurations. The report contains four simulation scenarios with 100 trials each and ten recorded-flight references evaluated over 30 windows, 20 paired noise draws and two fixed process-noise settings: 1,200 flight runs.

The final report is 11 pages including the cover. It presents simulations before datasets, explains the implementation using inline MATLAB snippets, and uses four original MATLAB figures. Expanded numerical benchmarks were executed locally; no additional MATLAB execution is claimed for those runs.

- [Report PDF](output/pdf/EN4594_EKF_Aircraft_Tracking_Report.pdf)
- [LaTeX source](report/main.tex) and [submission ZIP](report/EN4594_EKF_LaTeX_Source.zip)
- [Implementation plan](IMPLEMENTATION_PLAN.md): design and historical extensions.
- [Implementation log](IMPLEMENTATION_LOG.md): completed work, verification, decisions and next steps.

## Folder guide

| Path | Purpose |
| --- | --- |
| `matlab/` | EKF implementation, scenarios, checks and plots |
| `python/` | Equivalent EKF, local runners, visualization and evidence audits |
| `python/tests/` | Mathematical and integration checks |
| `data/` | Preserved samples, derived clips, shared inputs and provenance |
| `results/` | Experiment metrics, exported estimates and audit receipts |
| `aircraft_tracking/`, `aircraft_tracking_new/` | Original returned MATLAB packages, preserved locally |
| `report/` | Active LaTeX report, figures and evidence manifest |
| `output/pdf/` | Generated submission PDF |
| `tmp/` | Temporary rendering and inspection files |

## Set up and run Python

Use Python 3.10 or newer. The project was tested with Python 3.12.3; [requirements-tested.txt](python/requirements-tested.txt) records the initial dependency versions. From the project root:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r python/requirements.txt
python -m pytest python/tests -q
python python/run_project.py --scenario turn
```

On Windows, activate with `.venv\Scripts\activate` instead. Once activated, the remaining Python commands are the same.

Other demonstrations:

```bash
python python/run_project.py --scenario straight
python python/run_project.py --scenario dropout
python python/run_project.py --scenario replay
python python/run_project.py --scenario replay --flight texas
```

Runs write metrics, configuration, observations, estimates, diagnostic arrays and plots under `results/python/`. Open the generated `trajectory_3d.html` in a browser to rotate, zoom and play the trajectory. Use `--no-html` to omit the interactive view. Preserve existing outputs when exploring settings by choosing a separate output folder:

```bash
python python/run_project.py --scenario turn --q 10 --output results/python/turn_q10
```

| Scenario | What it tests |
| --- | --- |
| `straight` | Constant velocity over 600 seconds |
| `turn` | Horizontal turn at 180–240 seconds and climb at 300–420 seconds |
| `dropout` | Manoeuvre with missing observations at 200–220 seconds inclusive |
| `replay` | Belevingsvlucht reference using native timestamps |
| Texas replay | Sparse, irregular observations |
| Monte Carlo `matched_cv` | Stochastic truth generated from the assumed motion model |

Default process-noise spectral density is `q=1 m²/s³`. Radar standard deviations are 50 m in range and 0.5° in each angle. The first two observations initialize the EKF; scoring starts at observation three. Raw observations converted to Cartesian positions provide the unfiltered comparison.

## Run MATLAB Online

Upload the current `matlab/` and `data/` folders to a private MATLAB Drive folder, preserving their relative paths. Open the `matlab/` folder and run:

```matlab
run_checks
result = run_project('straight');
result = run_project('turn');
result = run_project('dropout');
result = run_project('replay');
result = run_project('replay',42,true,'texas');
run_real_data_validation
```

No specialized toolboxes are required. Outputs go to `results/matlab/`. The held-out helper checks shared observations against expected histories; use `run_real_data_validation(false)` to skip figures. `run_checks` includes the shared-reference check when its CSVs are present.

An existing `matlab_online_bundle.zip` is also available locally for the earlier demonstrations and held-out helper; it does not contain the expanded ten-flight benchmark. See [MATLAB instructions](matlab/README.md) and [MATLAB Online setup](MATLAB_ONLINE_START.md).

## Reproduce experiments and audits

With the Python environment activated:

```bash
# Four simulation scenarios, 100 trials each.
python python/run_monte_carlo.py --trials 100

# Original two-flight development and held-out study.
python python/validate_real_data.py

# Ten-flight benchmark: 30 windows, two q values, 20 paired trials.
python python/evaluate_expanded_flights.py

# Audit five baseline runs from the newer MATLAB return.
python python/audit_matlab_results.py --folder aircraft_tracking_new/aircraft_tracking --output results/matlab_new_audit/baseline

# Audit the newer return, including eight held-out runs.
python python/audit_new_results.py

# Verify saved benchmark evidence and replay 60 configurations.
python python/audit_submission.py
```

These experiment commands regenerate their configured outputs. The audits require the corresponding saved inputs, experiment results and returned MATLAB files. They are available in the working project; a source-only checkout needs those local artifacts restored first. Setting `OPENBLAS_NUM_THREADS=1` before a command can reduce numerical-library thread overhead on Linux/macOS.

The two-flight study selected `q=10` on development windows. The expanded study fixes `q=1` and `q=10` before testing eight additional flights. Twenty paired radar-noise realizations are used for each native 0–10, 30–40 and 60–70 minute window. Every evaluated window, including failures, appears in the report. See [expanded results](results/expanded_flights/REPORT.md) and [validation receipts](results/assignment_audit_2026_11_11/).

MATLAB and Python use different random sequences. Implementation parity is checked with identical saved observations, rather than equal seed numbers. Regenerate the default shared dropout fixture only when intentionally updating it:

```bash
python python/run_project.py --scenario dropout --write-reference
```

## Build the report

Install a LaTeX distribution that supplies `pdflatex` and the packages used by `report/main.tex`. Then run:

```bash
python python/build_submission_report.py
```

The builder checks figure hashes, compiles twice, rejects LaTeX warnings and overfull boxes, and exports:

- `output/pdf/EN4594_EKF_Aircraft_Tracking_Report.pdf`
- `report/EN4594_EKF_LaTeX_Source.zip`

The ZIP contains the active source, metadata, logo, four figures, evidence manifest and submission notes. MATLAB snippets are embedded in the report. Edit author/module/date details in `report/metadata.tex`. Manual compilation instructions are in [report/README.md](report/README.md). The historical asset generator writes to `report/history/legacy_generated_assets/` and does not rebuild the current report.

## Data and interpretation

The ten compact trajectories come from samples distributed with Xavier Olive's `traffic` project at pinned commit `1d34bad4ec54cd27b75952d67302f918a836acbd`. Total compressed downloads are 501,767 bytes. The original samples, hashes and processing notes are preserved locally. Read the [original dataset notes](data/flight_tracks/README.md) and [expanded dataset notes](data/expanded_flights/README.md) for provenance and usage terms. The upstream MIT software license does not establish unrestricted licensing of the underlying observations.

Recorded positions are reference trajectories with synthetic radar observations. Their altitude datum is unverified; replay uses an approximate local horizontal frame and relative altitude. Exact replay velocity and full-state truth are unavailable, so replay velocity RMSE and NEES are omitted. Simulation provides exact truth for those metrics.

The constant-velocity model can suppress noise but struggles with turns and long sampling gaps. Some recorded-flight windows perform worse than raw observations, and those results are retained. Outage comparisons must use observed-time RMSE for both methods; the full-track EKF score also includes times without radar measurements. Formal covariance-consistency comparisons use the separate matched-model trials. This is an educational state-estimation study; adaptive process noise remains future work.

## Repository hygiene

The `.gitignore` excludes virtual environments, caches, local credential/configuration folders, temporary files, LaTeX build products and generated submission archives/PDFs. It preserves source code, dataset/license notices, manifests, report figures and saved experiment evidence as versionable files. Ignoring files does not remove them locally or untrack files already committed.

Before publishing a repository, review dataset terms and identifier-bearing artifacts using the existing dataset notes. The generated submission ZIP intentionally excludes raw flight data and separate MATLAB attachments. Topic uniqueness, the actual course deadline and the final cover date still require confirmation before submission.
# Three-Dimensional-Aircraft-Tracking-with-EKF
