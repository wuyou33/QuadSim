function SF_quad_dynamics(block)

setup(block);
  
%endfunction

% Function: setup ===================================================

function setup(block)

  % Register the number of ports.
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 8;
  
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  
  % Override the input port properties.
  % These are the motor inputs
  block.InputPort(1).Dimensions        = 2;
  block.InputPort(1).DirectFeedthrough = false;
  block.InputPort(1).SamplingMode      = 'Sample';
  block.InputPort(1).Complexity  = 'Real';
  block.InputPort(1).DatatypeID  = 0; % double
  block.InputPort(1).Complexity  = 'Real';

  block.InputPort(2).Dimensions        = 6;
  block.InputPort(2).DirectFeedthrough = false;
  block.InputPort(2).SamplingMode      = 'Sample';
  block.InputPort(2).Complexity  = 'Real';
  block.InputPort(2).DatatypeID  = 0; % double
  block.InputPort(2).Complexity  = 'Real';
  
  
  % Override the output port properties.
   for a = 1:8
      block.OutputPort(a).Dimensions       = 1;
      block.OutputPort(a).SamplingMode     = 'Sample';
      block.OutputPort(a).DatatypeID  = 0; % double
      block.OutputPort(a).Complexity  = 'Real';
   end


  % Register the parameters.
  block.NumDialogPrms     = 1;
  %block.DialogPrmsTunable = {'Tunable','Nontunable','SimOnlyTunable'};
  
  % Set up the continuous states.
  block.NumContStates = 8;

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
    
    x0 = block.InputPort(2).Data;
    quad = block.DialogPrm(1).Data;
    x0
    % initial condition in deg ... convert to rad
    y = x0(1);
    dy = x0(2);
    z = 1;%x0(3)
    dz = x0(4);
    phi = x0(5);
    dphi = x0(6);
    u1 = 0.001;
    uj = 0;
    
    init = [y dy z dz phi dphi u1 uj];

    
    for a = 1:8
        block.ContStates.Data(a) = init(a);
        block.OutputPort(a).Data = init(a);
    end
    
    
%endfunction



function Outputs(block)

    for i = 1:8
        block.OutputPort(i).Data = block.ContStates.Data(i); 
    end
    
    
%endfunction



function Derivatives(block)
    
    quad = block.DialogPrm(1).Data;

    % x y z in units of m
    y = block.ContStates.Data(1)
    dy = block.ContStates.Data(2)
    z = block.ContStates.Data(3)
    dz = block.ContStates.Data(4);
    phi = block.ContStates.Data(5)
    dphi = block.ContStates.Data(6);
    u1 = block.ContStates.Data(7);
    uj = block.ContStates.Data(8);
    
    %the extra states 
    
    % motor rotational speed
    u = block.InputPort(1).Data; % in RPM
    us = u(1);
    u2 = u(2);
    
    if u1 <= 0
        u1 = 0;
    end
      
    
    %% assigning the derivatives (in inertial frame)
    ddy = -u1*sin(phi);
    ddz = u1*cos(phi)-quad.g
	
    ddphi = u2*quad.r;
    
    du1 = uj;
    
    duj = us;
    % ground condition
    
    % state derivative vector
    f = [dy ddy dz ddz dphi ddphi du1 duj]';
    
    block.Derivatives.Data = f;
%endfunction


