function out = attitude_controller(angles_des, angles, omega, baseThr)
param_set

%% setup
% quadcopter layout
%       front
%         ^
%     4   |   2
%         |
%         +----->    
%          
%     3       1
%
%       z (out of page)


% motor      1   2   3   4      % ch
% motor_map = [...
%             -1   1   1  -1; ... % throttle
%              1  -1   1  -1; ... % roll
%              1   1  -1  -1; ... % pitch
%             -1  -1  -1  -1];    % yaw

motor_map = [...
             1   1   1   1; ... % throttle
             1   1  -1  -1; ... % roll
            -1   1  -1   1; ... % pitch
             1  -1  -1   1];    % yaw

%% angle to rate
dangle_roll = -PID(angles(1), angles_des(1), 10, 0, 0);
dangle_pitch = -PID(angles(2), angles_des(2), 10, 0, 0);
dangle_yaw = -PID(angles(3), angles_des(3), 10, 0, 0);
%% rate controller
rate_des = [dangle_roll dangle_pitch dangle_yaw]; % desired rate degree/s

dpwm_roll = PID(omega(1), rate_des(1), 0.005, 0, 0.00010) * motor_map(2, :);
dpwm_pitch = PID(omega(2), rate_des(2), 0.005, 0, 0) * motor_map(3, :);
dpwm_yaw = PID(omega(3), rate_des(3), 0.01, 0, 0) * motor_map(4, :);


pwm = dpwm_roll + dpwm_yaw + dpwm_pitch;

out = motor_map(1,:) * baseThr + pwm;

out = out .* [-1 1 1 -1];

%% PWM generation

end