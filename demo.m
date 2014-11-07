%
% DEMO of biomech_sim
%  Dan Hill 
%  12/05/2007
%

% declare global variables
global params springs follicles muscles h;

% 1st lets apply a passive deflection

% load the default parameters 
sim_params

% set the initial angle of the vibrissae forward by 30 degrees
params.init.state(3:4:end) = params.rest_angle + 30;

% run the model
    rest_state  = get_rest_state( params );
    rest_points = get_geometry( params, rest_state );
    springs     = get_springs( params,  rest_points );
    follicles   = get_follicles( params, rest_points );
    muscles     = get_muscles( params, rest_points );
    warning( 'off', 'MATLAB:divideByZero');
    h = waitbar(0,'Please wait...');
    sol = ode4( @sim_diff, params.t, params.init.state);
    close(h)

% plot results for central whisker
my_angle = sol(7,:); % angle of vibrissa for central whisker
my_com   = sol(5,:); % motion of center of mass of cenral whisker

% In the manuscript, translation of the pad is defined as the translation 
% of a point along the vibrissa at the level of the skin (see equation 30)
my_pad   =  my_com  + (params.follicle_length - params.com)./tand(pi-my_angle);

figure(1)
subplot(2,1,1)
plot( params.t, my_angle)
set(gca,'YLim', [45 135]);
xlabel('Time (S)')
ylabel( 'Angle (degrees)' )
title( 'Relaxation from passive deflection of 30 degrees');
subplot(2,1,2)
plot( params.t, my_pad)
set(gca,'YLim', [ -2 2] );
xlabel('Time (S)')
ylabel( 'Pad movement (mm)' )


%%%%%%%%%%
%%%%%%%%%%
%%%%%%%%%%

% 2nd lets input a sinusoid into each muscle

% make sure the globals are still defined
global params springs follicles muscles h;

% load the default parameters 
sim_params

% change the time parameters to a 500 ms run
params.t                = 0:.00001:.5; 
params.init.tspan       = [0 .5];

% each muscle receives a 10 Hz sinewave with a different gain and phase
params.int   = (1+sin( params.t*2*pi*10 + 0.00*pi)) * 8 * 10^5 ;   % intrinsic muscles
params.na   =  (1+sin( params.t*2*pi*10 - 0.82*pi)) * 8 * 10^5 ;   % m. nasalis
params.nl   =  (1+sin( params.t*2*pi*10 + 0.71*pi)) * 4 * 10^5;    % m. nasolabialis & m. maxillolabialis

% run the model
rest_state  = get_rest_state( params );
rest_points = get_geometry( params, rest_state );
springs     = get_springs( params,  rest_points );
follicles   = get_follicles( params, rest_points );
muscles     = get_muscles( params, rest_points );
warning( 'off', 'MATLAB:divideByZero');
h = waitbar(0,'Please wait...');
sol = ode4( @sim_diff, params.t, params.init.state);
close(h)

% plot results for central whisker
my_angle = sol(7,:); % angle of vibrissa
my_com   = sol(5,:); % motion of center of mass

% In the manuscript, translation of the pad is defined as the translation 
% of a point along the vibrissa at the level of the skin (see equation 30)
my_pad   =  my_com  + (params.follicle_length - params.com)./tand(pi-my_angle);

figure(2)
subplot(3,1,1)
plot(params.t,params.int,params.t,params.na,params.t,params.nl)
xlabel('Time (S)')
ylabel('Amplitude')
title('Muscle inputs - blue = INT, green = NA, red = RET')

subplot(3,1,2)
plot( params.t, my_angle)
set(gca,'YLim', [45 135]);
xlabel('Time (S)')
ylabel( 'Angle (degrees)' )
title( '10 Hz muscle input deflection');

subplot(3,1,3)
plot( params.t, my_pad)
set(gca,'YLim', [ -2 2] );
xlabel('Time (S)')
ylabel( 'Pad movement (mm)' )
