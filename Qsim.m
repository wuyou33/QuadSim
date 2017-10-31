%% init
clear all
close all 
clc

% adding subfolder 
folder = strcat(fileparts(which('Qsim.m')), '\Qdynamics'); 
addpath(genpath(folder));
folder = strcat(fileparts(which('Qsim.m')), '\Controller'); 
addpath(genpath(folder));

param_set

%% variables

% initialise variables 
pwm = [-2.3 2 2 -2.3];
angles = [0 0 0]';
omega = [0 0 0]';   % angular vel
v = [0 0 0]';       % linear vel
pos = [0 0 4]';
time = 0;
A = [0];
angle_dot = [0 0 0]';
%% run
figure(1);

for steps = 1:20000
    tic
    
    pwm = attitude_controller([10 10 5], angles, omega, 20);

    
    [R, pos, angles, omega] = quad_dynamics(pwm, [], []);

    
    % ploting -----------------------------------------------------------
    clf
    hold on;
    plot_quad(R, pos);
    hold off;
   
    view(90, 0);
    grid on
    n = 4;
    %xlim([-1 1]);
    %ylim([-10 10]);
    %zlim([0 n]);
    axis equal 
    
    pause(0.001);
    
    dt = toc;
end
