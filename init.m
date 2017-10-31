folder = strcat(fileparts(which('Qsim.m')), '\Qdynamics'); 
addpath(genpath(folder));
folder = strcat(fileparts(which('Qsim.m')), '\Controller'); 
addpath(genpath(folder));

param_set


