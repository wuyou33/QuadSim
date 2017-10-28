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

%% Simulation setup 

global dt 

dt = 0.028; % second