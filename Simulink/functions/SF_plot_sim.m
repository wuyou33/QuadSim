function SF_plot_sim(block)

setup(block);
  
%endfunction

% Function: setup ===================================================

function setup(block)

  % Register the number of ports.
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 0;
  
  % Override the input port properties.

  block.InputPort(1).Dimensions        = -1;
  block.InputPort(1).DirectFeedthrough = true;
  block.InputPort(1).SamplingMode      = 'Sample';
  block.InputPort(1).Complexity  = 'Real';
  block.InputPort(1).DatatypeID  = 0; % double
  block.InputPort(1).Complexity  = 'Real';

  
  

  % Register the parameters.
  block.NumDialogPrms     = 1;
  %block.DialogPrmsTunable = {'Tunable','Nontunable','SimOnlyTunable'};
  
  % Set up the continuous states.
  block.NumContStates = 0;

  % Register the sample times.
  %  [0 offset]            : Continuous sample time
  %  [positive_num offset] : Discrete sample time
  %
  %  [-1, 0]               : Inherited sample time
  %  [-2, 0]               : Variable sample time
  block.SampleTimes = [0 0];
  
  % -----------------------------------------------------------------
  % Options
  % -----------------------------------------------------------------
  % Specify if Accelerator should use TLC or call back to the 
  % MATLAB file
  block.SetAccelRunOnTLC(false);
  
  % Specify the block simStateCompliance. The allowed values are:
  %    'UnknownSimState', < The default setting; warn and assume DefaultSimState
  %    'DefaultSimState', < Same SimState as a built-in block
  %    'HasNoSimState',   < No SimState
  %    'CustomSimState',  < Has GetSimState and SetSimState methods
  %    'DisallowSimState' < Errors out when saving or restoring the SimState
  block.SimStateCompliance = 'DefaultSimState';
  
  % -----------------------------------------------------------------
  % The MATLAB S-function uses an internal registry for all
  % block methods. You should register all relevant methods
  % (optional and required) as illustrated below. You may choose
  % any suitable name for the methods and implement these methods
  % as local functions within the same file.
  % -----------------------------------------------------------------
   
  % -----------------------------------------------------------------
  % Register the methods called during update diagram/compilation.
  % -----------------------------------------------------------------
  
  % 
  % CheckParameters:
  %   Functionality    : Called in order to allow validation of the
  %                      block dialog parameters. You are 
  %                      responsible for calling this method
  %                      explx0itly at the start of the setup method.
  %   C-Mex counterpart: mdlCheckParameters
  %
   block.RegBlockMethod('CheckParameters', @CheckPrms);


 
%   % -----------------------------------------------------------------
%   % Register methods called at run-time
%   % -----------------------------------------------------------------


  % InitializeConditions:
  %   Functionality    : Call to initialize the state and the work
  %                      area values.
  %   C-Mex counterpart: mdlInitializeConditions
  % 
  block.RegBlockMethod('InitializeConditions', @InitializeConditions);
  

  % 
  % Outputs:
  %   Functionality    : Call to generate the block outputs during a
  %                      simulation step.
  %   C-Mex counterpart: mdlOutputs
  %
  block.RegBlockMethod('Outputs', @Outputs);





% -------------------------------------------------------------------
% The local functions below are provided to illustrate how you may implement
% the various block methods listed above.
% -------------------------------------------------------------------

function CheckPrms(block)
    quad = block.DialogPrm(1).Data;

 
  
%endfunction

    


function InitializeConditions(block)
    close all;
    figure;
%endfunction



function Outputs(block)
    clf;


%% variable assignments
    quad = block.DialogPrm(1).Data;
    state = block.InputPort(1).Data;
    
    X = state(1);
    Y = state(2);
    Z = state(3);
    phi = state(4);
    the = state(5);
    psi = state(6);
    
%% frame calc
    prop = quad.prop_r;
    
    normal = [0 0 0;0 0 1]; % normal pointing +z direction
    theta=0:0.01:2*pi;

    sr = quad.r/10; % centre sphere radius;
    
    fx = [-1 1 -1 1] * quad.r;
    fy = [-1 1 1 -1] * quad.r;
    fz = [0 0 0 0] * quad.r;

    fx = [fx fx]; % adding motor
    fy = [fy fy];
    fz = [fz [1 1 1 1] * quad.motor_h];
    
    R = Rzyx([phi the psi]);
    frame = R * [fx;fy;fz]; % rotate frame

    % translate frame
    fx = frame(1,:) + X;
    fy = frame(2,:) + Y;
    fz = frame(3,:) + Z;

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

hold on;
    %% plot quad
    % arm
    plot3([fx(1) fx(2)], [fy(1) fy(2)], [fz(1) fz(2)], ...
               [fx(3) fx(4)], [fy(3) fy(4)], [fz(3) fz(4)],'color', 'k', 'linewidth', 2);
        % motor
    plot3([fx(1) fx(5)], [fy(1) fy(5)], [fz(1) fz(5)], ...
               [fx(2) fx(6)], [fy(2) fy(6)], [fz(2) fz(6)], ...
               [fx(3) fx(7)], [fy(3) fy(7)], [fz(3) fz(7)], ...
               [fx(4) fx(8)], [fy(4) fy(8)], [fz(4) fz(8)],'color', 'k', 'linewidth', 2);

        % prop
    fill3(p1(1,:), p1(2,:), p1(3,:), 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'r', 'EdgeAlpha', 0.5, 'linewidth', 2);
    fill3(p2(1,:), p2(2,:), p2(3,:), 'g', 'FaceAlpha', 0.2, 'EdgeColor', 'g', 'EdgeAlpha', 0.5, 'linewidth', 2);
    fill3(p3(1,:), p3(2,:), p3(3,:), 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'r', 'EdgeAlpha', 0.5, 'linewidth', 2);
    fill3(p4(1,:), p4(2,:), p4(3,:), 'g', 'FaceAlpha', 0.2, 'EdgeColor', 'g', 'EdgeAlpha', 0.5, 'linewidth', 2);

    p1 =repmat(c1',1,size(theta,2))+prop/15*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
    p2 =repmat(c2',1,size(theta,2))+prop/15*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
    p3 =repmat(c3',1,size(theta,2))+prop/15*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
    p4 =repmat(c4',1,size(theta,2))+prop/15*(v(:,1)*cos(theta)+v(:,2)*sin(theta));

    fill3(p1(1,:), p1(2,:), p1(3,:), 'r', 'FaceAlpha', 0.7, 'EdgeColor', 'r', 'EdgeAlpha', 0.7, 'linewidth', 2);
    fill3(p2(1,:), p2(2,:), p2(3,:), 'g', 'FaceAlpha', 0.7, 'EdgeColor', 'g', 'EdgeAlpha', 0.7, 'linewidth', 2);
    fill3(p3(1,:), p3(2,:), p3(3,:), 'r', 'FaceAlpha', 0.7, 'EdgeColor', 'r', 'EdgeAlpha', 0.7, 'linewidth', 2);
    fill3(p4(1,:), p4(2,:), p4(3,:), 'g', 'FaceAlpha', 0.7, 'EdgeColor', 'g', 'EdgeAlpha', 0.7, 'linewidth', 2);

        % centre sphere;
    surf(cx*sr + X, cy*sr + Y, cz*sr + Z, 'EdgeColor', 'none', 'EdgeAlpha', 0.5, 'FaceColor', 'k', 'FaceAlpha', 0.5); 


%% plot environment
    tunnel_r = 1500;
    tunnel_l = 6000; % tunnel length;
    
    surfT_x = [0 tunnel_l tunnel_l 0];
    surfT_y = [-tunnel_r -tunnel_r tunnel_r tunnel_r];
    surfT_z = [2*tunnel_r 2*tunnel_r 2*tunnel_r 2*tunnel_r];

    surfB_x = [0 tunnel_l tunnel_l 0];
    surfB_y = [-tunnel_r -tunnel_r tunnel_r tunnel_r];
    surfB_z = [0 0 0 0];

    surfL_x = [0 tunnel_l tunnel_l 0];
    surfL_y = [-tunnel_r -tunnel_r -tunnel_r -tunnel_r];
    surfL_z = [2*tunnel_r 2*tunnel_r 0 0];

    surfR_x = [0 tunnel_l tunnel_l 0];
    surfR_y = [tunnel_r tunnel_r tunnel_r tunnel_r];
    surfR_z = [2*tunnel_r 2*tunnel_r 0 0];

    fill3(surfT_x,surfT_y,surfT_z,'k', 'linewidth', 2, 'FaceAlpha', 0.2)
    fill3(surfB_x,surfB_y,surfB_z,'k', 'linewidth', 2, 'FaceAlpha', 0.2)
    fill3(surfL_x,surfL_y,surfL_z,'k', 'linewidth', 2, 'FaceAlpha', 0.2)
    fill3(surfR_x,surfR_y,surfR_z,'k', 'linewidth', 2, 'FaceAlpha', 0.2)
    
    
% plot visulisation settings
xlim([-tunnel_l/10 tunnel_l])
ylim([-tunnel_r-tunnel_r/10 tunnel_r+tunnel_r/10]);
zlim([0 2*tunnel_r+tunnel_r/10]);
grid on;
view([-90 0]);
axis equal;

hold off;

%endfunction




