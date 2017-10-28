function tau = torque(pwm)
param_set

tau = [arm*kmotor*(pwm(1)^2 - pwm(3)^2 + pwm(2)^2 - pwm(4)^2); ...
       arm*kmotor*(pwm(1)^2 - pwm(2)^2 + pwm(3)^2 - pwm(4)^2); ...
       b_drag * (-pwm(1)^2 + pwm(3)^2 + pwm(2)^2 - pwm(4)^2)];
   
tau = round(tau, 10);
end 