function [R, pos_out, angles_out, omega_out] = quad_dynamics(pwm, pos_res, angles_res)
param_set

persistent a
persistent omega
persistent v
persistent pos
persistent angles

%% init static varibale
if isempty(a)
    a = 0;
end

if isempty(v)
    v = [0 0 0]';
end

if isempty(omega)
    omega = [0 0 0]';
end

if isempty(angles)
    angles = [0 0 0]';
end

if isempty(pos)
    pos = [0 0 0]';
end

%% dynamics
a = accel(pwm, angles);                 % linear acceleration F_inertial
omegadot = angular_accel(omega, pwm);   % angular acceleration F_body

angle_dot = vel2angle_dot(omega, angles); % body frame angular vel    

angle_ddot = omega_dot2angle_ddot(omega, angle_dot, angles, pwm); % angular accerlation F_inertial

% update pos 
v = v + a * dt;
pos = pos + v * dt;

% update angles
omega = omega + omegadot * dt;
angles = angles + angle_dot * dt;

% output
angles_out = angles;
pos_out = pos;
omega_out = omega;

R = body2inertial_rotation(angles); 

%% reset 

% reset position
if ~isempty(pos_res)
    pos = pos_res;
    a = [0 0 0]';
    v = [0 0 0]';
end

% reset angles + angular vel
if ~isempty(angles_res)
    angles = angles_res;
    omega = [0 0 0]';
end

end