% ==== PARAMETER SET ====

%% world physics ----------------------------------------------------------- 
global g

g = -9.81; % m/s^2 in the z axis (downward)



%% quadcopter properties ---------------------------------------------------
%       
% quadcopter layout
%       front
%         ^
%     4   |   2
%         |
%         +----->    
%          
%     3       1
%
%       z (out of page)

global qsize
global prop
global arm
global lmotor
global kmotor
global Iq
global Im
global Ixx
global Iyy
global Izz
global b_drag
global qmass 

qsize = 500; % quadcopter size (mm)
prop = 12; % inch prop
qmass = 2.4; %kg

qsize = 500/1000; % to m

arm = qsize/2;
lmotor = arm/7;

kmotor = 0.05; % motor k constant

Ixx = 0.002;
Iyy = 0.002;
Izz = 0.004;

% quad inertia matrix
Iq = [Ixx 0 0;0 Iyy 0;0 0 Izz];   %Ixx Iyy Izz
Im = 0.00004; % moment of inertia for rotor

b_drag = 0.1; % drag constant

%% Quad PID
% rate
global rate_p_kp % pitch
global rate_p_ki
global rate_p_kd

global rate_r_kp % roll
global rate_r_ki
global rate_r_kd

global rate_y_kp % yaw
global rate_y_ki
global rate_y_kd

% angle
global angle_p_kp % pitch
global angle_r_kp % roll
global angle_y_kp % yaw

% altitude
global alt_kp
global alt_ki
global alt_kd

rate_r_kp = 0.01;
rate_r_ki = 0;
rate_r_kd = 0;

angle_p_kp = 1; % pitch
angle_r_kp = 1; % roll
angle_y_kp = 1; % yaw

%% Simulation setup 

global dt 

dt = 0.01; % second