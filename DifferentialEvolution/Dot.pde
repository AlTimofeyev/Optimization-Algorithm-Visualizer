/**
 * Author:  Al Timofeyev
 * Date:    August 7, 2020
 * Desc:    
 * 
 * Version:      1.0
 * Modified By:  
 * Modify Date:  
 */

class Dot
{
  private PVector position;  // The x,y position of the Dot on the canvas.
  PVector velocity;          // The velocity of the Dot.

  float fitness;                 // Fitness of the Dot based on it's position.
  boolean reachedGoal = false;   // True if this Dot has reached the goal.
  boolean isBest = false;        // Keeps track if the dot is the best in population.

  // ************************************************************************
  // ***************************** CONSTRUCTORS *****************************
  // ************************************************************************

  /**
   * @brief Default Constructor.
   * Initializes this Dot with a random position within window bounds.
   * A velocity vector is also initialized.
   */
  Dot()
  {
    // ---------- Initialize The Position Vector ----------
    float rand1 = random(1);          // Get two random values between [0,1].
    float rand2 = random(1);
    float x = 0 + rand1*(width - 0);  // Normalize the x value to within the bounds.
    float y = 0 + rand2*(height - 0); // Normalize the y value to within the bounds
    position = new PVector(x, y);     // Set the initial position of particle.

    // ---------- Initialize The Velocity Vector ----------
    float randx = random(0, 0.5*(width - 0));  // Get random x value.
    float randy = random(0, 0.5*(height - 0)); // Get random y value.
    velocity = new PVector(randx, randy);      // Set the initial velocity vector.
    velocity.limit(1);                         // Limit the velocity.

    // ---------------- Set Fitness Value -----------------
    calculateFitness();
  }

  // ************************************************************************
  // ******************************* METHODS ********************************
  // ************************************************************************

  /**
   * Shows the Dot on the canvas.
   */
  void show()
  {
    // If this is the best dot, make it bigger and green.
    if (isBest)
    {
      fill(0, 255, 0);
      ellipse(position.x, position.y, 9, 9);
    }
    // Else, use the default color and size.
    else
    {
      // Fill color of the dot is set to Black.
      fill(0);

      // Size of the dot. 
      ellipse(position.x, position.y, 4, 4);
    }
  }

  /**
   * Calculate the fitness of this dot.
   */
  void calculateFitness()
  {
    // The fitness is the distance to the goal.
    // Smaller fitness is better, bigger fitness is worse.
    fitness = dist(position.x, position.y, goal.x, goal.y);
  }

  // *************************************************************************************

  /**
   * Updates the velocity vector using a new Dot's position.
   * @param newDot The new Dot that this Dot will travel towards.
   */
  void updateVelocity(Dot newDot)
  {
    // Get an angle (in radians) between this Dot's position and the newDot's position.
    float angle = atan2(newDot.position.y - this.position.y, newDot.position.x - this.position.x);

    // Set the new velocity coordinates using the angle.
    velocity.add(PVector.fromAngle(angle));
    velocity.limit(5);
  }

  // *************************************************************************************

  /**
   * Move this Dot using the current velocity.
   */
  void move()
  {
    if (!reachedGoal)          // If it has not reached the goal yet.
      position.add(velocity);  // Move the Dot.
  }

  // *************************************************************************************

  /**
   * Move this Dot after updating the current velocity.
   * @param newDot The new Dot which will be used to make a new velocity.
   */
  void move(Dot newDot)
  {
    if (!reachedGoal)  // If it has not reached the goal yet.
    {
      updateVelocity(newDot);  // Update the velocity using the new Dot.
      position.add(velocity);  // Move the Dot.
    }
  }

  // *************************************************************************************

  /**
   *  Updates this Dot by moving it and checking if the goal was reached.
   */
  void update()
  {
    move();              // Move the Dot.
    calculateFitness();  // Calculate the fitness.

    // Check if the goal has been reached.
    if (dist(position.x, position.y, goal.x, goal.y) < GOAL_SIZE/2)
      reachedGoal = true;
  }

  // *************************************************************************************

  /**
   * Updates this Dot by moving it in a new Dot's direction and checking 
   * if the goal was reached.
   * @param newDot The new Dot which will be used to make a new velocity.
   */
  void update(Dot newDot)
  {
    move(newDot);        // Move the Dot towards the new Dot.
    calculateFitness();  // Calculate the fitness.

    // Check if the goal has been reached.
    if (dist(position.x, position.y, goal.x, goal.y) < GOAL_SIZE/2)
      reachedGoal = true;
  }

  // *************************************************************************************

  /**
   * Clones this Dot.
   * @return  Returns a dot.
   */
  Dot clone()
  {
    Dot child = new Dot();

    // Clone this Dots' Field variables into the child dot.
    child.position = this.position.copy();
    child.velocity = this.velocity.copy();
    child.fitness = this.fitness;
    child.reachedGoal = this.reachedGoal;
    child.isBest = this.isBest; 

    return child;
  }
}
