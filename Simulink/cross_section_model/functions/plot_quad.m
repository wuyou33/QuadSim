function plot_quad(state)
%% init parameters


% plot on figure 1


x = state(1);
y = state(2);
z = state(3);

prop = quad.prop_r;
normal = [0 0 0;0 0 1]; % normal pointing +z direction
theta=0:0.01:2*pi;

sr = qsize/50; % centre sphere radius;

%% frame 
fx = [-1 1 -1 1] * arm;
fy = [-1 1 1 -1] * arm;
fz = [0 0 0 0] * arm;

fx = [fx fx]; % adding motor
fy = [fy fy];
fz = [fz [1 1 1 1] * lmotor];

frame = R * [fx;fy;fz]; % rotate frame

% translate frame
fx = frame(1,:) + x;
fy = frame(2,:) + y;
fz = frame(3,:) + z;

% prop
c1 = [fx(5) fy(5) fz(5)];% prop centre
c2 = [fx(6) fy(6) fz(6)];
c3 = [fx(7) fy(7) fz(7)];
c4 = [fx(8) fy(8) fz(8)];

normal = R * normal';    % rotation on prop normal
v=null(normal');

p1 =repmat(c1',1,size(theta,2))+prop*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
p2 =repmat(c2',1,size(theta,2))+prop*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
p3 =repmat(c3',1,size(theta,2))+prop*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
p4 =repmat(c4',1,size(theta,2))+prop*(v(:,1)*cos(theta)+v(:,2)*sin(theta));

% centre sphere
[cx cy cz] = sphere;


%plot frame
    % arm
f1 = plot3([fx(1) fx(2)], [fy(1) fy(2)], [fz(1) fz(2)], ...
           [fx(3) fx(4)], [fy(3) fy(4)], [fz(3) fz(4)]);
    % motor
f2 = plot3([fx(1) fx(5)], [fy(1) fy(5)], [fz(1) fz(5)], ...
           [fx(2) fx(6)], [fy(2) fy(6)], [fz(2) fz(6)], ...
           [fx(3) fx(7)], [fy(3) fy(7)], [fz(3) fz(7)], ...
           [fx(4) fx(8)], [fy(4) fy(8)], [fz(4) fz(8)]);
  
    % prop
f3 = fill3(p1(1,:), p1(2,:), p1(3,:), 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'r', 'EdgeAlpha', 0.5, 'linewidth', 2);
f4 = fill3(p2(1,:), p2(2,:), p2(3,:), 'g', 'FaceAlpha', 0.2, 'EdgeColor', 'g', 'EdgeAlpha', 0.5, 'linewidth', 2);
f5 = fill3(p3(1,:), p3(2,:), p3(3,:), 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'r', 'EdgeAlpha', 0.5, 'linewidth', 2);
f6 = fill3(p4(1,:), p4(2,:), p4(3,:), 'g', 'FaceAlpha', 0.2, 'EdgeColor', 'g', 'EdgeAlpha', 0.5, 'linewidth', 2);

p1 =repmat(c1',1,size(theta,2))+prop/15*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
p2 =repmat(c2',1,size(theta,2))+prop/15*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
p3 =repmat(c3',1,size(theta,2))+prop/15*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
p4 =repmat(c4',1,size(theta,2))+prop/15*(v(:,1)*cos(theta)+v(:,2)*sin(theta));

f7 = fill3(p1(1,:), p1(2,:), p1(3,:), 'r', 'FaceAlpha', 0.7, 'EdgeColor', 'r', 'EdgeAlpha', 0.7, 'linewidth', 2);
f8 = fill3(p2(1,:), p2(2,:), p2(3,:), 'g', 'FaceAlpha', 0.7, 'EdgeColor', 'g', 'EdgeAlpha', 0.7, 'linewidth', 2);
f9 = fill3(p3(1,:), p3(2,:), p3(3,:), 'r', 'FaceAlpha', 0.7, 'EdgeColor', 'r', 'EdgeAlpha', 0.7, 'linewidth', 2);
f10 = fill3(p4(1,:), p4(2,:), p4(3,:), 'g', 'FaceAlpha', 0.7, 'EdgeColor', 'g', 'EdgeAlpha', 0.7, 'linewidth', 2);

    % centre sphere;
surf(cx*sr + x, cy*sr + y, cz*sr + z, 'EdgeColor', 'none', 'EdgeAlpha', 0.5, 'FaceColor', 'k', 'FaceAlpha', 0.5); 
%% plot settings

set(f1, 'color', 'k');
set(f2, 'color', 'k');

set(f1, 'linewidth', 2);
set(f2, 'linewidth', 2);

end