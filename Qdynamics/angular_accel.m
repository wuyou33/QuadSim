function omegadot = angular_accel(omega, pwm)
param_set

p = omega(1);
q = omega(2);
r = omega(3);

A = [(Iyy - Izz) * q * r / Ixx; ...
     (Izz - Ixx) * p * r / Iyy; ...
     (Ixx - Iyy) * p * q / Izz];
 
B = [q/Ixx; - p/Iyy; 0];

tau = torque(pwm);

C = [tau(1)/Ixx; ...
     tau(2)/Iyy; ...
     tau(3)/Izz];
 
omegadot = A - Im * B * (pwm(1)+pwm(2)+pwm(3)+pwm(4)) + C;
 
end