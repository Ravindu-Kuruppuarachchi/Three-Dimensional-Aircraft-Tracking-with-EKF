function z = generate_radar(truth,cfg)
rng(cfg.seed,'twister'); n=size(truth,1); z=NaN(n,3);
for k=1:n
    h=radar_model(truth(k,:)',cfg);
    z(k,:)=(h+cfg.sigma.*randn(3,1))';
end
z(:,2)=wrap_angle(z(:,2));
% Nonphysical range/elevation is retained; run_filters rejects invalid input.
end
