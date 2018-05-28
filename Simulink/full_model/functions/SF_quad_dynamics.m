function SF_quad_dynamics(block)

setup(block);
  
%endfunction

% Function: setup ===================================================

function setup(block)

  % Register the number of ports.
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 18;
  
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  
  % Override the input port properties.
  % input u
  block.InputPort(1).Dimensions        = 4;
  block.InputPort(1).DirectFeedthrough = false;
  block.InputPort(1).SamplingMode      = 'Sample';
  block.InputPort(1).Complexity  = 'Real';
  block.InputPort(1).DatatypeID  = 0; % double
  block.InputPort(1).Complexity  = 'Real';

  % input disturbance
  block.InputPort(2).Dimensions        = 6;
  block.InputPort(2).DirectFeedthrough = false;
  block.InputPort(2).SamplingMode      = 'Sample';
  block.InputPort(2).Complexity  = 'Real';
  block.InputPort(2).DatatypeID  = 0; % double
  block.InputPort(2).Complexity  = 'Real';
  
  
  % Override the output port properties.
   for a = 1:18
      block.OutputPort(a).Dimensions       = 1;
      block.OutputPort(a).SamplingMode     = 'Sample';
      block.OutputPort(a).DatatypeID  = 0; % double
      block.OutputPort(a).Complexity  = 'Real';
   end


  % Register the parameters.
  block.NumDialogPrms     = 1;
  %block.DialogPrmsTunable = {'Tunable','Nontunable','SimOnlyTunable'};
  
  % Set up the continuous states.
  block.NumContStates = 18;

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


  % 
  % Derivatives:
  %   Functionality    : Call to update the derivatives of the
  %                      continuous states during a simulation step.
  %   C-Mex counterpart: mdlDerivatives
  %
  block.RegBlockMethod('Derivatives', @Derivatives);
  


% -------------------------------------------------------------------
% The local functions below are provided to illustrate how you may implement
% the various block methods listed above.
% -------------------------------------------------------------------

function CheckPrms(block)
    quad = block.DialogPrm(1).Data;
 
  
%endfunction

    


function InitializeConditions(block)
    
    quad = block.DialogPrm(1).Data;
    % initial condition in deg ... convert to rad
    x = 0;
    dx = 0;
    y = 0;
    dy = 0;
    ddy = 0;
    y3 = 0;
    z = 1.5;
    dz = 0;
    ddz = 0;
    z3 = 0;
    phi =0;
    dphi = 0;
    the = pi/6;
    dthe = 0;
    psi = 0;
    dpsi = 0;
    u1 = quad.mass*quad.g/2;
    uj = 0.00000001;
    
    init = [x dx y dy ddy y3 z dz ddz z3 phi dphi the dthe psi dpsi u1 uj];

    
    for a = 1:18
        block.ContStates.Data(a) = init(a);
        block.OutputPort(a).Data = init(a);
    end
    
    
%endfunction



function Outputs(block)

    for i = 1:18
        block.OutputPort(i).Data = block.ContStates.Data(i); 
    end
    
    
%endfunction



function Derivatives(block)
    
    quad = block.DialogPrm(1).Data;

    % x y z in units of m
    x = block.ContStates.Data(1);
    dx = block.ContStates.Data(2);
    y = block.ContStates.Data(3);
    dy = block.ContStates.Data(4);
    ddy = block.ContStates.Data(5);
    y3 = block.ContStates.Data(6);
    z = block.ContStates.Data(7);
    dz = block.ContStates.Data(8);
    ddz = block.ContStates.Data(9);
    z3 = block.ContStates.Data(10);
    phi = block.ContStates.Data(11);
    dphi = block.ContStates.Data(12);
    the = block.ContStates.Data(13);
    dthe = block.ContStates.Data(14);
    psi = block.ContStates.Data(15);
    dpsi = block.ContStates.Data(16);
    u1 = block.ContStates.Data(17);
    uj = block.ContStates.Data(18);
    
    
    % assigning inputs
    u = block.InputPort(1).Data; 
    us = u(1);
    u2 = u(2);
    u3 = u(3);
    u4 = u(4);
    
    if u1 <= 0
        u1 = 1e-6;
    end
    
    d = block.InputPort(2).Data;
    fxd = d(1);    % disturbance: force x
    fyd = d(2);    % disturbance: force y
    fzd = d(3);    % disturbance: force z
    tau_rd = d(4); % disturbance: torque roll
    tau_pd = d(5); % disturbance: torque pitch
    tau_yd = d(6); % disturbance: torque yaw
    
    %% assigning the derivatives (in inertial frame)  
    % ---- for x theta psi 
    ddx = u1 * cos(phi) * sin(the) + fxd/quad.mass;
    ddy = ddy + fyd/quad.mass;
    ddz = ddz + fzd/quad.mass;
    
    ddthe = u3 + tau_pd;
    ddpsi = u4 + tau_yd;
    
    % ---- for y z phi
    du1 = uj;
    duj = us;
    
  
    
    ddphi = u2 + tau_rd;
    
    y4 = dphi^2 * sin(phi) * u1 - 2*dphi*cos(phi)*du1 -sin(phi)*us - cos(phi)*u1*u2;
    %z4 = -dphi^2 * cos(phi) * u1 - 2*dphi*sin(phi)*du1 + cos(phi)*us -l*sin(phi)*u1*u2;
	z4 = -2*du1*dthe*sin(the)*cos(phi) - 2*du1*dphi*cos(the)*sin(phi) ...
         +2*u1*dthe*dphi*sin(the)*sin(phi) - u1*(dthe^2+dphi^2)*cos(the)*cos(phi) ...
         +us*cos(the)*cos(phi) - u1*ddthe*sin(the)*cos(phi)-u1*ddphi*cos(the)*sin(phi);
    % ground condition
    
    % state derivative vector
    f = [dx ddx dy ddy y3 y4 dz ddz z3 z4 dphi ddphi dthe ddthe dpsi ddpsi du1 duj]';
    
    block.Derivatives.Data = f;
%endfunction


