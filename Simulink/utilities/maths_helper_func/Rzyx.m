function R = Rzyx(angles)
    phi = angles(1);
    theta = angles(2);
    psi = angles(3);

    r11 = cos(psi) * cos(theta);
    r12 = cos(psi) * sin(theta) * sin(phi) - sin(psi) * cos(phi);
    r13 = cos(psi) * sin(theta) * cos(phi) + sin(psi) * sin(phi);
    r21 = sin(psi) * cos(theta);
    r22 = sin(psi) * sin(theta) * sin(phi) + cos(psi) * cos(phi);
    r23 = sin(psi) * sin(theta) * cos(phi) - cos(psi) * sin(phi);
    r31 = -sin(theta);
    r32 = cos(theta) * sin(phi);
    r33 = cos(theta) * cos(phi);

    R = [r11 r12 r13; ...
         r21 r22 r23; ...
         r31 r32 r33];
end