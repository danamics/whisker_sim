%
% PARAMETERS FOR BIOMECHANICAL SIMULATOR
%

%
% geometric paramters
%
params.whisker_sep      = 2;   % mm - separation of follicle centers
params.pad_length       = 20;    % mm - total end to end length of pad
params.follicle_length  = 4;   % mm - length of the rod
params.whisker_length   = 40;    % mm - length of whisker
params.int_attach       = -2.9;     % mm - location of intrinsic attachment point (relative to top of follicle)
params.rest_angle       =  70;   % degrees - angle of whisker at rest (relative to -x axis)
params.num_whiskers     = 3;     % number of follicles/whiskers
params.Mf               = 10;    % mg - mass of follicle
params.Mh               = .5;    % mg - mass of hair
[params.moment, params.com] = get_moment_of_inertia( params.follicle_length,params.whisker_length, params.Mf, params.Mh );

tau = 0.027; % time constant of mystacial pad in ms   
r = 2;       % damping ratio
%
% WARNING: the stability of the ODE integrator depends on the parameters tau and r.  
%   The timestep, dt, should be set to ensure stability. 
%
w  = 1/ ( (r - sqrt((r^2)-1))*tau);
b   = 2*r*w;
k   = w^2;


Mtotal = params.num_whiskers * (params.Mf + params.Mh);

params.b                = (params.pad_length/2) * Mtotal * b;
params.k                = (params.pad_length/2) * Mtotal * k;   % mg / S^2

clear tau rat beta omega2 Mtotal;

params.t = linspace(0,.1,1001);
params.int   = zeros( size( params.t ) );
params.na   = zeros(size ( params.t ) );
params.nl   = zeros( size( params.t )  );

% upsample the muscle signals
dt = .00001;
newt = params.t(1):dt:params.t(end);
params.int = spline( params.t, params.int, newt );
params.na = spline(  params.t, params.na, newt );
params.nl = spline(  params.t, params.nl, newt );
params.t = newt;
clear newt dt;

% initial conditions for simulation
state          = zeros( [1 4*params.num_whiskers] );
state(1:4:end) = [params.whisker_sep * ([1:params.num_whiskers] - (( params.num_whiskers + 1) /2)) ];
state(3:4:end) = params.rest_angle;

params.init.state = state;
params.init.tspan       = params.t([1 end]);



