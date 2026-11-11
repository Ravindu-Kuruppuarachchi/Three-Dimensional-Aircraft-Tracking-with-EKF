function [p,C,J] = convert_radar(z,R)
% Radar position conversion and first-order covariance for initialization.
r=z(1); a=z(2); e=z(3); ca=cos(a); sa=sin(a); ce=cos(e); se=sin(e);
p=[r*ce*ca; r*ce*sa; r*se];
J=[ce*ca -r*ce*sa -r*se*ca; ce*sa r*ce*ca -r*se*sa; se 0 r*ce];
C=J*R*J'; C=(C+C')/2;
end
