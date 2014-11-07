%
%
% The force generated by a spring is a function of how much its stretched,
% the direction its pointed, and its current velocity.
%
%  The force generated is equal and opposite on its two ends.
%


function [forceA forceB] = apply_spring( spring, points )

    % a positive dx means the s pring is stretched
    spring_length   = norm(  points( spring.ptA ).pos - points( spring.ptB ).pos );
    dx              = spring_length - spring.rest_length ;
    
    % lets get arrow at A pointing toward B
    direction       = ( points(spring.ptB).pos - points(spring.ptA).pos ) / spring_length;
    
    % a positive vel means the spring is lengthening 
    vel             = points( spring.ptB ).vel - points( spring.ptA ).vel;
    vel             = vel(1)*direction(1) + vel(2)*direction(2);
    
    % a positive magnitude means the force is toward lengthening
    mag             = -spring.k*dx - spring.b*vel;
    
    forceA.vec      = -mag*direction;
    forceA.pt       = spring.ptA;
    forceB.vec      = -forceA.vec;
    forceB.pt       = spring.ptB;
    
    