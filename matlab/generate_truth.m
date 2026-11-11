function [t,truth] = generate_truth(scenario)
t=(0:600)'; u=min(max(t-180,0),60); w=pi/180; a=w*u;
truth=[10000+100*t 5000+20*t 2000+zeros(size(t)) ...
    100+zeros(size(t)) 20+zeros(size(t)) zeros(size(t))];
if strcmp(scenario,'straight'), return; end
assert(any(strcmp(scenario,{'turn','dropout'})), 'Unknown simulation scenario.');
pturn=[10000+100*180 5000+20*180];
px=pturn(1)+100*sin(a)/w+20*(cos(a)-1)/w;
py=pturn(2)+100*(1-cos(a))/w+20*sin(a)/w;
vx=100*cos(a)-20*sin(a); vy=100*sin(a)+20*cos(a);
active=t>=180; after=max(t-240,0);
truth(active,1)=px(active)+vx(active).*after(active);
truth(active,2)=py(active)+vy(active).*after(active);
truth(active,4)=vx(active); truth(active,5)=vy(active);
truth(:,3)=2000+3*min(max(t-300,0),120);
truth(:,6)=3*(t>=300 & t<420);
end
