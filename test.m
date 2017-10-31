clear all
close all
clc


folder = strcat(fileparts(which('test.m')), '\Qdynamics'); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));
folder = strcat(fileparts(which('test.m')), '\Controller'); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));

param_set


1+1


