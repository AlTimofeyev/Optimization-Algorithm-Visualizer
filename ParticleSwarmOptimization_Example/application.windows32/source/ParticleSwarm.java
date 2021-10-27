import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ParticleSwarm extends PApplet {

/*
 *  Author:  Al Timofeyev
 *  Date:    June 1, 2019
 *  Desc:    Implementation of a simple particle swarm within a set of boundaries.
 *
 *  Version:      1.0
 *  Modified By:  
 *  Modify Date:  
*/


Population swarm;           // Declare the Particle Swarm population object.
PVector goal;               // The goal vector of the particle swarm.

// ********************************************************************************
// ******************** CHANGE THESE TO CONTROL PARTICLE SWARM ********************
// ********************************************************************************
int populationSize = 1000;  // Size of the population.
float k = 1.5f;              // Dampens the velocity of the particles in the population. 1.5
float c1 = 0.9f;             // Scaling factor brings particle close to it's personal best. 0.9
float c2 = 0.001256f;        // Scaling factor brings particle close to it's gloabl best. 0.001256

int goalSize = 15;          // Size (width, height) of goal.
// ********************************************************************************
// ********************************************************************************

public void setup()
{
         // Size of the canvas is 800 by 800 (x, y).
  goal = getNewGoal();  // Set a goal for the particle swarm.
  
  // Initialize the particle swarm.
  swarm = new Population(populationSize, k, c1, c2);
}

public void draw()
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
public PVector getNewGoal()
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
public void setGoalBasedOnMouse()
{
  goal.x = mouseX;
  goal.y = mouseY;
}
/*
 *  Author:  Al Timofeyev
 *  Date:    June 1, 2019
 *  Desc:    Holds a single particles information.
 
 *  Version:      1.0
 *  Modified By:  
 *  Modify Date:  
*/


class Particle
{
  PVector position;        // The x,y position of the particle on the canvas.
  PVector velocity;        // The velocity of the particle.
  PVector personalBestPos; // The personal best position of the particle.
  
  float fitness;           // Fitness of the particle based on it's position.
  float personalBestFit;   // Fitness of the particle's personal best position.
  
  boolean isGlobalBest = false;  // True if this particle is the best in the population.
  boolean reachedGoal = false;   // True if this particle has reached the goal.
  
  // ---------------------- Construrctor ----------------------
  Particle()
  {
    iniParticle();  // Initialize the particle.
  }
  
  // ----------------------- Functions ------------------------
  /**
   *  Shows the particle on the canvas
   */
  public void show()
  {
    // If this is the best global particle, make it bigger and green.
    if (isGlobalBest)
    {
      fill(0, 255, 0);
      ellipse(position.x, position.y, 18, 18);
    }
    
    // Else, use the default color and size.
    else
    {
      fill(0);                                // Fill color of the dot is set to Black.
      ellipse(position.x, position.y, 4, 4);  // Size of the dot. 
    }
  }
  
  /**
   *  Initializes this particle with a random position within window bounds.
   *  A velocity vector is also initialized.
   */
  public void iniParticle()
  {    
    // --------- Initialize The Particle Position ---------
    float rand1 = random(1);          // Get two random values between [0,1].
    float rand2 = random(1);
    float x = 0 + rand1*(width - 0);  // Normalize the x value to within the bounds.
    float y = 0 + rand2*(height - 0); // Normalize the y value to within the bounds
    position = new PVector(x, y);     // Set the initial position of particle.
    
    // ---------- Initialize The Velocity Vector ----------
    float randx = random(0, 0.5f*(width - 0));  // Get random x value.
    float randy = random(0, 0.5f*(height - 0)); // Get random y value.
    velocity = new PVector(randx, randy);      // Set the initial velocity vector.
    velocity.limit(1);
    
    // ------------ Set Personal Best Position ------------
    personalBestPos = position;
    
    // ---------------- Set Fitness Values ----------------
    calcFitness();
    personalBestFit = fitness;
  }
  
  /**
   *  Calculates the fitness of the particle based on it's distance from the goal.
   *  The closer to the goal, the smaller the fitness (better).
   *  The farther from the goal, the bigger the fitness (worse).
   */
  public void calcFitness()
  {
    fitness = dist(position.x, position.y, goal.x, goal.y);
  }
  
  /**
   *  Updates the velocity vector using the global best particle and the
   *  scaling factors.
   */
  public void updateVelocity(PVector globBest, float k, float c1, float c2)
  {
    // Generate random numbers.
    float randx1 = random(1);
    float randx2 = random(1);
    float randy1 = random(1);
    float randy2 = random(1);
    
    // Calculate the new x and y coordinates of velocity (dampen them with k).
    float newX = k * (velocity.x + c1 * randx1 * (personalBestPos.x - position.x) + c2 * randx2 * (globBest.x - position.x));
    float newY = k * (velocity.y + c1 * randy1 * (personalBestPos.y - position.y) + c2 * randy2 * (globBest.y - position.y));
    
    // Set the new velocity coordinates.
    velocity.x = newX;
    velocity.y = newY;
    velocity.limit(5);
  }
  
  /**
   *  Move the particle after updating it's velocity vector.
   */
  public void moveParticle(PVector globBest, float k, float c1, float c2)
  {
    // If it has not reached the goal yet.
    if(!reachedGoal)
    {
      // Update the velocity.
      updateVelocity(globBest, k, c1, c2);
      
      // Move the particle.
      position.add(velocity);
    }
  }
  
  /**
   *  Updates the particle by moving it and checking if it's personal
   *  best position has improved and if the goal was reached.
   */
  public void updateParticle(PVector globBest, float k, float c1, float c2)
  {
    // Move the particle
    moveParticle(globBest, k, c1, c2);
    
    // Calculate the fitness of paritlce.
    calcFitness();
    
    // Check if it's personal best has improved.
    if(fitness < personalBestFit)
    {
      personalBestPos = position;  // Update the personal best position.
      personalBestFit = fitness;   // Update the personal best fitness.
    }
    
    // Check if the goal has been reached.
    if(dist(position.x, position.y, goal.x, goal.y) < goalSize/2)
      reachedGoal = true;
  }
}
/**
 *  Author:  Al Timofeyev
 *  Date:    June 8, 2019
 *  Desc:    The Particle Swarm population.
 *           The fitness is dependant on how close each particle is to
 *           the goal; the smaller the distance between goal and particle,
 *           the smaller the fitness value = better fitness.
 *
 *  Version:        1.0
 *  Date Modified:
 *  Modified By:    
 */


class Population
{
  Particle[] particles;  // Population of particles.
  
  float c1;              // Scaling factor to bring particle closer to personal best.
  float c2;              // Scaling factor to bring particle closer to global best.
  float k;               // Velocity Dampening factor.
  
  // ---------------------- Construrctor ----------------------
  Population(int size, float k, float c1, float c2)
  {
    // Assign the scaling/dampening factors.
    this.c1 = c1;
    this.c2 = c2;
    this.k = k;
    
    // Initialize the particles.
    particles = new Particle[size];
    for(int i = 0; i < particles.length; i++)
      particles[i] = new Particle();
    
    // Sort the population based on fitness.
    quicksort(particles, 0, particles.length-1);
    
    // Set the global best.
    particles[0].isGlobalBest = true;
  }
  
  // ----------------------- Functions ------------------------
  /**
   *  Shows all the particles in the population on the canvas.
   */
  public void show()
  {
    for(int i = 0; i < particles.length; i++)
    {
      particles[i].show();
    }
  }
  
  /**
   *  Update all the particles in the population and check the global best.
   */
  public void updatePopulation()
  {
    // Update each particle's position.
    for(int i = 0; i < particles.length; i++)
      particles[i].updateParticle(particles[0].position, k, c1, c2);
    
    // Reset the global best to false.
    particles[0].isGlobalBest = false;
    
    // Sort the population based on fitness.
    quicksort(particles, 0, particles.length-1);
    
    // Set the global best.
    particles[0].isGlobalBest = true;
  }
  
  /**
   *  Checks to see if most of the population has reached the goal.
   */
  public boolean mostOfPopReachedGoal()
  {
    boolean reached;
    
    // Sum up how many particles have reached the goal.
    int reachedSum = 0;
    for(int i = 0; i < particles.length; i++)
    {
      if(particles[i].reachedGoal == true)
        reachedSum++;
    }
    
    // Did more than 1/4 reach their goal?
    reached = PApplet.parseFloat(reachedSum) / particles.length > 0.25f;
    
    // Return reached.
    return reached;
  }
  
  /**
   *  Revives the population by setting each particle's reachedGoal variable
   *  to False so that they can move again.
   */
  public void revivePopulation()
  {
    for(int i = 0; i < particles.length; i++)
      particles[i].reachedGoal = false;
  }
  
  // *******************************************************************
  // ******************** QUICKSORT IMPLEMENTATION *********************
  // *******************************************************************
  /**
   *  Sorts the population in ascending order.
   */
  public void quicksort(Particle[] parti, int L, int R)
  {
    int i, j, mid;
    float pivot;
    i = L;
    j = R;
    mid = L + (R - L) / 2;
    pivot = parti[mid].fitness;
    
    while (i<R || j>L)
    {
      while (parti[i].fitness < pivot)
        i++;
      
      while (parti[j].fitness > pivot)
        j--;
      
      if (i <= j)
      {
        swap(parti, i, j);
        i++;
        j--;
      }
      else
      {
        if (i < R)
          quicksort(parti, i, R);
        if (j > L)
          quicksort(parti, L, j);
        return;
      }
    }
  }
 
  public void swap(Particle[] parti, int l, int r)
  {
    // Swap the particles in the array.
    Particle tempParticle = parti[l];
    parti[l] = parti[r];
    parti[r] = tempParticle;
  }
}
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ParticleSwarm" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
