# Published MATLAB results

Original plots and metrics from 13 MATLAB runs are preserved here: three simulated scenarios and ten replay executions using Belevingsvlucht and Texas. Every run includes `trajectory_3d.png`, `errors_nis.png` and `metrics.csv`.

The [representative process-noise comparison](real_data_validation/README.md) contains eight replay executions comparing q=1 and q=10 on identical observations in the 30–40 and 60–70 minute windows. It additionally includes original `estimates.csv` histories and `comparison_summary.csv` combining all eight metric rows. The combined table is an index of existing results, not a new experiment. These individual runs are distinct from repeated-trial averages in the report.

The MATLAB entry point is `matlab/run_real_data_validation.m`. Reproduction requires the separately prepared inputs described in the comparison README. Raw data, input measurement exports and MAT files remain excluded. All radar observations are synthetic and recorded paths have an unverified altitude datum.
