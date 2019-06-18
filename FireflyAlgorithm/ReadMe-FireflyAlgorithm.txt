****************************************************************************************************
Author:	Al Timofeyev
Date:	June 17, 2019
Desc:	This is how to compile and run the Firefly Algorithm using Processing IDE.

Version:	1.0
Modified By:	
Modify Date:	
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
This is how to configure and run the Firefly Algorithm (FA) in Processing.

1.	Open FireflyAlgorithm.pde in Processing IDE.
2.	Click the "Play" button in top left-hand corner (next to the square "Stop" button).
	This will start the program (or stop it if you hit the "Stop" button).

There are 4 parameters/variables you can play with to change the results of the Particle Swarm (with
3 optional parameters/variables), located at the top of FireflyAlgorithm.pde file (lines 16-28).

---- Parameters
populationSize		-- Controls how many particles (dots) are in the Particle Swarm.
alpha			-- Scaling factor used to help change the position of the fireflies, where
			-- alpha is in range [0, 1] (inclusive).
beta0			-- Scaling factor used to Calculate the attractiveness of the fireflies.
gamma			-- Scaling factor used to calculate the Light Intensity and Attractiveness
			-- of the fireflies.
fireflySize		-- (Optional) Changes the size of all fireflies in the Firefly Algorithm.
bFireflyeSize		-- (Optional) Changes the size of the best firefly in the Firefly ALgorithm.
goalSize		-- (Optional) Changes the size of the (red) goal that all the particles
			-- are trying to go to.

---- Example
populationSize = 100
alpha = 0.48295
beta0 = 0.0015892
gamma = 0.0001435
fireflySize = 5
bFireflySize = 12
goalSize = 15
----------------------------------------------------------------------------------------------------

****************************************************************************************************

----------------------------------------------------------------------------------------------------
---------------------------------------------- NOTES -----------------------------------------------
1.	The best firefly in the Firefly Algorithm does not move at all.

2.	Search Algorithms for Best Firefly have not been implemented.
	The best firelfy is supposed to use one of three search algorithms (Blind Search, Local Search,
	or Iterative Local Search) to find a better solution and move towards it. However, only the 
	Local Search algorithm has been defined, but it has not been implemented.
	(perhaps implementation will be done in version 2.0 of this Firefly Algorithm example.)
----------------------------------------------------------------------------------------------------