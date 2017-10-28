function W_1 = body2inertial_angular_vel(angles)

phi = angles(1);
theta = angles(2);
psi = angles(3);

W_1 = [1 sind(phi)*tand(theta) cosd(phi)*tand(theta); ...
       0 cosd(phi) -sind(phi); ...
       0 sind(phi)/cosd(theta) cosd(phi)/cosd(theta)];   
end