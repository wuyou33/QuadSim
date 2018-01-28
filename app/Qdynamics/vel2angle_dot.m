% inertial frame angle_dot

function angle_dot = vel2angle_dot(omega, angles)

W_1 = body2inertial_angular_vel(angles);

angle_dot = W_1 * omega;

end