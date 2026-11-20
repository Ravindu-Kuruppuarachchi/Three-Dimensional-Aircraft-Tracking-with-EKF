# Published MATLAB results

[Project overview](../../README.md) · [Final report](../../report/Mini_project_220350T.pdf) · [MATLAB usage](../../matlab/README.md)

Original plots and metrics from 13 MATLAB runs are preserved here: three simulated scenarios and ten replay executions using Belevingsvlucht and Texas. Every run includes `trajectory_3d.png`, `errors_nis.png` and `metrics.csv`.

The [representative process-noise comparison](real_data_validation/README.md) contains eight replay executions comparing q=1 and q=10 on identical observations in the 30–40 and 60–70 minute windows. It additionally includes original `estimates.csv` histories and `comparison_summary.csv` combining all eight metric rows. The combined table is an index of existing results, not a new experiment. These individual runs are distinct from repeated-trial averages in the report.

The MATLAB entry point is `matlab/run_real_data_validation.m`. Reproduction requires the separately prepared inputs described in the comparison README. Raw data, input measurement exports and MAT files remain excluded. All radar observations are synthetic and recorded paths have an unverified altitude datum.

## Reading the results

Position, horizontal and vertical RMSE measure EKF error in metres. Raw position RMSE measures the unfiltered converted radar observations. NIS compares the measurement innovation with its predicted uncertainty. The first two observations initialise the filter and are excluded from scoring. During an outage, compare raw error with observed-time EKF error because raw measurements are absent inside the gap.

For averages over 20 noise realisations, see the [1,200-run benchmark](../expanded_flights/README.md). The eight representative comparison cases are included in the 13 MATLAB executions counted above.
