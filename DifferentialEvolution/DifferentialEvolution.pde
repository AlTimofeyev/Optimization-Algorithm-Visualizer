/**
 * Author:  Al Timofeyev
 * Date:    August 7, 2020
 * Desc:    Example of a simple Differential Evolution algorithm. Please refer to
 *          the README.txt file for explanations on what the changable variables
 *          are and what they do.
 * 
 * Version:      1.0
 * Modified By:  
 * Modify Date:  
 */

Population swarm;  // Declare the Differential Evolution population object.
PVector goal;

// ********************************************************************************
// **************** CHANGE THESE TO CONTROL DIFFERENTIAL EVOLUTION ****************
// ********************************************************************************
final int GOAL_SIZE = 15;          // The size of the goal.
final int POPULATION_SIZE = 1000;  // The size of the population.
final int GENERATIONS = 5000;      // The number of time to execute the Diffirential Evolution algorithm.

final float CR_PROBABILITY = 0.008;  // The probability of a crossover, in the range of [0, 1).
final float F = 0.0002;              // A Scaling factor, in the range of [0, 1).
final float LAMBDA = 0.2;            // A scaling factor, in the range of [0, 1).
final int STRATEGY = 1;              // The strategy to use for mutation, in the range of [1, 10].
// ********************************************************************************
// ********************************************************************************

void setup()
{
  size(800, 800);
  goal = new PVector(width/2, height/2);

  swarm = new Population(POPULATION_SIZE);
}

void draw()
{
  background(255);  // Set canvas background color.

  // Set the fill color and size of the goal.
  fill(255, 0, 0);
  ellipse(goal.x, goal.y, GOAL_SIZE, GOAL_SIZE);
  
  // Run the Differential Evolution on the population.
  swarm.run_Differential_Evolution();
  
  // Show the new population on canvas.
  swarm.show();
  
  // Print the Population Analysis of Differential Evolution for each generation.
  swarm.print_Differential_Evolution_Population_Analysis();
  
  // ******************************************************************
  // COMMENT OUT THE WHOLE SECTION BELOW IF YOU WANT THE BASIC, INFINIT-LOOP, VISUALIZATION
  // ******************************************************************
  
  // --------------------------------------
  // Comment out this IF...Statement if you are
  // using the Change Goal IF...Statement below.
  // --------------------------------------
  
  // Stop the Differential Evolution once GENERATION limit is reached.
  if(frameCount == GENERATIONS)
  {
    swarm.print_Differential_Evolution_Population_Analysis();
    noLoop();
  }
  
  // --------------------------------------
  // Comment out this IF...Statement if you are
  // using the NoLoop-GENERATIONS IF...Statement above.
  // --------------------------------------
  
  // If more than 1/4 the population has reached the goal,
  // OR, if population hasn't reached the goal every GENERATIONS iterations.
  //if(swarm.mostOfPopulationReachedGoal() || ( frameCount%GENERATIONS == 0 && !swarm.mostOfPopulationReachedGoal() ))
  //{
  //    goal = getNewGoal();       // Set a new goal location.
  //    swarm.revivePopulation();  // Revive population.
  //}
  
  // ******************************************************************
  // ******************************************************************
}

 // ********************************************************************************
 // ********************************************************************************
 
// Returns a new Goal PVector within window limits.
PVector getNewGoal()
{
  // Get two random values between [0,1].
  float rand1 = random(1);
  float rand2 = random(1);
  
  // Normalize the two random values to within the bounds.
  float x = 0 + rand1*(width - 0);
  float y = 0 + rand2*(height - 0);
  
  // Return a new PVector with the x and y coordinates.
  return new PVector(x, y);
}
