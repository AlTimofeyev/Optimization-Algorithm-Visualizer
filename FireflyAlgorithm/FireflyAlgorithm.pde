/*
 *  Author:  Al Timofeyev
 *  Date:    June 16, 2019
 *  Desc:    Implementation of a simple Firefly Algorithm for a 
 *           better understanding of how the algorithm works (visualized).
 *
 *  Version:      1.0
 *  Modified By:  
 *  Modify Date:  
*/


Population flies;           // Declare the Firefly Algorithm population object.
PVector goal;               // The goal vector of the Firefly Algorithm.

// ********************************************************************************
// ****************** CHANGE THESE TO CONTROL FIREFLY ALGORITHM *******************
// ********************************************************************************
int populationSize = 200;  // Size of the population.
float alpha = 0.48295;    // Scaling factor used to help change the position of the fireflies, where alpha is in range [0, 1] (inclusive).
float beta0 = 0.0015892;  // Scaling factor used to Calculate the attractiveness of the fireflies.
float gamma = 0.0001435;  // Scaling factor used to calculate the Light Intensity and Attractiveness of the fireflies.

int fireflySize = 5;        // Size (width, height) of all fireflies.
int bFireflySize = 12;      // Size (width, height) of the best firefly.
int goalSize = 15;          // Size (width, height) of goal.
// ********************************************************************************
// ********************************************************************************

void setup()
{
  size(800, 800);       // Size of the canvas is 800 by 800 (x, y).
  goal = getNewGoal();  // Set a goal for the particle swarm.
  
  // Initialize the Firefly Algorithm (use only ONE of the Three examples below).
  flies = new Population(populationSize, alpha, beta0, gamma, fireflySize, bFireflySize);  // Includes both the firefly size and best firefly size.
  //flies = new Population(populationSize, alpha, beta0, gamma, bFireflySize);               // Includes only the best firefly size.
  //flies = new Population(populationSize, alpha, beta0, gamma);                             // Uses the default sizes for all fireflies and best firefly.
}

void draw()
{
  background(255);  // Set canvas background color.
  
  // Set the fill color and size of the goal.
  fill(255, 0, 0);
  ellipse(goal.x, goal.y, goalSize, goalSize);
  
  flies.updatePopulation();
  flies.show();
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
