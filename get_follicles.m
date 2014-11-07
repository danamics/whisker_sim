%
%  A follicle is just a list of points that will behave like a rod.
%  An actuator can connect to any of these points.  The center of
%  rotation for calculating torque and translational force are 
%  specifically mentioned.
%
%  A follicle struct contains a list of points and a 'center of rotation'
%
function follicles = get_follicles( p, pts )

    % for each whisker
    for j = 1:p.num_whiskers
        follicles(j).points = [];
        
        % for each point
        for k = 1:length(pts)
            
            % are we connected
            if pts(k).follicle == j
                follicles(j).points(end+1) = k;
                
                % is this also my center?
                if isequal( pts(k).type, 'cor' )
                    follicles(j).cor = k;
                end
            end
        end
    end
        