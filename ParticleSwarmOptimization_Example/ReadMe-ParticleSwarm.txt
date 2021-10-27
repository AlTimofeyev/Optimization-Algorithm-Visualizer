****************************************************************************************************
Author:	Al Timofeyev
Date:	June 9, 2019
Desc:	This is how to compile and run the Particle Swarm Optimization using Processing IDE.

Version:	1.0
****************************************************************************************************
****************************************************************************************************

----------------------------------------------------------------------------------------------------
---------------------------------------- CODING ENVIRONMENT ----------------------------------------
---- System
OS:	Windows 10 Pro (64-bit)
CPU:	Intel Core i7-6700HQ @ 2.60 GHz
RAM:	16.0 GB

---- Processing IDE
Processing Version:		3.3.7
Processing Mode:		Java
Java Version:			8
Java Update:			171
Java Build:			1.8.0_171-b11
Java Runtime Environment:	1.8.0_171
----------------------------------------------------------------------------------------------------

****************************************************************************************************

----------------------------------------------------------------------------------------------------
---------------------------------------- CONFIGURE AND RUN -----------------------------------------
This is how to configure and run the Particle Swarm Optimization (PSO) in Processing.

1.	Open ParticleSwarmOptimization_Example.pde in Processing IDE.
2.	Click the "Play" button in top left-hand corner (next to the square "Stop" button).
	This will start the program (or stop it if you hit the "Stop" button).

There are 4 parameters/variables you can play with to change the results of the Particle Swarm (with
an optional 5th parameter/variable), located at the top of ParticleSwarmOptimization_Example.pde file (lines 15-25).

---- Parameters
populationSize		-- Controls how many particles (dots) are in the Particle Swarm.
k			-- Velocity Dampening factor (used to slow down/speed up the particles).
c1			-- Scaling factor used to bring the particle closer to it's personal best.
c2			-- Scaling factor used to bring the particle closer to it's global best.
goalSize		-- (Optional) Changes the size of the (red) goal that all the particles
			-- are trying to go to.

---- Example
populationSize = 1000
k = 1.5
c1 = 0.9
c2 = 0.001256
goalSize = 15
----------------------------------------------------------------------------------------------------

****************************************************************************************************

----------------------------------------------------------------------------------------------------
---------------------------------------------- NOTES -----------------------------------------------
1.	If c1 > c2, then the particles will try to go towards their personal best.
	if c1 < c2, then the particles will try to go towards their global best.

2.	If the Particle Swarm ends up becoming a dot and stops moving, that means the population has
	stagnated (stopped improving). Stop the simulation and change some of the parameters explained
	in the "CONFIGURE AND RUN" section (above).
----------------------------------------------------------------------------------------------------