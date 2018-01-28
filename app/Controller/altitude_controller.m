function out = altitude_controller(alt, target)

% altitude controller desing:
% 
% target_alt --> desired vel --> limit desired vel --> base throttle
param_set

persistent pwm

if isempty(pwm)
    pwm = 0;
end

vel_des = -PID(alt, target, 0.5, 0, 0);

if vel_des > max_alt_vel
    vel_des = max_alt_vel;
elseif vel_des < -max_alt_vel
    vel_des = -max_alt_vel;
end

vel_des
vel_z
pwm = pwm -PID(vel_z, vel_des, 0.8,0.01,0);

if pwm < 0
    pwm = 0;
end

out = pwm

out


end