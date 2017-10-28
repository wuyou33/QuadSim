function a = accel(pwm, angles)

param_set

phi = angles(1);
theta = angles(2);
psi = angles(3);

rot = [cosd(psi)*sind(theta)*cosd(phi) + sind(psi)*sind(phi); ...
       sind(psi)*sind(theta)*cosd(phi) - cosd(psi)*sind(phi); ...
       cosd(theta)*cosd(phi)];

T = thrust(pwm);
   
a = g * [0;0;1] + T/qmass * rot;

end