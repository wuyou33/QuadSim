function SF_quad_dynamics(block)

setup(block);
  
%endfunction

% Function: setup ===================================================

function setup(block)

  % Register the number of ports.
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 12;
  
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  
  % Override the input port properties.
  % These are the motor inputs
  block.InputPort(1).Dimensions        = 4;
  block.InputPort(1).DirectFeedthrough = false;
  block.InputPort(1).SamplingMode      = 'Sample';
  block.InputPort(1).Complexity  = 'Real';
  block.InputPort(1).DatatypeID  = 0; % double
  block.InputPort(1).Complexity  = 'Real';

  block.InputPort(2).Dimensions        = 3;
  block.InputPort(2).DirectFeedthrough = false;
  block.InputPort(2).SamplingMode      = 'Sample';
  block.InputPort(2).Complexity  = 'Real';
  block.InputPort(2).DatatypeID  = 0; % double
  block.InputPort(2).Complexity  = 'Real';

  % Override the output port properties.
   for a = 1:12
      block.OutputPort(a).Dimensions       = 1;
      block.OutputPort(a).SamplingMode     = 'Sample';
      block.OutputPort(a).DatatypeID  = 0; % double
      block.OutputPort(a).Complexity  = 'Real';
   end


  % Register the parameters.
  block.NumDialogPrms     = 2;
  %block.DialogPrmsTunable = {'Tunable','Nontunable','SimOnlyTunable'};
  
  % Set up the continuous states.
  block.NumContStates = 12;

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
    x0   = block.DialogPrm(2).Data;
 
  
%endfunction

    


function InitializeConditions(block)
    
    x0 = block.DialogPrm(2).Data;
    
    
    % initial condition in deg ... convert to rad
    phi = 0;
    the = 0;
    psi = 0;
    p = x0.p;
    q = x0.q;
    r = x0.r;
    
    X = 0;
    Y = 0.3;
    Z = 1;
    u = x0.u;
    v = x0.v;
    w = x0.w;
    
    init = [X Y Z u v w phi the psi p q r];

    
    for a = 1:12
        block.ContStates.Data(a) = init(a);
        block.OutputPort(a).Data = init(a);
    end
    
    
%endfunction



function Outputs(block)

    for i = 1:12
        block.OutputPort(i).Data = block.ContStates.Data(i); 
    end
    
    
%endfunction



function Derivatives(block)
    
    quad = block.DialogPrm(1).Data;

    % x y z in units of m
    X = block.ContStates.Data(1);
    Y = block.ContStates.Data(2);
    Z = block.ContStates.Data(3);
    % u v w in units of m/s
    dX = block.ContStates.Data(4);
    dY = block.ContStates.Data(5);
    dZ = block.ContStates.Data(6);
    % Phi the Psi in radians
    phi = block.ContStates.Data(7)
    the = block.ContStates.Data(8);
    psi = block.ContStates.Data(9);    
    % p q r in units of deg/sec
    p = block.ContStates.Data(10);
    q = block.ContStates.Data(11);
    r = block.ContStates.Data(12);


    
    % motor rotational speed
    w = block.InputPort(1).Data; % in RPM
    tau_d = block.InputPort(2).Data
    
    

    %% transformation matrx0es
    
    % rotational matrix -> Z-Y-X rotation    
    R = Rzyx([phi the psi]);
    
    %inverted Wronskian
    iW = [1 sin(phi)*tan(the) cos(phi)*tan(the);  %Rx
          0 cos(phi)           -sin(phi);           %RY
          0 sin(phi)/cos(the) cos(phi)/cos(the)]; %RZ   
    
    %% linear accel in inertial/world frame
    T = quad.ct *quad.A * quad.rho* sum(w.^2);
    
    a = -quad.g * [0;0;1] + R * [0;0;1] * T/quad.mass;  
    
    V_bi = [dX dY dZ]';   % velocity of body frame in inertial frame
  
    %% angular accel in inertial/world frame
    o = [p q r]';
    
    % torque by motor
    tau = [quad.r*quad.ct* quad.A * quad.rho*(-w(1)^2 - w(2)^2 + w(3)^2 + w(4)^2); ...
           quad.r*quad.ct* quad.A * quad.rho*(-w(1)^2 + w(2)^2 - w(3)^2 + w(4)^2); ...
           quad.cq * quad.A * quad.rho *(-w(1)^2 + w(3)^2 + w(2)^2 - w(4)^2)]
 

    tau = round(tau, 10); % to remove close to zero build up
    
    gyro = quad.Jr * [q;p;0] * [-w(1) + w(2) -w(3) + w(4)];
    
    do = inv(quad.J)*(cross(-o,quad.J*o) + tau + tau_d);% - gyro);% omega dot - angular velocity of body frame in inertial frame
    
    omega_bi = iW * o; % angular velocity in interial frame
    
    %% assigning the derivatives (in inertial frame)
    dX = V_bi(1);   %linear  velocity
    dY = V_bi(2);
    dZ = V_bi(3);    
    du = a(1);  %linear acceleration
    dv = a(2);
    dw = a(3);
 
    dphi = omega_bi(1); % angular vel
    dthe = omega_bi(2);
    dpsi = omega_bi(3);
    dp = do(1);         % angular accel
    dq = do(2);
    dr = do(3);
    
    % ground condition
    
    % state derivative vector
    f = [dX dY dZ du dv dw dphi dthe dpsi dp dq dr]';
    
    block.Derivatives.Data = f;
%endfunction


