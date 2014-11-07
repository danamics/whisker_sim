
%
% All of the points marked "top" need to be connected in-line by springs. 
% the same is for the points marked "bottom".  This function should be
% passed a "points" array representing the rest state so that the "rest
% length" of the springs can be determined
%
% a spring contains two attachment points and 3 spring constants 
%(length, k ,b)
%

function springs = get_springs( p, pts )

   
    index = 1; 
    for j = 1:(1+p.num_whiskers) % there is a 'top' and 'bottom' spring for every whisker plus one 
        springs(index) = make_spring(p, pts, 'top', j );      % make a top spring
        springs(index+1) = make_spring(p, pts, 'bottom', j ); % make a bottom spring
        index = index + 2;
    end
        
    

function s = make_spring( p, pts, type, j );
   
    % use points object to get rest length
    s.ptA = access_points( pts, type, j );
    s.ptB = access_points( pts, type, j+1 );    
    s.rest_length = norm( pts(s.ptA).pos - pts(s.ptB).pos );
    
    % multiply rest length with b and k parameters
    s.k           = p.k / s.rest_length;
    s.b           = p.b / s.rest_length;
  