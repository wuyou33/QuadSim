% creating parameters for workspaces
% all length in mm
%% quad dimensions
quad.r = 250/1000; % length of quad arm in m
quad.prop_r = 152.4/1000;
quad.motor_h = 50/1000; % height of motor


%% dynamic properties
quad.g = 9.81; %m/s^2
quad.mass = 4; %kg

quad.Ixx = 0.082;
quad.Iyy = 0.082;
quad.Izz = 0.149;

quad.rho = 1.184;
quad.A = 0.0855
quad.ct = 0.0048; % thrust coefficient
quad.cq = 2.315e-4; % drag coefficient
quad.J = [quad.Ixx 0 0;0 quad.Iyy 0;0 0 quad.Izz];
quad.Jr = [quad.Ixx/20 0 0;0 quad.Iyy/20 0;0 0 quad.Izz/20];



%% initial conditions
x0.phi = 0;
x0.the = 0;
x0.psi = 0;
x0.p = 0;
x0.q = 0;
x0.r = 0;

x0.X = 0;
x0.Y = 0;
x0.Z = 0;
x0.u = 0;
x0.v = 0;
x0.w = 0;



%% testing
close all
state = [0 0 0.2 pi/6 0 0];





% R = Rzyx(angle);
% pc = R'*pc';
% cline = R'*cline';
% 
% cline = cline';
% pc = pc';

close all
plot(pc(:, 2), pc(:,3),'.r') 
hold on
%plot(cline(:, 2), cline(:,3), 'ob')
%plot(pos_y, pos_z, 'ok')
hold off

axis equal

%% need another & in the wall check