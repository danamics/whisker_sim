%
%  This function is called by an odesolver.  Given the current state
%  and the current time, this function outputs the derivative of the
%  current state.  It does this by identifying all the forces in the 
%  system (either springs or muscles) and determining the
%  translational and angular acceleration they produce.
%



function f = sim_diff( t, state )

    % i can't pass anything in, so these are global 
    global params springs follicles muscles h;
    
    % a status bar, updated approximately once every 100 timesteps
    if (rand < .01 )
        progress = (t - params.init.tspan(1)) / range(params.init.tspan);
        waitbar(progress,h)
    end   
      
    % get geometry of situation
    points      = get_geometry( params, state );

   
    % get spring forces
    index = 1;
    for j = 1:length(springs)
       [forces(index) forces(index+1)] = apply_spring( springs(j), points );
       index = index + 2;
    end
    
    % get muscle forces
    for j = 1:length(muscles)
       [forces(index) forces(index+1)] = apply_muscle( t, params, muscles(j), points );
       index = index + 2;
    end
   
    % sum all forces and torques
    f = zeros( size( state) );
    for j = 1:length(forces)
            
           w = points( forces(j).pt ).follicle;
           
           % a follicle number less than 1 is no follicle at all
           if w >0
               offset = (w-1)*4;

               % add in X-translation force
               f(offset+2) = f(offset+2) + (forces(j).vec(1)/(params.Mf+params.Mh));
               
               % torque is more difficult
               
               % determine tangent angle
               vec = points( forces(j).pt ).pos - points( follicles(w).cor ).pos;
               if  ~isequal( vec(:), [ 0 0 ]' )
                 a = atand( vec(2) / vec(1) ) - 90;  
               else % watch out for divide by zero errors
                 a = 0;
               end  
               % if position is in quadrant 2 or 3, add 180
               if (vec(1)<0), a = a + 180; end 
               
               % determine tangent force         
               %mag         = dot( forces(j).vec, [cosd(a) sind(a)] );
               mag          = forces(j).vec(1)*cosd(a) + forces(j).vec(2)*sind(a);
               
               % determine length of lever arm
               r           = norm( vec );
               
               % now we can calculate the torque in degrees
               f(offset+4) = f(offset+4) + ( ( mag * r / params.moment )*180/pi);
               
               
           end
    end
    
    % fill in 1st derivatives (eg. last time's velocity is this time's translational derivative)
    f(1:2:end) = state(2:2:end);
    
    
    