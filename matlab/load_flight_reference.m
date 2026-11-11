function [t,truth] = load_flight_reference(path)
% Approximate local horizontal frame, altitude relative to first sample.
% ADS-B altitude is not established as ellipsoidal height; not geodetic ENU.
T=readtable(path); required={'elapsed_s','latitude_deg','longitude_deg','altitude_ft'};
assert(all(ismember(required,T.Properties.VariableNames)), 'Unexpected CSV columns.');
t=T.elapsed_s; lat=T.latitude_deg*pi/180; lon=T.longitude_deg*pi/180;
h=T.altitude_ft*0.3048;
assert(all(isfinite([t;lat;lon;h])) && all(diff(t)>0),'Invalid reference samples.');
x=10000+6371000*cos(lat(1))*(lon-lon(1));
y=5000+6371000*(lat-lat(1)); z=2000+h-h(1);
truth=[x y z NaN(numel(t),3)];
end
