# 3D Aircraft Tracking with an Extended Kalman Filter

EN4594 — Autonomous Systems mini project, University of Moratuwa, Semester 07.

This repository contains MATLAB code, MATLAB result plots and metric tables, and the project report for three-dimensional aircraft tracking using an Extended Kalman Filter (EKF).

The filter estimates `[east, north, up, vx, vy, vz]` from noisy radar range, azimuth and elevation. It uses a constant-velocity motion model, continuous white-acceleration process noise, an analytical measurement Jacobian, angle wrapping, correlated two-observation initialization and a Joseph covariance update. Actual sampling intervals and missing observations are supported.

## Repository contents

| Folder | Contents |
| --- | --- |
| `matlab/` | MATLAB implementation and checks |
| `results/expanded_flights/` | All 1,200 benchmark metric rows, summaries and protocol |
| `results/published_matlab/` | Original plots and metric tables from 13 MATLAB runs |
| `report/` | Final submission PDF |

[Read the report](report/Mini_project_220350T.pdf).

## Run the simulations

Open the repository in MATLAB or upload it to MATLAB Drive. Change the Current Folder to `matlab/`, then run:

```matlab
run_checks
result = run_project('straight');
result = run_project('turn');
result = run_project('dropout');
```

No specialized MATLAB toolboxes are required. The simulations generate their own inputs. Outputs are saved under `results/matlab/`, keeping the published results separate. Rotate and zoom the trajectory figure to inspect the 3D track.

`run_project(scenario, seed, makePlots, flight)` defaults to `('turn',42,true,'belevingsvlucht')`. For a simulation without figures:

```matlab
result = run_project('turn',42,false);
```

The standard scenarios cover straight flight, a turn followed by a climb, and the same manoeuvre with a temporary radar outage. Nominal radar standard deviations are 50 m in range and 0.5 degrees in both angles. The default acceleration-noise spectral density is `q=1 m²/s³`.

The source also supports recorded-flight replay and shared-input validation. Those commands require separately prepared files under `data/`, which are not included in this repository. The simulation checks run without those files and skip the optional saved-reference comparison. See [MATLAB usage](matlab/README.md) for details.

## Results

The published MATLAB results contain five baseline runs—straight flight, turn, outage and two recorded-flight replays—and eight held-out replay runs comparing `q=1` and `q=10`. Each result folder contains its original `trajectory_3d.png`, `errors_nis.png` and `metrics.csv`.

The revised report also evaluates ten recorded-flight references over 30 windows with 20 paired noise draws and two fixed process-noise settings, giving 1,200 runs. These repeated-trial averages are separate from the individual runs shown by the published figures.

The first two measurements initialize the filter and are excluded from scoring. Raw-observation error includes only observed times; outage comparisons should therefore use the EKF's observed-time error as well. Some sparse or manoeuvring flight windows perform worse than raw measurements, and these outcomes remain in the report.

## Representative process-noise comparison

The [comparison results](results/published_matlab/real_data_validation/README.md) include all eight saved MATLAB runs for two flights, two windows and two q settings. The [combined metric table](results/published_matlab/real_data_validation/comparison_summary.csv) accompanies original plots, metrics and newly included estimate histories. The entry point is `matlab/run_real_data_validation.m`.

From `matlab/`, run `run_real_data_validation` (or `run_real_data_validation(false)` without plots) after restoring the prepared inputs under `data/real_data_validation/`. Those inputs remain excluded, so replay is not self-contained in the public checkout. The code and all eight saved comparison outputs can be reviewed directly.

The [1,200-run benchmark](results/expanded_flights/README.md) is also included. Its `trials.csv` contains every run's metrics, while `summary.json` and `protocol.json` record the aggregation and settings. It is separate from the individual published MATLAB executions. A MATLAB batch driver for all 1,200 cases is not currently included.

## Project report

The final submission is [Mini_project_220350T.pdf](report/Mini_project_220350T.pdf). It replaces the earlier report sources, supporting figures and PDF previously stored under `output/pdf/`.

## Data and limitations

Recorded-flight references originate from the sample collection distributed with Xavier Olive's `traffic` project, pinned at commit `1d34bad4ec54cd27b75952d67302f918a836acbd`. The repository publishes metric tables, figures and the eight comparison estimate histories. Raw downloads, reference/measurement exports and MAT files remain excluded. Source information: [traffic sample documentation](https://traffic-viz.github.io/data_sources/samples.html).

All radar observations are synthetic. Recorded positions are reference trajectories with an unverified altitude datum, using approximate local horizontal coordinates and relative altitude. Replay velocity RMSE and full-state NEES are omitted because exact velocity truth is unavailable. The constant-velocity model's limitations appear during turns and long gaps; simulation provides controlled truth for evaluating uncertainty.

The `.gitignore` allows only the documented MATLAB source, selected result plots/tables and active report files, together with the README and ignore rules. Local working records and build intermediates are excluded.
