function figs = plot_tracking(t,truth,z,out,cfg,scenario)
raw=NaN(size(truth,1),3);
for k=1:size(z,1)
    if all(isfinite(z(k,:))) && z(k,1)>0 && abs(z(k,3))<pi/2
        raw(k,:)=convert_radar(z(k,:)',cfg.R)';
    end
end
figs(1)=figure('Name',['3D tracking: ' scenario],'Color','w');
plot3(truth(:,1),truth(:,2),truth(:,3),'k-','LineWidth',1.5); hold on;
plot3(raw(:,1),raw(:,2),raw(:,3),'.','Color',[.75 .75 .75]);
plot3(out.ekf(:,1),out.ekf(:,2),out.ekf(:,3),'b-','LineWidth',1.3);
plot3(0,0,0,'kp','MarkerFaceColor','y','MarkerSize',12);
xlabel('East (m)'); ylabel('North (m)'); zlabel('Up (m)');
legend('Truth/reference','Radar converted','EKF','Radar','Location','best');
grid on; axis equal; view(3); rotate3d on; title(['3D virtual radar: ' scenario]);
figs(2)=figure('Name','Tracking error and innovations','Color','w');
subplot(2,1,1); plot(t,vecnorm(out.ekf(:,1:3)-truth(:,1:3),2,2),'b');
ylabel('Position error (m)'); legend('EKF'); grid on;
subplot(2,1,2); plot(t,out.ekf_nis,'b');
hold on; yline(3,'k:','Nominal expectation (matched model)');
xlabel('Elapsed time (s)'); ylabel('NIS'); grid on;
end
