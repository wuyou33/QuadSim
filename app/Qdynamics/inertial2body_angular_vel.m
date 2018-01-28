function W = inertial2body_angular_vel(angles)

phi = angles(1);
theta = angles(2);
psi = angles(3);

W = [1 0 -sind(theta); ...
     0 cosd(phi) cosd(theta)*sind(phi); ...
     0 -sind(phi) cosd(theta)*cosd(phi)];
end