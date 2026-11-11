function check_python_reference()
% Shared observations remove the difference between Python/MATLAB RNGs.
root=fileparts(fileparts(mfilename('fullpath')));
D=readtable(fullfile(root,'data','validation','shared_case.csv'));
E=readtable(fullfile(root,'data','validation','python_reference.csv'));
cfg=tracking_config();
out=run_filters(D.t_s,D{:,{'range_m','azimuth_rad','elevation_rad'}},cfg);
truth=D{:,{'px_m','py_m','pz_m','vx_mps','vy_mps','vz_mps'}};
[~,nees]=evaluate_tracking(truth,D{:,{'range_m','azimuth_rad','elevation_rad'}},out,cfg);
actual=[D.t_s out.ekf out.ekf_nis nees];
expected=E{:,:};
assert(isequal(size(actual),size(expected)), 'Reference shape mismatch.');
assert(isequal(isnan(actual),isnan(expected)), 'Reference NaN-mask mismatch.');
mask=isfinite(expected); err=abs(actual(mask)-expected(mask));
limit=1e-7+1e-8*abs(expected(mask));
assert(all(err<=limit),'Python/MATLAB parity failed.');
fprintf('Python/MATLAB shared-fixture parity passed; max absolute difference %.3g.\n',max(err));
end
