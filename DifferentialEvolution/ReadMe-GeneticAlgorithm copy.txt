****************************************************************************************************
Author:	Al Timofeyev
Date:	September 3, 2020
Desc:	This is how to compile and run the Differential Evolution algorithm using Processing IDE. 
	All notes for this algorithm and project are at the bottom of this ReadMe.

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

1.	Open DifferentialEvolution.pde in Processing IDE.
2.	Click the "Play" button in top left-hand corner (next to the square "Stop" button).
	This will start the program (or stop it if you hit the "Stop" button).

There are 7 parameters/variables you can play with to change the results of the Differential Evolution
located at the top of DifferentialEvolution.pde file.

---- Parameters
GOAL_SIZE		-- Changes the size of the (red) goal that all the particles are trying to go to.
POPULATION_SIZE		-- Controls how many Dots are in the population of the Differential Evolution.
GENERATIONS		-- The maximum number of moves each Dot in the population can make before the
			-- Differential Evolution Algorithm stops.
CR_PROBABILITY		-- The probability of a crossover happening to make one, potentially better, Dot
			-- In the range of 0 (inclusive) and 1 (exclusive) [0,1).
F			-- A Scaling Factor used to mutate the Dots of the population which is calculated in
			-- a STRATEGY. In the range of 0 (inclusive) and 1 (exclusive) [0,1).
LAMBDA			-- A Scaling Factor used to mutate the Dots of the population which is calculated in
			-- a STRATEGY. In the range of 0 (inclusive) and 1 (exclusive) [0,1).
STRATEGY		-- A Type of algorithm to use for crossover and mutation of Dots in the population.
			-- In the range of 1 (inclusive) and 10 (inclusive) [1, 10].




---- Example
GOAL_SIZE = 15			// Size of the goal is set to 15.
POPULATION_SIZE = 1000		// The population has 1000 Dots.
GENERATIONS = 5000		// Each Dot in the population can move up to 5000 times before Differential Evolution stops.
CR_PROBABILITY = 0.008		// 0.8% chance of a crossover happening between two parents of Dots.
F = 0.0002			// Scaling factor set to 0.0002.
LAMBDA = 0.2			// Scaling factor set to 0.2.
STRATEGY = 1			// Using the 1st strategy to crossover and mutate the population.

----------------------------------------------------------------------------------------------------

****************************************************************************************************

----------------------------------------------------------------------------------------------------
---------------------------------------------- NOTES -----------------------------------------------
1.	This example of the Differential Evolution has been modified to fit this example, as such it 
	bears a resemblance to the Particle Swarm Optimization algorithm.

2.	Because the Differential Evolution algorithm has been modified, the Crossover, Mutation and 
	Selection stages of this algorithm are slightly different. Crossover and Mutation do not have 
	a loop to calculate the mutation and crossover for each Dot (solution) in the population 
	because there are only 2 dimensions (x and y). The Selection stage does not replace the old Dot
	in the population if it is better (which it does in a basic Differential Evolution algorithm). 
	Instead, it changes the old Dot's direction of travel for this example.

3.	Before running the Differential Evolution, choose 1 of 10 strategies to use for this algorithm 
	and then fine-tune the CR_PROBABILITY, F and LAMBDA variables to achieve optimal results.

4.	Some analytics are printed out for the user to see the progress of the Differential Evolution.

5.	...
----------------------------------------------------------------------------------------------------