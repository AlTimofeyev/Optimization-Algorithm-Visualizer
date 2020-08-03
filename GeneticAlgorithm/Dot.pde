/**
 * Author:  Al Timofeyev
 * Date:    July 28, 2020
 */

class Dot
{
  PVector position;
  PVector velocity;
  PVector acceleration;

  PVector[] directions;   // A set of directions that this dot can move.
  int stepsToTake = 500;  // The number of times this dot can move before dying/failing or succeeding.
  int stepsTaken = 0;     // The numver of times this dot has moved.

  boolean dead = false;           // Keeps track if the dot is dead or if it can still move.
  boolean reachedGoal = false;    // Keeps track if the dot has reached the goal.
  boolean isBest = false;         // Keeps track if the dot is the best in population.

  float fitness = 0;              // How fit/good is this dot compared to other dots.

  // ************************************************************************
  // ***************************** CONSTRUCTORS *****************************
  // ************************************************************************

  // Default Constructor
  Dot()
  {
    // Fill the set of directions this dot can move in.
    directions = new PVector[stepsToTake];
    randomize();

    // Starting position of the dot (is centered at bottom).
    position = new PVector(width/2, height-10);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  // *************************************************************************************

  /*  Overloading the default constructor
   *  @param numOfSteps  The number of steps a dot can take.
   */
  Dot(int numOfSteps)
  {
    stepsToTake = numOfSteps;

    // Fill the set of directions this dot can move in.
    directions = new PVector[stepsToTake];
    randomize();

    // Starting position of the dot (is centered at bottom).
    position = new PVector(width/2, height-10);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  // ************************************************************************
  // ******************************* METHODS ********************************
  // ************************************************************************

  // Shows the Dot on the canvas.
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

  // *************************************************************************************

  // Fill the directions array with random PVectors.
  void randomize()
  {
    for (int i = 0; i < directions.length; i++)
    {
      // Get a random angle in radians.
      float randomAngle = random(2*PI);

      // Make a 2D unit vector out of the radian angle
      // and assign it to the i'th index of directions.
      // Basically, the x,y direction in which to travel.
      directions[i] = PVector.fromAngle(randomAngle);
    }
  }

  // *************************************************************************************

  // Moves the Dot to a new position on the canvas.
  void move()
  {
    // If there are no more directions, kill the dot.
    if (stepsTaken >= directions.length)
    {
      dead = true;
    }

    // Else move the dot in the next available direction.
    else
    {
      // Set acceleration of the dot to the next direction in the
      // directions array and update the number of steps taken.
      acceleration = directions[stepsTaken];
      stepsTaken++;

      // Add acceleration to the velocity
      // and limit the velocity to 5.
      velocity.add(acceleration);
      velocity.limit(5);

      // The new position will be the new x,y coordinates of velocity.
      position.add(velocity);
    }
  }

  // *************************************************************************************

  // Updates the dot position and checks to see if the dot is dead or goal is reached.
  void update()
  {
    // If the dot isn't dead and the goal hasn't been reached.
    if (!dead && !reachedGoal)
    {
      // Move the dot.
      move();

      // Check to see if the dot has moved out of the canvas boundaries.
      if (position.x < 2 || position.y < 2 || position.x > width-2 || position.y > height-2)
      {
        dead = true;  // If it did, kill the dot.
      }

      // Else if the goal was reached.
      else if (dist(position.x, position.y, goal.x, goal.y) < 5)
      {
        reachedGoal = true;
      }

      // Check to see if dot is touching any of the walls.
      for (Wall wall : walls)
      {
        if (wall.isDotTouchingWall(position))
        {
          dead = true;  // If this dot is touching any walls, kill the dot.
          break;
        }
      }
    }
  }

  // *************************************************************************************

  // Calculate the fitness of this dot.
  void calculateFitness()
  {
    if (reachedGoal)
    {
      // The more moves that were made, the smaller the fitness.
      fitness = 1.0 - (float)(stepsTaken)/(float)(stepsToTake * stepsToTake);
    } else
    {
      // The bigger the distance between dot and goal, the smaller the fitness.
      float distanceToGoal = dist(position.x, position.y, goal.x, goal.y);
      fitness = 1.0/(distanceToGoal * distanceToGoal);
    }
  }

  // *************************************************************************************

  // Mutate the dot directions.
  void mutate()
  {
    float randMutationProbability;

    // Randomly mutate some parts of the directions.
    for (int i = 0; i < directions.length; i++)
    {
      // Generate a random mutation probability [0, 1).
      randMutationProbability = random(1);

      // If the random mutation probability is less than the initial
      // mutation probability then mutate that direction.
      if (randMutationProbability < mutationProbability)
      {
        // Set this direction as a random direction
        float randomAngle = random(2*PI);
        directions[i].add(PVector.fromAngle(randomAngle));

        // Normalize the mutated direction to range (-1, 1).
        if (directions[i].x > 0)
          directions[i].x = 1 / (1+directions[i].x);
        else
          directions[i].x = 1 / (-1-directions[i].x);
        if (directions[i].y > 0)
          directions[i].y = 1 / (1+directions[i].y);
        else
          directions[i].y = 1 / (-1-directions[i].y);
      }
    }
  }

  // *************************************************************************************

  /*  Clones this dot's directions.
   *  @return  Returns a dot with the same set of directions as this dot.
   */
  Dot clone()
  {
    Dot child = new Dot(stepsToTake);

    // Clone the directions of this dot into the baby dot.
    for (int i = 0; i < directions.length; i++)
      child.directions[i] = directions[i].copy();

    return child;
  }
}
