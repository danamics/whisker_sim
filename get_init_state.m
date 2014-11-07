% the state of each follicle is represented by 4 numbers
% [x position, x velocity, angle, angular velocity]
% 
% i'm assuming the initial velocities are always 0, so i just need
% to fill in these zeros for the initial state vectors in 
% the params.init structure.
%
% NOTE: the arguement is params.init, not params

function state = get_init_state( p )

    % create an empy state array
    num_whiskers = length(p.x);
    state = zeros( [4*num_whiskers 1] );
    
    for j = 1:num_whiskers
        offset = (j-1)*4; 
        state( offset + 1 ) = p.x(j);       % x translation
        state( offset + 2 ) = 0;            % x velocity
        state( offset + 3 ) = p.theta(j);   % init angle
        state( offset + 4 ) = 0;            % angular velocity
    end
