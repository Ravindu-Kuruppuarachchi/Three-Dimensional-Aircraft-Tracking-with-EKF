function cfg = tracking_config()
% SI units; q is continuous white acceleration spectral density (m^2/s^3).
cfg.q = 1;
cfg.sigma = [50; 0.5*pi/180; 0.5*pi/180];
cfg.R = diag(cfg.sigma.^2);
cfg.seed = 42;
cfg.min_range = 1;
cfg.min_rho = 1;
end
