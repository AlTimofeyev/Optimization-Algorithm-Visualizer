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
  void show()
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
  void iniParticle()
  {
    // Determine wether to spawn particles in top or bottom half of canvas.
    boolean top = false;
    if(goal.y > height/2)
      top = true;
    
    // --------- Initialize The Particle Position ---------
    float rand1 = random(1);          // Get two random values between [0,1].
    float rand2 = random(1);
    float x = 0 + rand1*(width - 0);  // Normalize the x value to within the bounds.
    float y = 0 + rand2*(height - 0);                          // Normalize the y value to within the bounds
    /*
    if(top)
      y = 0 + rand2*(height/4 - 0);             // (top of canvas).
    else
      y = (height - height/4) + rand2*(height - (height - height/4)); // (bottom of canvas).
    */
    position = new PVector(x, y);     // Set the initial position of particle.
    
    // ---------- Initialize The Velocity Vector ----------
    float randx = random(0, 0.5*(width - 0));  // Get random x value.
    float randy = random(0, 0.5*(height - 0)); // Get random y value.
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
  void calcFitness()
  {
    fitness = dist(position.x, position.y, goal.x, goal.y);
  }
  
  /**
   *  Updates the velocity vector using the global best particle and the
   *  scaling factors.
   */
  void updateVelocity(PVector globBest, float k, float c1, float c2)
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
  void moveParticle(PVector globBest, float k, float c1, float c2)
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
  void updateParticle(PVector globBest, float k, float c1, float c2)
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
