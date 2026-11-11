function [metrics,nees] = evaluate_tracking(truth,z,out,cfg)
n=size(truth,1); idx=(3:n)'; nees=NaN(n,1);
metrics=struct(); est=out.ekf;
e=est(idx,1:3)-truth(idx,1:3);
metrics.ekf_position_rmse_m=sqrt(mean(sum(e.^2,2)));
metrics.ekf_horizontal_rmse_m=sqrt(mean(sum(e(:,1:2).^2,2)));
metrics.ekf_vertical_rmse_m=sqrt(mean(e(:,3).^2));
if all(all(isfinite(truth(:,4:6))))
    ev=est(idx,4:6)-truth(idx,4:6);
    metrics.ekf_velocity_rmse_mps=sqrt(mean(sum(ev.^2,2)));
end
nis=out.ekf_nis; good=isfinite(nis);
metrics.ekf_mean_nis=mean(nis(good));
raw=NaN(n,3);
for k=3:n
    if all(isfinite(z(k,:))) && z(k,1)>0 && abs(z(k,3))<pi/2
        raw(k,:)=convert_radar(z(k,:)',cfg.R)';
    end
    if all(isfinite(truth(k,:)))
        e=out.ekf(k,:)'-truth(k,:)';
        nees(k)=e'*(out.ekf_cov(:,:,k)\e);
    end
end
good=all(isfinite(raw),2);
metrics.raw_position_rmse_m=sqrt(mean(sum((raw(good,:)-truth(good,1:3)).^2,2)));
if any(isfinite(nees)), metrics.ekf_mean_nees=mean(nees(isfinite(nees))); end
end
