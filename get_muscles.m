%
%  There are three muscle groups in this simulation.  At least
%  one muscle from each group must connect to each follicle.
%
%
%  a muscle structure contains 2 attachment points and a name
%  {'nl','na','int'}
%


function muscles = get_muscles( p, pts )

    % there are 3n + 1 muscles
    
    % create Nasolabialis/Maxillolabialis muscles - extrinsic retractor muscle
    for j = 1:p.num_whiskers
        muscles(j).name = 'nl';
        muscles(j).ptA  = access_points( pts, 'top', 1 ); % from wall
        muscles(j).ptB  = access_points( pts, 'top', j+1 ); % to follicle top
    end
    
    % create Nasalis muscles - extrinsic protractor muscle
    for j = 1:p.num_whiskers
        muscles(end+1).name = 'na';
        muscles(end).ptA  = access_points( pts, 'na', 1 ); % from wall
        muscles(end).ptB  = access_points( pts, 'cor', j );% to follicle center
    end
    
    % create intrinsic muscles
    muscles(end+1).name = 'int';
    muscles(end).ptA  = access_points( pts, 'int', 1 ); % from imaginary point
    muscles(end).ptB  = access_points( pts, 'int', 2 ); % to point along follicle
    
    for j = 1:p.num_whiskers
        muscles(end+1).name = 'int';
        muscles(end).ptA  = access_points( pts, 'top', j+1 ); % from top of follicle
        muscles(end).ptB  = access_points( pts, 'int', j+2 ); % to point along follicle
    end
    
    % set the rest length for each muscle
    for j = 1:length(muscles)
        muscles(j).rest_length = norm( pts( muscles(j).ptA ).pos - pts( muscles(j).ptB ).pos );
    end
        