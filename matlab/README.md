# MATLAB implementation

[Project overview](../README.md) · [Final report](../report/Mini_project_220350T.pdf) · [Saved MATLAB results](../results/published_matlab/README.md)

Open this folder in MATLAB or MATLAB Online and run:

```matlab
run_checks
result = run_project('straight');
result = run_project('turn');
result = run_project('dropout');
```

These simulations generate their inputs and require no external dataset or specialized toolbox. The checks validate model covariances, Jacobians, angle wrapping, malformed-input rejection, outages and irregular timing. Optional saved-reference checks are skipped when their input files are absent.

`run_project(scenario, seed, makePlots, flight)` defaults to `('turn',42,true,'belevingsvlucht')`. Set `makePlots` to `false` for numerical output only. Results are saved under `results/matlab/`, including observations, estimates, metrics, a MAT file and, when enabled, two PNG figures. Published earlier results are preserved separately under `results/published_matlab/`.

## Models and scenarios

The state is `[east north up vx vy vz]`, using metres, seconds and radians. The virtual radar is at the origin and measures range, azimuth and elevation. Default process spectral density is `q=1 m²/s³`; observation standard deviations are 50 m, 0.5 degrees and 0.5 degrees.

Two measurements initialize position and velocity with their cross-covariance. Updates and scores start at the third sample. The EKF wraps azimuth innovations and uses matrix solves and a Joseph covariance update. Missing observations predict only; malformed observations are rejected. Near-origin and overhead predicted geometry skip the singular update.

- `straight`: 600 seconds of constant velocity.
- `turn`: horizontal turn at 180–240 seconds and climb at 300–420 seconds.
- `dropout`: the same manoeuvre with observations missing at 200–220 seconds inclusive.

## Recorded-flight replay

Replay requires locally supplied prepared data; saved comparison estimates are included, but the reference and radar-input files required for replay are not distributed. With the expected `data/flight_tracks/processed/` clips restored alongside `matlab/`, run:

```matlab
result = run_project('replay');
result = run_project('replay',42,true,'texas');
```

`run_real_data_validation` additionally requires the prepared plan, shared observations and expected histories under `data/real_data_validation/`. It evaluates held-out segments at q=1 and q=10. Use `run_real_data_validation(false)` to omit figures.

The saved outputs have been audited. See [representative comparison results](../results/published_matlab/real_data_validation/README.md) for all eight cases, including original metric rows, plots, estimate histories and a combined summary. Compare each flight/window at q=1 against q=10 using identical observations. Published outputs are preserved separately from newly generated runs.

Flight replays preserve native timing and use approximate local horizontal coordinates with relative altitude. All radar measurements are synthetic. Exact replay velocity truth is unavailable, so velocity RMSE and NEES are omitted. Raw errors exclude missing observations; use observed-time EKF errors for a matching outage comparison.

## Repeated-trial results

The [ten-flight benchmark](../results/expanded_flights/README.md) publishes all 1,200 metric rows and the saved protocol. The eight-case `run_real_data_validation` command does not execute that full benchmark. A MATLAB batch driver and its prepared inputs for all 1,200 cases are not included.
