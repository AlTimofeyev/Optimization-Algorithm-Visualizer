/*
 *  Author:  Al Timofeyev
 *  Date:    June 1, 2019
 *  Desc:    Example of a simple particle swarm within a set of boundaries.
 *
 *  Version:      2.0
 *  Modified By:  Al
 *  Modify Date:  Oct. 25 2021
*/

// ********************************************************************************
// ******************** CHANGE THESE TO CONTROL PARTICLE SWARM ********************
// ********************************************************************************
int populationSize = 1000;  // Size of the population.
float k = 1.5;              // Dampens the rate of change of the particles in the population.
float c1 = 0.9;             // Scaling factor brings particle close to it's personal best.
float c2 = 0.001256;        // Scaling factor brings particle close to it's gloabl best.

int goalSize = 15;          // Size (width, height) of goal.
// ********************************************************************************
// ********************************************************************************

ParticleSwarmOptimization swarm;  // Declare the Particle Swarm Optimization object.
PVector goal;                     // Declare the goal vector of the particle swarm.

void setup()
{
  size(800, 800);       // Size of the canvas is 800 by 800 (x, y).
  goal = getNewGoal();  // Set a goal for the particle swarm.
  
  // Initialize the particle swarm.
  //swarm = new ParticleSwarmOptimization(populationSize, k, c1, c2);  // Using the normal constructor and your own values.
  swarm = new ParticleSwarmOptimization();  // Using the Default Constructor.
}

void draw()
{
  // Change goal and revive the population if more than 1/4 the population
  // has reached the goal within 350 iterations.
  if(frameCount > 350)
  {
    if(swarm.mostOfPopReachedGoal())
    {
      goal = getNewGoal();
      swarm.revivePopulation();
    }
  }
  
  // Change goal if population hasn't reached the goal every 500 iterations.
  if(frameCount%500 == 0)
  {
    if(!swarm.mostOfPopReachedGoal())
    {
      goal = getNewGoal();
      swarm.revivePopulation();
    }
  }
  
  background(255);  // Set canvas background color.
  
  // Set the fill color and size of the goal.
  fill(255, 0, 0);
  ellipse(goal.x, goal.y, goalSize, goalSize);
  
  swarm.updatePopulation();  // Update the particle swarm population
  swarm.show();              // Show it on the canvas.
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

// ********************************************************************************

// Sets a new goal based on the mouse location on the canvas.
void setGoalBasedOnMouse()
{
  goal.x = mouseX;
  goal.y = mouseY;
}
