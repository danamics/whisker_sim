%
% The rest state is defined as all of the whiskers at the rest angle
% with a separation of whisker_sep and the central whisker at x = 0;
% This state is used to define much of the geometry.
%
function s = get_rest_state( p )

    % init to empty state
    s = [];

    % calculate offsets for x-translation
    seps  = (p.num_whiskers - 1 ) / 2;    % center group of follicle at x = 0
    x_loc = p.whisker_sep * [-seps:seps]; % but keep the correct spacing
    
    % for each whisker, set the 4 components of the state vector
    for j = 1:p.num_whiskers
        s(end+1) = x_loc(j);    % rest translation
        s(end+1) = 0;           % rest state is not dynamic
        s(end+1) = p.rest_angle;% rest angle is defined 
        s(end+1) = 0;           % rest state is not dynamic
    end
    
    s = s';
    