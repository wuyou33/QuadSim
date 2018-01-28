function SF_plot_sim(block)

setup(block);
  
%endfunction

% Function: setup ===================================================

function setup(block)

  % Register the number of ports.
  block.NumInputPorts  = 6;
  block.NumOutputPorts = 0;
  
  % Override the input port properties.
  for i = 1:6 % These are the motor inputs
      block.InputPort(i).Dimensions        = 1;
      block.InputPort(i).DirectFeedthrough = true;
      block.InputPort(i).SamplingMode      = 'Sample';
      block.InputPort(i).Complexity  = 'Real';
      block.InputPort(1).DatatypeID  = 0; % double
      block.InputPort(1).Complexity  = 'Real';
  end
  
  

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
    a = block.DialogPrm(1).Data;
    
 
  
%endfunction

    


function InitializeConditions(block)
    
    figure;
%endfunction



function Outputs(block)

    a = block.DialogPrm(1).Data;
    plot(a,1, 'or');
    xlim([-5,5]);
    ylim([-5,5]);
    
%endfunction




