clear all
close all
clc


folder = strcat(fileparts(which('test.m')), '\Qdynamics'); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));

param_set


%% run
angle = 10;
R = [1 0 0;0 cosd(angle) -sind(angle);0 sind(angle) cosd(angle)];

figure
hold on
plot_quad(R,0,0,0)

hold off

view(90,0)
axis equal
grid on


