# Ten-flight repeated benchmark

[Project overview](../../README.md) · [Final report](../../report/Mini_project_220350T.pdf) · [Representative comparisons](../published_matlab/real_data_validation/README.md)

This folder publishes the numerical evidence behind the report's 1,200-run evaluation:

`10 recorded flights × 3 windows × 20 noise seeds × 2 process-noise settings = 1,200 runs`.

- `trials.csv`: one metric row per run, identified by flight, window start, q and seed. Includes 3D/horizontal/vertical RMSE, raw error, NIS and update counts.
- `summary.json`: existing aggregated results and comparison counts.
- `protocol.json`: saved settings, windows, seed list and aggregation rules.

Windows start at 0, 1800 and 3600 seconds and last 600 seconds. Noise seeds are 3000–3019. Both q=1 and q=10 use paired observations, with fixed range/angle standard deviations of 50 m and 0.5 degrees. Flight-level summaries average trial RMSE values equally across windows. They are not pooled sample RMSEs.

These are saved results of the extended benchmark, separate from the 13 returned MATLAB executions, which include the eight representative comparison cases. This folder does not establish that all 1,200 runs were executed in MATLAB. No MATLAB batch driver for this benchmark is currently supplied. Raw data and per-observation inputs/histories remain excluded, so this publication supports inspection of every run's metrics, not self-contained replay of all runs.

Recorded trajectories come from the [traffic sample trajectory collection](https://traffic-viz.github.io/data_sources/samples.html). Radar observations are simulated. No new experiments were performed when preparing these files for publication.

Native timestamps are retained, and the first two observations in each window initialise the filter and are excluded from scoring. Changing the seed changes the noise draw while keeping the noise standard deviations fixed.
