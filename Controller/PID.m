function output = PID(in, setpt, kp, ki, kd)
param_set

persistent err_sum 
persistent prev_err 

maxI = 100;

if isempty(err_sum)
    err_sum = 0;
end

if isempty(prev_err)
    prev_err = 0;
end

err = in - setpt;

err_sum = err_sum + err;

if err_sum > maxI
    err_sum = maxI;
elseif err_sum < -maxI
    err_sum = -maxI;
end

dterm = (err - prev_err)/0.075;

output = kp * err + ki * err_sum + kd * dterm;

prev_err = err;

end