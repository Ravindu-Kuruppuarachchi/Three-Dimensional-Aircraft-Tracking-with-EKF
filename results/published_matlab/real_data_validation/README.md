# Representative process-noise comparison

Eight saved MATLAB executions compare `q=1` and `q=10` for Belevingsvlucht and Texas over the 30–40 and 60–70 minute windows. Each pair uses the same virtual-radar observations (seed 2000). Range-noise standard deviation is 50 m and both angular standard deviations are 0.5 degrees. Only the process-noise setting changes within a pair.

- `comparison_summary.csv`: all eight original metric rows with flight, window start and q.
- `<flight>_<start>s_q<q>/metrics.csv`: 3D, horizontal and vertical position RMSE, mean NIS and raw 3D RMSE.
- `trajectory_3d.png` and `errors_nis.png`: original MATLAB figures.
- `estimates.csv`: saved elapsed time, six EKF states and NIS. Row one is undefined, row two initialises the filter, and scoring starts at row three. Positions are metres and velocities are m/s.

The estimates and metrics are unchanged copies of the returned MATLAB outputs. The summary only adds identifiers and combines metric rows. These single executions differ from the report's 20-noise-realisation averages.

## Run in MATLAB

From `matlab/`, run `run_real_data_validation` or `run_real_data_validation(false)` to skip figures. The entry point uses `tracking_config`, `run_filters`, `evaluate_tracking` and `plot_tracking`. It requires `data/real_data_validation/manifest.json` and the measurement/reference CSVs named by that manifest. Prepared inputs are not distributed here. Without them, the published results can be inspected but the original replay cannot be reproduced from this checkout alone. Simulations remain runnable without external data.

Recorded paths are references from the traffic sample collection, not exact sensor truth. Radar observations are simulated. The original data notices remain in the local data folders. No raw downloads, measurement exports or MAT files are included in this results selection.
