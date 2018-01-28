function SF_quad_dynamics(block)

setup(block);
  
%endfunction

% Function: setup ===================================================

function setup(block)

  % Register the number of ports.
  block.NumInputPorts  = 4;
  block.NumOutputPorts = 12;
  
  % Override the input port properties.
  for i = 1:4 % These are the motor inputs
      block.InputPort(i).Dimensions        = 1;
      block.InputPort(i).DirectFeedthrough = false;
      block.InputPort(i).SamplingMode      = 'Sample';
      block.InputPort(i).Complexity  = 'Real';
      block.InputPort(1).DatatypeID  = 0; % double
      block.InputPort(1).Complexity  = 'Real';
  end
  
  
  % Override the output port properties.
  for i = 1:12
      block.OutputPort(i).Dimensions       = 1;
      block.OutputPort(i).SamplingMode     = 'Sample';
      block.OutputPort(1).DatatypeID  = 0; % double
      block.OutputPort(1).Complexity  = 'Real';
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
    phi = x0.phi;
    the = x0.the;
    psi = x0.psi;
    p = x0.p;
    q = x0.q;
    r = x0.r;
    
    x = x0.x;
    y = x0.y;
    z = x0.z;
    u = x0.u;
    v = x0.v;
    w = x0.w;
    
    init = [x y z u v w phi the psi p q r];
    
    for a = 1:12
        block.OutputPort(a).Data = init(a);
        block.ContStates.Data(a) = init(a);
    end
%endfunction



function Outputs(block)
    for i = 1:12
        block.OutputPort(i).Data = block.ContStates.Data(i);
    end
%endfunction



function Derivatives(block)

    % x y z in units of m
    x = block.ContStates.Data(1);
    y = block.ContStates.Data(2);
    z = block.ContStates.Data(3);
    % u v w in units of m/s
    u = block.ContStates.Data(4);
    v = block.ContStates.Data(5);
    w = block.ContStates.Data(6);
    % Phi the Psi in radians
    phi = block.ContStates.Data(7);
    the = block.ContStates.Data(8);
    psi = block.ContStates.Data(9);    
    % p q r in units of deg/sec
    p = block.ContStates.Data(10);
    q = block.ContStates.Data(11);
    r = block.ContStates.Data(12);


    
    % motor
    m1 = block.InputPort(1).Data;
    m2 = block.InputPort(2).Data;
    m3 = block.InputPort(3).Data;
    m4 = block.InputPort(4).Data;
    w  = [m1 m2 m3 m4];      % in rpm

    %% transformation matrx0es
    
    % rotational matrix -> Z-Y-X rotation    
    r11 = cosd(psi) * cosd(the);
    r12 = cosd(psi) * sind(the) * sind(phi) - sind(psi) * cosd(phi);
    r13 = cosd(psi) * sind(the) * cosd(phi) + sind(psi) * sind(phi);
    r21 = sind(psi) * cosd(the);
    r22 = sind(psi) * sind(the) * sind(phi) + cosd(psi) * cosd(phi);
    r23 = sind(psi) * sind(the) * cosd(phi) - cosd(psi) * sind(phi);
    r31 = -sind(the);
    r32 = cosd(the) * sind(phi);
    r33 = cosd(the) * cosd(phi);

    R = [r11 r12 r13; 
         r21 r22 r23; 
         r31 r32 r33];
    
    %inverted Wronskian
    iW = [1 sind(phi)*tand(the) cosd(phi)*tand(the);  %Rx
          0 cosd(phi)           -sind(phi);           %RY
          0 sind(phi)/cosd(the) cosd(phi)/cosd(the)]; %RZ   
    
    %% linear accel in inertial/world frame
    T = quad.ct * sum(motor.^2);
    
    a = quad.g * [0;0;1] + R * T/quad.mass;  
    
    V_bi = [u v w]';   % velocity of body frame in inertial frame
  
    %% angular accel in inertial/world frame
    o = [p q r]';
    
    % torque by motor
    tau = [quad.r*quad.ct*(w(1)^2 - w(3)^2 + w(2)^2 - w(4)^2); ...
           quad.r*quad.ct*(w(1)^2 - w(2)^2 + w(3)^2 - w(4)^2); ...
           quad.cq * (-w(1)^2 + w(3)^2 + w(2)^2 - w(4)^2)];

    tau = round(tau, 10); % to remove close to zero build up
    
    gyro = quad.Jr * [q;p;0] * [-w(1) + w(2) -w(3) + w(4)];
    
    do = inv(quad.J)*(cross(-o,quad.J*o) + tau - gyro);% omega dot - angular velocity of body frame in inertial frame
    
    omega_bi = iW * o; % angular velocity in interial frame
    
    %% assigning the derivatives (in inertial frame)
    dx = V_bw(1);   %linear  velocity
    dy = V_bw(2);
    dz = V_bw(3);    
    du = a(1);  %linear acceleration
    dv = a(2);
    dw = a(3);
 
    dphi = omega_bi(1); % angular vel
    dthe = omega_bi(2);
    dpsi = omega_bi(3);
    dp = do(3);         % angular accel
    dq = do(3);
    dr = do(3);
    
    % ground condition
    
    % state derivative vector
    f = [dx dy dz du dv dw dphi dthe dpsi dp dq dr]';
    
    block.Derviatives.Data = f;
%endfunction


