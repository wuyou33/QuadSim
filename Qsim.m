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
pwm = [-2 2.3 2.3 -2];
angles = [0 0 40]';
omega = [0 0 0]';   % angular vel
v = [0 0 0]';       % linear vel
pos = [0 0 4]';
time = 0;
A = [0];
%% run
figure(1);

for steps = 1:20000
    tic
    
    %oPWM = PID(angles(2), 0, 0.1, 0.002, 3);
    oPWM = PID(angles(3), 0, 0.001, 0, 0.01);
    pwm = [-2 2 2 -2] + -[1 1 1 1] * oPWM;
    
    a = accel(pwm, angles);                 % linear acceleration F_inertial
    omegadot = angular_accel(omega, pwm)   % angular acceleration F_body
    
    angle_dot = vel2angle_dot(omega, angles); % body frame angular vel    
    
    angle_ddot = omega_dot2angle_ddot(omega, angle_dot, angles, pwm); % angular accerlation F_inertial
    
    % update pos 
    v = v + a * dt;
    pos = pos + v * dt;
   
    % update angles
    omega = omega + omegadot * dt;
    angles = angles + angle_dot * dt;
    
    R = body2inertial_rotation(angles); 
    
    % ploting -----------------------------------------------------------
    clf
    hold on;
    plot_quad(R, pos);
    hold off;
   
    view(0, 90);
    grid on
    n = 4;
    %xlim([-1 1]);
    %ylim([-10 10]);
    %zlim([0 n]);
    axis equal 
    
    pause(0.0001);
    
    dt = toc;
end
