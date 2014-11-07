function y_sol = ode4( dydt, time, y0 )
%  [time, y_sol, y_drv] = ode4( dydt, time, y0, u, params )
%
% Solve a system of nonhomogeneous ordinary differential equations using the 
% 4th order Runge-Kutta method.  
%
%  Input Variable      Description                         
%  --------------      ----------- 
%      dydt          : a function of the form y_dot = dydt(t,y,u,params)
%                      which provides the state derivative given 
%                      the state, y, and the time, t  
%      time          : a vector of points in time at which the solution 
%                      is computed 
%       y0           : the initial value of the states 
%     params         : vector of other parameters for dydt
%       u            : m-by-p matrix of forcing for the ode, where m
%                      m = number of inputs  and  n = length(time);
%
% Output Variable        Description
% --------------         -----------
%      time          : is returned, un-changed
%      y_sol         : the solution to the differential equation at 
%                      times given in the vector time.
%
% Henri Gavin, Civil and Environmental Engineering, Duke Univsersity, Jan. 2001
% WH Press, et al, Numerical Recipes in C, 1992, Section 16.1

 n      = length(y0(:));
dt      = time(2)-time(1);

 y_sol  = zeros(n,length(time));	% memory allocation
 y_drv  = zeros(n,length(time));	% memory allocation
 y_sol(:,1) = y0(:);		% the initial conditions
 
 for p = 1:(length(time)-1)

     format long
     t      = time(p); 
    
     k1  = dt*feval( dydt, t,  y0 );
     k2  = dt*feval( dydt, t + dt*.5, y0 + k1*.5 );
     k3  = dt*feval( dydt, t + dt*.5, y0 + k2*.5 );
     k4  = dt*feval( dydt, t + dt   , y0 + k3 );

     y0 = y0 + ( k1 + 2*(k2 + k3) + k4 )/6; 
     y_sol(:,p+1) = y0(:);
   
 end

% endfunction # ---------------------------------------------------------
% ODE4