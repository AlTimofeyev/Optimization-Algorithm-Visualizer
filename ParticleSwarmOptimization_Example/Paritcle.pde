/*
 *  Author:  Al Timofeyev
 *  Date:    June 1, 2019
 *  Desc:    Holds the information of a single element of data in the dataset/population.
 
 *  Version:      2.0
 *  Modified By:  Al
 *  Modify Date:  Oct. 25 2021
*/


/**
 * @class   Particle
 * @brief   Meant to hold the information of a single element of data in the dataset/population.
 * @note    Having a seperate class, inner class, or some kind of structure (struct in C++) to hold
 *          the information of a single element is essential in an optmization algorithm.
 */
class Particle
{
  // ------------------------------------------------------
  // ----------------------- FIELDS -----------------------
  // ------------------------------------------------------
  private static final int velocityLimit = 5; // Limits the speed of the Particle on the canvas.
  
  private PVector position;           // The x,y position of the Particle on the canvas.
  private PVector velocity;           // The velocity of the Particle.
  private PVector personalBestPos;    // The personal best position of the Particle.
  
  private float fitness;              // Fitness of the Particle based on it's position.
  private float personalBestFit;      // Fitness of the Particle's personal best position.
  
  private boolean isGlobalBest;       // True if this Particle is the best in the dataset/population.
  private boolean reachedGoal;        // True if this Particle has reached the goal.
  
  // ------------------------------------------------------
  // -------------------- CONSTRUCTORS --------------------
  // ------------------------------------------------------
  /**
   * @brief   Default Constructor
   * @details Initializes this class object with starting values.
   */     
  public Particle()
  {
    // ----------- Initialize The Particle Position ------------
    float rand1 = random(1);           // Get two random values between [0,1].
    float rand2 = random(1);
    float x = 0 + rand1*(width - 0);   // Normalize the x value to within the bounds.
    float y = 0 + rand2*(height - 0);  // Normalize the y value to within the bounds
    position = new PVector(x, y);      // Set the initial position of particle.
    
    // ---------- Initialize The Velocity Vector ----------
    float randx = random(0, 0.5*(width - 0));   // Get random x value.
    float randy = random(0, 0.5*(height - 0));  // Get random y value.
    velocity = new PVector(randx, randy);       // Set the initial velocity vector.
    
    // ------------ Set Personal Best Position ------------
    personalBestPos = position;
    
    // ----------- Initialize The Other Globals -----------
    isGlobalBest = false;
    reachedGoal = false;
  }
  
  // ------------------------------------------------------
  // --------------------- FUNCTIONS ----------------------
  // ------------------------------------------------------
  /**
   * @brief   Shows the object on the canvas.
   * @note    This is NOT part of this optimization algorithm, it is only for this example.
   */
  public void show()
  {
    if (isGlobalBest)  // If this is the best global particle, make it bigger and green.
    {
      fill(0, 255, 0);
      ellipse(position.x, position.y, 18, 18);
    }
    else               // Else, use the default color and size.
    {
      fill(0);
      ellipse(position.x, position.y, 4, 4);
    }
  }
  
  /**
   * @brief   Updates this Particle object.
   * @details Uses the best global element of dataset/population and the scaling factors of the Particle Swarm Optimization.
   * @note    The way you update each element in the dataset/population is determined by what you're using the data for; I am visualizing the element's movement across the screen so I update each element by moving it's position.
   *
   * @param globBest                  The global best element (Particle object) in the dataset/population.
   * @param dampener_K                The data dampener.
   * @param personalScalingFactor_c1  The personal scaling factor.
   * @param globalScalingFactor_c2    The global scaling factor.
   */
  public void updateParticle(Particle globBest, float dampener_K, float personalScalingFactor_c1, float globalScalingFactor_c2)
  {
    if(!reachedGoal)    // If it has not reached the goal yet.
    {
      updateVelocity(globBest, dampener_K, personalScalingFactor_c1, globalScalingFactor_c2);  // Update the velocity.
      position.add(velocity);                                                                  // Move the Particle.
    }
    
    // Check if the goal has been reached.
    if(dist(position.x, position.y, goal.x, goal.y) < goalSize/2)
      reachedGoal = true;
  }
  
  /**
   * @brief   Updates this Particle object's velocity vector.
   * @details Uses the best global element of dataset/population and the scaling factors of the Particle Swarm Optimization.
   *
   * @param globBest                  The global best element (Particle object) in the dataset/population.
   * @param dampener_K                The data dampener.
   * @param personalScalingFactor_c1  The personal scaling factor.
   * @param globalScalingFactor_c2    The global scaling factor.
   */
  private void updateVelocity(Particle globBest, float dampener_K, float personalScalingFactor_c1, float globalScalingFactor_c2)
  {
    // Generate random numbers.
    float randx1 = random(1);
    float randx2 = random(1);
    float randy1 = random(1);
    float randy2 = random(1);
    
    // Calculate the new x and y coordinates of velocity (dampen them with scaling factor K).
    // Each element in the Particle Swarm Optimization algorithm is updated using this mathematical equation.
    // In this example, I'm using this equation to update each element's velocity, and in effect, updating each element.
    float newX = dampener_K * (velocity.x + personalScalingFactor_c1 * randx1 * (personalBestPos.x - position.x) + globalScalingFactor_c2 * randx2 * (globBest.position.x - position.x));
    float newY = dampener_K * (velocity.y + personalScalingFactor_c1 * randy1 * (personalBestPos.y - position.y) + globalScalingFactor_c2 * randy2 * (globBest.position.y - position.y));
    
    // Set the new velocity (limit is optional, for this example only).
    velocity.x = newX;
    velocity.y = newY;
    velocity.limit(velocityLimit);
  }
}
