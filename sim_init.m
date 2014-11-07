%
% this script runs a typical session of the biomechanial simulation.  
% first all the geometry and components are built, then an odesolver
% is used to integrated the differential equations.  finally, some
% output is displayed
%

%clear
%clc
global params springs follicles muscles h;

%
% load parameters
%

    sim_params;


    %
    % set up the model based on the rest state
    %
    rest_state  = get_rest_state( params );
    rest_points = get_geometry( params, rest_state );
    springs     = get_springs( params,  rest_points );
    follicles   = get_follicles( params, rest_points );
    muscles     = get_muscles( params, rest_points );


    %
    % run the differential equation solver
    %
    warning( 'off', 'MATLAB:divideByZero');
    h = waitbar(0,'Please wait...');
    sol = ode4( @sim_diff, params.t, params.init.state);
    close(h)

    
    
    

