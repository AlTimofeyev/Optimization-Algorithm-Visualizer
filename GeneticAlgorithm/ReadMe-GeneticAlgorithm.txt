****************************************************************************************************
Author:	Al Timofeyev
Date:	August 2, 2020
Desc:	This is how to compile and run the Genetic Algorithm using Processing IDE.

Version:	1.0
****************************************************************************************************
****************************************************************************************************

----------------------------------------------------------------------------------------------------
---------------------------------------- CODING ENVIRONMENT ----------------------------------------
---- System
OS:	macOS Catalina (version 10.15.6) (64-bit)
CPU:	Intel Core i9 @ 2.30 GHz
RAM:	32.0 GB

---- Processing IDE
Processing Version:		3.5.4
Processing Mode:		Java
Java Version:			14.0.1
Java Build:			14.0.1+7
Java Runtime Environment:	14.0.1+7
----------------------------------------------------------------------------------------------------

****************************************************************************************************

----------------------------------------------------------------------------------------------------
---------------------------------------- CONFIGURE AND RUN -----------------------------------------
This is how to configure and run the Particle Swarm Optimization (PSO) in Processing.

1.	Open GeneticAlgorithm.pde in Processing IDE.
2.	Click the "Play" button in top left-hand corner (next to the square "Stop" button).
	This will start the program (or stop it if you hit the "Stop" button).

There are 4 parameters/variables you can play with to change the results of the Particle Swarm (with
3 optional parameters/variables), located at the top of GeneticAlgorithm.pde file.

---- Parameters
goalSize		-- (Optional) Changes the size of the (red) goal that all the particles
			-- are trying to go to.
popSize			-- (Optional) Controls how many Dots are in the population of the Genetic Algorithm.
numOfMoves		-- (Optional) The maximum number of moves each Dot in the population can make before
			-- it dies or successfully makes it to the goal.
selectionType		-- The type of selection to use when selecting a new generation of Dots from the old
			-- population. There are only two types for this example. Tournament Selection = 1, and
			-- Roulette Wheel Selection = 2.
crProbability		-- The probability of a crossover happening between two parents of an old generation to
			-- make two children for the next generation of Dots. In the range of 0 (inclusive) and
			-- 1 (exclusive) [0,1).
mutationProbability	-- The probability of a mutation occurring to a Dots set of directions. In the range of
			-- 0 (inclusive) and 1 (exclusive) [0,1).
elitismRate		-- The fraction of the old population to survive to the next generation. In the range of
			-- 0 (inclusive) and 1 (exclusive) [0,1).




---- Example
goalSize = 15			// Size of the goal is set to 15.
popSize = 1000			// The population has 1000 Dots.
numOfMoves = 500		// Each Dot in the population can move up to 500 times before dying.
selectionType = 2		// Set to use the Roulette Wheel Selection type.
crProbability = 0.8		// 80% chance of a crossover happening between two parents of Dots.
mutationProbability = 0.01	// 1% chance of a mutation happening to the directions of new Dots.
elitismRate = 0.2		// 20% of the old population is to survive to the new population.

----------------------------------------------------------------------------------------------------

****************************************************************************************************

----------------------------------------------------------------------------------------------------
---------------------------------------------- NOTES -----------------------------------------------
1.	...
----------------------------------------------------------------------------------------------------