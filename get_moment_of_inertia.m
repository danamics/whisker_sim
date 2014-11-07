function [Iv, Cv] = get_moment_of_inertia( Lf, Lh, Mf, Mh )


% calculate centers of mass
Cf = .50 * Lf;
Ch = .25 * Lh;
Cv =  ( 1/(Mf + Mh) ) * (Mf*Cf + Mh*(Ch + Lf) );

% calculate moments of inertia
If = (1/3)  * Mf * (Lf^2);
Ih = (1/10) * Mh * (Lh^2);

% caculate the big moment
Iv = If + -2*Cv*Cf*Mf + Cv*Cv*Mf + Ih + -2*(Cv-Lf)*Ch*Mh + (Cv-Lf)*(Cv-Lf)*Mh; 

