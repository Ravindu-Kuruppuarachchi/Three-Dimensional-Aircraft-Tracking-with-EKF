function run_checks()
% Mathematical and numerical checks; run in MATLAB before trusting results.
cfg=tracking_config();
for dt=[0.1 1 7]
    [F,Q]=cv_model(dt,cfg.q);
    assert(isequal(size(F),[6 6]) && norm(Q-Q','fro')<1e-12);
    assert(min(eig(Q))>=-1e-10,'Q is not positive semidefinite.');
end
states=[10000 5000 2000 100 20 0; -8000 2500 3000 0 20 3; -6000 -2 1000 1 0 0];
for i=1:size(states,1)
    x=states(i,:)'; [~,H,valid]=radar_model(x,cfg); assert(valid);
    numerical=zeros(3,6); step=0.001;
    for j=1:6
        d=zeros(6,1); d(j)=step;
        a=radar_model(x+d,cfg); b=radar_model(x-d,cfg); v=a-b;
        v(2)=wrap_angle(v(2)); numerical(:,j)=v/(2*step);
    end
    assert(max(abs(H(:)-numerical(:)))<1e-7,'Radar Jacobian mismatch.');
    [z,~,~]=radar_model(x,cfg); [p,~,J]=convert_radar(z,cfg.R);
    assert(norm(p-x(1:3))<1e-8,'Radar round trip failed.');
    numeric=zeros(3); delta=[0.01;1e-6;1e-6];
    for j=1:3
        d=zeros(3,1); d(j)=delta(j);
        numeric(:,j)=(convert_radar(z+d,cfg.R)-convert_radar(z-d,cfg.R))/(2*delta(j));
    end
    assert(max(abs(J(:)-numeric(:)))<1e-5,'Conversion Jacobian mismatch.');
end
assert(abs(wrap_angle((-pi+0.01)-(pi-0.01))-0.02)<1e-12,'Angle boundary failed.');
[~,~,valid]=radar_model([0;0;100;0;0;0],cfg); assert(~valid,'Overhead guard failed.');
[t,truth]=generate_truth('straight'); z=generate_radar(truth,cfg); a=run_filters(t,z,cfg);
z2=generate_radar(truth,cfg); assert(isequal(z,z2),'RNG repeatability failed.');

% Malformed rows must fail explicitly rather than silently become outages.
for bad={[NaN 0 0],[Inf 0 0],[0 0 0],[100 0 pi/2],[100 0 -pi/2]}
    malformed=z; malformed(3,:)=bad{1}; rejected=false;
    try
        run_filters(t,malformed,cfg);
    catch
        rejected=true;
    end
    assert(rejected,'Malformed observation was accepted.');
end

for k=2:numel(t)
    C=a.ekf_cov(:,:,k);
    assert(norm(C-C','fro')<1e-8 && min(eig(C))>-1e-7,'Invalid posterior covariance.');
end
z(201:221,:)=NaN; b=run_filters(t,z,cfg);
assert(~any(b.ekf_updated(201:221)));
[F,Q]=cv_model(t(201)-t(200),cfg.q);
assert(norm(b.ekf(201,:)'-F*b.ekf(200,:)')<1e-9,'Outage prediction failed.');
assert(norm(b.ekf_cov(:,:,201)-(F*b.ekf_cov(:,:,200)*F'+Q),'fro')<1e-7);
% Nearly noiseless observations expose timing/initialization mistakes.
c=cfg; c.R=diag([1e-6 1e-14 1e-14]); z=zeros(numel(t),3);
for k=1:numel(t), z(k,:)=radar_model(truth(k,:)',c)'; end
b=run_filters(t,z,c); delta=b.ekf(3:end,:)-truth(3:end,:);
assert(max(abs(delta(:)))<1e-5,'Noiseless straight flight timing failed.');
% Nonuniform timestamps must rebuild F and Q, rather than assume dt=1.
keep=[1 2 4 8 13 20 31]; b=run_filters(t(keep),z(keep,:),c);
delta=b.ekf(3:end,:)-truth(keep(3:end),:);
assert(max(abs(delta(:)))<1e-5,'Nonuniform timestamps failed.');
fprintf('All MATLAB mathematical/numerical checks passed.\n');
root=fileparts(fileparts(mfilename('fullpath')));
if exist(fullfile(root,'data','validation','python_reference.csv'),'file')
    check_python_reference();
else
    fprintf('Shared Python reference not found; parity check not run.\n');
end
end
