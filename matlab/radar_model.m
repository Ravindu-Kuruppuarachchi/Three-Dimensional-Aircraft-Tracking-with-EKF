function [z,H,valid] = radar_model(x,cfg)
% State [east north up vx vy vz]; angles in radians.
p = x(1:3); rho = hypot(p(1),p(2)); r = norm(p);
valid = r >= cfg.min_range && rho >= cfg.min_rho;
z = [r; atan2(p(2),p(1)); atan2(p(3),rho)];
H = NaN(3,6);
if ~valid, return; end
H = [p'/r zeros(1,3); ...
    -p(2)/rho^2 p(1)/rho^2 0 zeros(1,3); ...
    -p(1)*p(3)/(r^2*rho) -p(2)*p(3)/(r^2*rho) rho/r^2 zeros(1,3)];
end
