function [F,Q] = cv_model(dt,q)
assert(isscalar(dt) && isfinite(dt) && dt > 0, 'dt must be positive.');
assert(isscalar(q) && isfinite(q) && q >= 0, 'q must be nonnegative.');
I = eye(3);
F = [I dt*I; zeros(3) I];
Q = q*[dt^3/3*I dt^2/2*I; dt^2/2*I dt*I];
end
