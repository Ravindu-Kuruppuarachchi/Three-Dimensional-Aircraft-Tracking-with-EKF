# 3D Aircraft Tracking with an Extended Kalman Filter

EN4594 — Autonomous Systems mini project, University of Moratuwa, Semester 07.

This repository contains MATLAB code, MATLAB result plots and metric tables, and the project report for three-dimensional aircraft tracking using an Extended Kalman Filter (EKF).

The filter estimates `[east, north, up, vx, vy, vz]` from noisy radar range, azimuth and elevation. It uses a constant-velocity motion model, continuous white-acceleration process noise, an analytical measurement Jacobian, angle wrapping, correlated two-observation initialization and a Joseph covariance update. Actual sampling intervals and missing observations are supported.

## Repository contents

| Folder | Contents |
| --- | --- |
| `matlab/` | MATLAB implementation and checks |
| `results/published_matlab/` | Original plots and metric tables from 13 MATLAB runs |
| `report/` | LaTeX source, cover logo and report figures |
| `output/pdf/` | Compiled submission report |

[Read the report](output/pdf/EN4594_EKF_Aircraft_Tracking_Report.pdf).

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

The report also contains a broader local evaluation: four simulation scenarios with 100 trials each, and ten recorded-flight references over 30 windows with 20 paired noise draws and two fixed process-noise settings. Those expanded tables are separate from the 13 MATLAB runs represented by the published figures; additional MATLAB execution is not claimed.

The first two measurements initialize the filter and are excluded from scoring. Raw-observation error includes only observed times; outage comparisons should therefore use the EKF's observed-time error as well. Some sparse or manoeuvring flight windows perform worse than raw measurements, and these outcomes remain in the report.

## Build the report

The report is 11 pages including the cover, with simulations first, inline MATLAB explanations and results for all ten flight references. With a LaTeX distribution installed, compile from `report/`:

```sh
mkdir -p build
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build main.tex
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build main.tex
```

The compiled file is `report/build/main.pdf`. The published copy is under `output/pdf/`. Cover details are in `report/metadata.tex`.

## Data and limitations

Recorded-flight references originate from the sample collection distributed with Xavier Olive's `traffic` project, pinned at commit `1d34bad4ec54cd27b75952d67302f918a836acbd`. The repository publishes aggregate metric tables and figures; raw downloads, per-observation flight exports and aircraft identifiers are excluded. Source information: [traffic sample documentation](https://traffic-viz.github.io/data_sources/samples.html).

All radar observations are synthetic. Recorded positions are reference trajectories with an unverified altitude datum, using approximate local horizontal coordinates and relative altitude. Replay velocity RMSE and full-state NEES are omitted because exact velocity truth is unavailable. The constant-velocity model's limitations appear during turns and long gaps; simulation provides controlled truth for evaluating uncertainty.

The `.gitignore` allows only the documented MATLAB source, selected result plots/tables and active report files, together with the README and ignore rules. Local working records and build intermediates are excluded.
