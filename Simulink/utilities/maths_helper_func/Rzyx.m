function R = Rzyx(angles)
    phi = angles(1);
    theta = angles(2);
    psi = angles(3);

    r11 = cosd(psi) * cosd(theta);
    r12 = cosd(psi) * sind(theta) * sind(phi) - sind(psi) * cosd(phi);
    r13 = cosd(psi) * sind(theta) * cosd(phi) + sind(psi) * sind(phi);
    r21 = sind(psi) * cosd(theta);
    r22 = sind(psi) * sind(theta) * sind(phi) + cosd(psi) * cosd(phi);
    r23 = sind(psi) * sind(theta) * cosd(phi) - cosd(psi) * sind(phi);
    r31 = -sind(theta);
    r32 = cosd(theta) * sind(phi);
    r33 = cosd(theta) * cosd(phi);

    R = [r11 r12 r13; ...
         r21 r22 r23; ...
         r31 r32 r33];
end