%
%  determine the location and velocity of all important POINTS of the 
%  system using the state vector and the parameters
%
%  POINT DATA TYPE
%            pos  - [x,y] position
%            vel  - [x,y] position
%            type - 'top', 'bottom', 'cor' (center of rotation)

%  POINT TYPES
%    'top'      wall and follicle attachment points running along the skin
%    'bottom'   wall and follicle attachment points running along the plate
%    'cor'      location to calculate center of rotation for torques
%                   NOTE:  cor is always on x-axis
%    'int'      an intrinsic muscle attachment point
%    'na'       the nasalis attachment point on the wall

function pts = get_geometry( p, s )

    persistent points; % for memory efficiency, don't allocate points every time
    
    sr       =sind( p.rest_angle );
    cr       =cosd( p.rest_angle );
    
    st       =sind( s(3:4:end) );
    ct       =cosd( s(3:4:end) );
    
    pl       = p.follicle_length;
    com      = p.com;
    wdy_top  = sr * (pl-com);
    wdy_bot  = -sr * com;
    
    wdx  = p.pad_length / 2;
    n    = p.num_whiskers;
    i    = 1;
    
    
    %
    % TOP POINTS (connected by springs, includes walls and follicle tops)
    %
    
    %   1st = wall
    points(i).pos   = [-wdx wdy_top];  % 1st top wall point by definition
    points(i).vel     = [0 0];       % walls don't move
    points(i).type    = 'top';           
    points(i).follicle= -1;
    
    %   2nd through end-1 = follicle tops
    for j = 1:n
       i = i + 1;
       [x, v, theta, w ]    =  get_nth_state( s,j );                       % get current state
       points(i).pos(1)     =  x - ct(j)*(pl-com);                 % x + x-componenet due to angle
       points(i).pos(2)     =  st(j)*(pl-com);                     % y-component due to angle
       points(i).vel(1)     =  v + ((w*pi/180)*(pl-com)) * st(j);    % v + x-component of angular velocity
       points(i).vel(2)     =  ((w*pi/180)*(pl-com) ) * ct(j);        % y-component of angular velocity
       points(i).type       = 'top';
       points(i).follicle   = j;
    end

    %   end = wall
    i = i + 1;
    points(i).pos      = [wdx wdy_top];   % 2nd top wall point by definition
    points(i).vel      = [0 0];       % walls don't move
    points(i).type     = 'top';           
    points(i).follicle = -1;           
    
    %
    % BOTTOM POINTS (connected by springs, includes walls and follicle bottoms)
    %
    %   1st = wall
    i = i  + 1;
    points(i).pos   = [-wdx wdy_bot]; % 1st bottom wall point by definition
    points(i).vel     = [0 0];       % walls don't move
    points(i).type    = 'bottom';           
    points(i).follicle = -1;           
    
    
    %   2nd through end-1 = follicle bottoms
    for j = 1:n
       i = i + 1;
       [x, v, theta, w ]    =  get_nth_state( s, j );
       points(i).pos(1) =  x + ct(j)*com;
       points(i).pos(2)   =  -st(j)*com;
       points(i).vel(1)   =  v + ((w*pi/180)*com) * -st(j);
       points(i).vel(2)   =  ((w*pi/180)*com) * -ct(j);
       points(i).type     =  'bottom';
       points(i).follicle =  j;           
    end
    
    %   end = wall
    i = i + 1;
    points(i).pos       = [wdx wdy_bot];   % 2nd top wall point by definition
    points(i).vel       = [0 0];       % walls don't move
    points(i).type      = 'bottom';           
    points(i).follicle  = -1;           
    
    %
    % CENTERS OF ROTATION
    %
    for j = 1:n
        i = i + 1;
        [x, v]                =  get_nth_state( s, j );
        points(i).pos         = [x 0];   
        points(i).vel         = [v 0];      
        points(i).type        = 'cor';
        points(i).follicle    = j;
    end
    
    %
    % INTRINSIC MUSCLE ATTACHMENT POINTS 
    
    %
    % 1st = embedded point on "top spring" when at rest and twice as far 
    % over as a normal attachment point
    i = i + 1;
    x                        = p.whisker_sep * -(p.num_whiskers + 3 ) / 2;  
    points(i).pos(1)         = x - 1.5*cr*(pl-com);
    points(i).pos(2)         = wdy_top;
    points(i).type           = 'int';
    points(i).follicle       = -1;
    
    % (dynamic) point on each follicle, as far away from the center of rotation
    % as specified by p.int_attach
    int_pos = p.int_attach + pl - com;
    for j = 1:n
        i = i + 1;
        [x, v, theta, w ]        =  get_nth_state( s, j );
        points(i).pos(1)         = x - ct(j)*int_pos;
        points(i).pos(2)         = st(j)*int_pos;
        points(i).type           = 'int';
        points(i).follicle       = j;
    end
    
    % last = embedded point is located as imaginary point on 
    % an additional whisker, but twice as far over
    i = i + 1;
    x                        = p.whisker_sep * (p.num_whiskers + 3 ) / 2;
    points(i).pos(1)         = x - 1.5*cr*int_pos;
    points(i).pos(2)         = sr*int_pos;
    points(i).type           = 'int';
    points(i).follicle       = -1;
        
    
    %
    % ADD NASALIS ATTACHMENT POINT on the wall
    %
    i = i + 1;
    points(i).pos         = [wdx 0];
    points(i).type       = 'na';
    points(i). follicle  =  -1;
    
    
    % ensure consistency when using persistant variable
    pts = points(1:i);
   
    
% extract desired state from s
function [x,v,theta,w] = get_nth_state( s, n )
       offset = (n-1)*4;
       x  = s( offset + 1 );            
       v = s( offset + 2 );
       theta = s( offset + 3 );         
       w = s( offset + 4 );
 