This is the software simulation code that accompanies my paper:

Biomechanics of the vibrissa motor plant in rat: rhythmic whisking consists of triphasic neuromuscular activity
DN Hill, R Bermejo, HP Zeigler, D Kleinfeld
The Journal of Neuroscience 28 (13), 3438-3455

Please see this reference for details on the model.

----------
Notes:

Modify sim_params in order to change parameters of a simulation run.

Run sim_init to run the simulation.

The output is a variable called sol which gives the 4 state variables for each model vibrissa.

N = number of whiskers.
If k is from 0 to N-1
sol(k*4+1,:) = AP translation of vibrissa k's center-of-mass in millimeters
sol(k*4+2,:) a= 1st Derivative of above
sol(k*4+3,:) = AP angle of vibrissa k.  180 (0) degrees is maximum protraction (retraction).
sol(k*4+4,:) = 1st derivative of above

params.t(i) will contain the timestamp in seconds of the ith element of sol.
