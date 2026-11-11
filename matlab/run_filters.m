function out = run_filters(t,z,cfg)
% EKF uses only timestamps, observations and configuration.
% Rows 1-2 are initialization, never scored. Missing rows predict only.
t=t(:); n=numel(t);
assert(n>=3 && size(z,1)==n && size(z,2)==3, 'Need Nx3 observations.');
assert(all(isfinite(t)) && all(diff(t)>0), 'Timestamps must increase.');
assert(all(all(isfinite(z(1:2,:)))), 'First two observations must be present.');
present=all(isfinite(z),2); missing=all(isnan(z),2);
assert(all(present | missing), 'Each observation must be all finite or all NaN.');
assert(all(z(present,1)>0) && all(abs(z(present,3))<pi/2), ...
    'Present observations require positive range and elevation strictly inside (-pi/2,pi/2).');
[p1,C1]=convert_radar(z(1,:)',cfg.R);
[p2,C2]=convert_radar(z(2,:)',cfg.R);
d=t(2)-t(1); x0=[p2;(p2-p1)/d];
P0=[C2 C2/d; C2/d (C1+C2)/d^2];
out.ekf=NaN(n,6);
out.ekf_cov=NaN(6,6,n);
out.ekf_nis=NaN(n,1);
out.ekf_updated=false(n,1);
out.ekf(2,:)=x0';
out.ekf_cov(:,:,2)=P0;
xe=x0; Pe=P0;
for k=3:n
    [F,Q]=cv_model(t(k)-t(k-1),cfg.q);
    xe=F*xe; Pe=F*Pe*F'+Q;
    if present(k)
        [h,H,valid]=radar_model(xe,cfg);
        if valid
            v=z(k,:)'-h; v(2)=wrap_angle(v(2));
            [xe,Pe,out.ekf_nis(k)]=update(xe,Pe,v,H,cfg.R);
            out.ekf_updated(k)=true;
        end
    end
    Pe=(Pe+Pe')/2;
    out.ekf(k,:)=xe';
    out.ekf_cov(:,:,k)=Pe;
end
end
function [x,P,nis]=update(x,P,v,H,R)
S=H*P*H'+R; K=(P*H')/S;
nis=v'*(S\v); x=x+K*v; A=eye(6)-K*H;
P=A*P*A'+K*R*K'; P=(P+P')/2;
end
