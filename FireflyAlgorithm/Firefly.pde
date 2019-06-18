/*
 *  Author:  Al Timofeyev
 *  Date:    June 13, 2019
 *  Desc:    Firefly class to hold all the information of a single firefly
 *           in the Firefly Algorithm.
 *
 *  Version:      1.0
 *  Modified By:  
 *  Modify Date:  
*/


class Firefly
{
  PVector position;        // The x,y position of the firefly on the canvas.
  float fitness;           // Fitness of the firefly based on it's position.
  
  boolean isGlobalBest = false;  // True if this firefly is the best in the population.
  boolean reachedGoal = false;   // True if this firefly has reached the goal.
  int fireflySize;               // Size of all firefies.
  int bestFireflySize;           // Size of the best firefly.
  
  // ---------------------- Construrctor ----------------------
  /**
   *  Default Constructor.
   */
  Firefly()
  {
    fireflySize = 5;
    bestFireflySize = 10;
    iniFirefly();
  }
  
  /**
   *  Constructor takes a PVector position.
   */
  Firefly(PVector position)
  {
    fireflySize = 5;
    bestFireflySize = 10;
    this.position = position;
    calcFitness();
  }
  
  /**
   *  Constructor takes specific size for the best firefly.
   */
  Firefly(int bFSize)
  {
    fireflySize = 5;
    bestFireflySize = bFSize;
    iniFirefly();
  }
  
  /**
   *  Constructor takes specific size for the best firefly and
   *  all other fireflies..
   */
  Firefly(int fSize, int bFSize)
  {
    fireflySize = fSize;
    bestFireflySize = bFSize;
    iniFirefly();
  }
  
  // ----------------------- Functions ------------------------
  /**
   *  Shows the firefly on the canvas
   */
  void show()
  {
    // If this is the best firefly, make it bigger and yellow.
    if (isGlobalBest)
    {
      fill(255, 255, 255);
      ellipse(position.x, position.y, bestFireflySize, bestFireflySize);
    }
    
    // Else, use the default color and size.
    else
    {
      float fColor = 255;  // Yellow saturation of firefly color.
      float fColor2 = 0;   // Yello luminosity of firefly color.
      
      // If firefly is more than 255 distance away from goal, change color saturation from yellow to black.
      if (fitness > 255)
      {
        float tempFit = fitness - 255;
        fColor = 255 - tempFit;
      }
      
      // Else, change luminosity of firefly.
      else
      {
        fColor2 = 255 - fitness;
      }

      if (fColor < 0)
        fColor = 0;
      if (fColor2 < 0)
        fColor2 = 0;
      
      fill(fColor, fColor, fColor2);            // Fill color of the dot is set to a color of yellow based on fitness.
      ellipse(position.x, position.y, fireflySize, fireflySize);    // Size of the dot. 
    }
  }
  
  /**
   *  Initializes this firefly with a random position within window bounds.
   */
  void iniFirefly()
  {    
    // --------- Initialize The Firefly Position ---------
    float rand1 = random(1);          // Get two random values between [0,1].
    float rand2 = random(1);
    float x = 0 + rand1*(width - 0);  // Normalize the x value to within the bounds.
    float y = 0 + rand2*(height - 0); // Normalize the y value to within the bounds
    position = new PVector(x, y);     // Set the initial position of firefly.
    
    // ---------------- Set Fitness Value ----------------
    calcFitness();
  }
  
  /**
   *  Calculates the fitness of the firefly based on it's distance from the goal.
   *  The closer to the goal, the smaller the fitness (better).
   *  The farther from the goal, the bigger the fitness (worse).
   */
  void calcFitness()
  {
    fitness = dist(position.x, position.y, goal.x, goal.y);
  }
  
  /**
   *  Gets the distance between this firefly and the parameter firefly
   *  by calculating the magnitude of ||firefly1 - firefly2||, where
   *  firefly1 is this firefly and firefly2 is parameter firefly.
   */
  float calcDistance(Firefly firefly)
  {
    float distance;        // Variable to hold the distance between the fireflies.
    float summedUp = 0;    // Varialbe to hold the sum of position dimensions.
    
    // Sum up the x,y dimensions of both fireflies using (SUMMATION( (firefly1[dim] - firefly2[dim])^2 )).
    summedUp += pow((position.x - firefly.position.x), 2);
    summedUp += pow((position.y - firefly.position.y), 2);
    
    distance = sqrt(summedUp);  // Get the actual magnitude (distance) by square rooting the summedUp variable.
    
    return distance;  // Return the distance.
  }
  
  /**
   *  Calculates light intensity of a firefly based on it's distance (r)
   *  from another firefly.
   */
  double calcLightIntensity(float gamma, float r)
  {
    float exponent = -(gamma) * pow(r, 2);           // Calculate exponent of Euler's number e.
    double lightIntensity = fitness * exp(exponent);  // Calculate light intensity (exp() is Euler's number).
    
    return lightIntensity;  // Return light intensity.
  }
  
  /**
   *  Calculates the attractiveness of a firefly based on it's distance (r)
   *  from another firefly.
   */
  float calcAttractiveness(float beta0, float gamma, float r)
  {
    float exponent = -(gamma) * pow(r, 2);         // Calculate exponent of Euler's number e.
    float attractiveness = beta0 * exp(exponent);  // Calculate the attractiveness (exp() is Euler's number).
    
    return attractiveness;  // Return the attractiveness.
  }
  
  /**
   *  Moves firefly to a new x,y position.
   */
  void moveFirefly(Firefly brightFirefly, float alpha, float beta0, float gamma, float r)
  {
    float beta = calcAttractiveness(beta0, gamma, r);  // Calculate the attractivenss.
    float gaussianNum1 = random(1) - 0.5;              // Generate Gaussian random number for x dimension.
    float gaussianNum2 = random(1) - 0.5;              // Generate Gaussian random number for y dimension.
    
    // Determine new x and y coordinates for firefly.
    float x = position.x + beta * (brightFirefly.position.x - position.x) + alpha * gaussianNum1;
    float y = position.y + beta * (brightFirefly.position.y - position.y) + alpha * gaussianNum2;
    position = new PVector(x, y);
  }
  
  /**
   *  Updates the firefly position and fitness values.
   */
  void updateFirefly(Firefly brightFirefly, float alpha, float beta0, float gamma, float r)
  {
    // If the goal was reached, do nothing.
    if(reachedGoal)
      return;
    
    moveFirefly(brightFirefly, alpha, beta0, gamma, r);  // Move firefly.
    calcFitness();                                       // Calculate it's fitness.
    
    // Check if the goal has been reached.
    if(dist(position.x, position.y, goal.x, goal.y) < goalSize/2)
      reachedGoal = true;
  }
}
