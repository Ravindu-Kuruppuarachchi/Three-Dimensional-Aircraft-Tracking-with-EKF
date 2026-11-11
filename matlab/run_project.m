function result = run_project(scenario,seed,makePlots,flight)
% RUN_PROJECT 3D radar tracking without additional MATLAB toolboxes.
% In MATLAB Online, cd to matlab/, then: run_project('turn')
% Scenarios: straight, turn, dropout, replay. Results saved in results/matlab/.
if nargin<1, scenario='turn'; end
if nargin<2, seed=42; end
if nargin<3, makePlots=true; end
if nargin<4, flight='belevingsvlucht'; end
assert(any(strcmp(flight,{'belevingsvlucht','texas'})), 'Unknown flight sample.');
here=fileparts(mfilename('fullpath')); root=fileparts(here);
cfg=tracking_config(); cfg.seed=seed;
if strcmp(scenario,'replay')
    [t,truth]=load_flight_reference(fullfile(root,'data','flight_tracks','processed',[flight '_10min.csv']));
else
    [t,truth]=generate_truth(scenario);
end
z=generate_radar(truth,cfg);
if strcmp(scenario,'dropout'), z(t>=200 & t<=220,:)=NaN; end
out=run_filters(t,z,cfg); [metrics,nees]=evaluate_tracking(truth,z,out,cfg);
label=scenario;
if strcmp(scenario,'replay'), label=[scenario '_' flight]; end
folder=fullfile(root,'results','matlab',[label '_seed' num2str(seed)]);
if ~exist(folder,'dir'), mkdir(folder); end
T=array2table([t truth z], 'VariableNames', ...
    {'t_s','px_m','py_m','pz_m','vx_mps','vy_mps','vz_mps','range_m','azimuth_rad','elevation_rad'});
writetable(T,fullfile(folder,'measurements.csv'));
T=array2table([t out.ekf out.ekf_nis nees], 'VariableNames', ...
    {'t_s','ekf_px','ekf_py','ekf_pz','ekf_vx','ekf_vy','ekf_vz', ...
    'ekf_nis','ekf_nees'});
writetable(T,fullfile(folder,'estimates.csv'));
writetable(struct2table(metrics),fullfile(folder,'metrics.csv'));
save(fullfile(folder,'run.mat'),'cfg','t','truth','z','out','metrics','nees');
if makePlots
    figs=plot_tracking(t,truth,z,out,cfg,scenario);
    saveas(figs(1),fullfile(folder,'trajectory_3d.png'));
    saveas(figs(2),fullfile(folder,'errors_nis.png'));
end
result=struct('config',cfg,'time',t,'truth',truth,'observations',z,'filters',out,'metrics',metrics);
disp(metrics); fprintf('Saved results: %s\n',folder);
end
