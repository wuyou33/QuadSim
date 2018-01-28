function T = thrust(pwm)
param_set

T = kmotor * sum(pwm.^2);

end
