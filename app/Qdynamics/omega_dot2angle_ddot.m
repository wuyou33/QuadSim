function angle_ddot = omega_dot2angle_ddot(omega, angle_dot, angles, pwm)

dphi = angle_dot(1);
dtheta = angle_dot(2);
dpsi = angle_dot(3);

phi = angles(1);
theta = angles(2);
psi = angles(3);

m12 = dphi*cosd(phi)*tan(theta) + dtheta*sind(phi)/cosd(theta)^2;
m13 = -dphi*sind(phi)*cosd(theta) + dtheta*cosd(phi)/cosd(theta)^2;
m22 = -dphi * sind(phi);
m23 = -dphi * cosd(phi);
m32 = dphi*cosd(phi)/cosd(theta) + dphi*sind(phi)*tand(theta)/cosd(theta);
m33 = -dphi*sind(phi)/cosd(theta) + dtheta*cosd(phi)*tand(theta)/cosd(theta);


A = [ 0 m12 m13;
      0 m22 m23;
      0 m32 m33];

omegadot = angular_accel(omega, pwm);  
 
W_1 = body2inertial_angular_vel(angles);

angle_ddot = A * omega + W_1 * omegadot;
end