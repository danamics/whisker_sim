%
%
% The force generated by a muscle has a magnitude determined by a 
% parameter vector and a direction determined by the current geometry.
%
%  The force generated is equal and opposite on its two ends.
%
%  A force struct acts on a point (pt) with force (vec)
%


function [forceA forceB] = apply_muscle( t, p, muscle, points )

    % lets get arrow at A pointing toward B
    direction       = ( points(muscle.ptB).pos - points(muscle.ptA).pos );
        
    % use spline to get magnitude for our current simulation time
    signal          = getfield( p, muscle.name );
    index           = round(  (t-p.t(1)) / diff(p.t([1 2]) ) )+1;
    mag             = signal(index);

    % apply length-based nonlinearity  
    muscle_length =  norm( points(muscle.ptB).pos - points(muscle.ptA).pos );
    factor        =  muscle_length / muscle.rest_length;
    if      factor < .5
                mag = 0;
    elseif  factor < .75
                mag = mag * ( factor - .5)*4;
    elseif  factor < 1.25
                mag = mag;
    elseif  factor < 1.5
                mag = mag * (1.5 - factor) * 4;
    else
                mag = 0;
    end

%     if      factor < .7
%                 mag = 0;
%     elseif  factor < .85
%                 mag = mag * ( factor - .7)/.15;
%     elseif  factor < 1.15
%                 mag = mag;
%     elseif  factor < 1.3
%                 mag = mag * (1.3 - factor)/.15;
%     else
%                 mag = 0;
%     end
    
    
    
    % determine output forces
    forceA.vec      = mag*direction / norm( direction );
    forceA.pt       = muscle.ptA;
    forceB.vec      = -forceA.vec;
    forceB.pt       = muscle.ptB;
   
    