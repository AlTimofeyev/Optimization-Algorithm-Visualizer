/*
 *  Author:  Al Timofeyev
 *  Date:    June 16, 2019
 *  Desc:    Library of search algorithms:
 *           Blind Search, Local Search, Iterative Local Search.
 *
 *  Version:      1.0
 *  Modified By:  
 *  Modify Date:  
*/


/**
 *  Implementation of a Local Search Algorithm.
 */
PVector localSearch(Firefly firefly, float alpha)
{
  // Initialize the best position and fitness of the Local Seach.
  PVector bestPosition = firefly.position;
  float bestFitness = firefly.fitness;
  
  // Declare the neighborhood vector and its fitness variable.
  PVector neighborhood;
  float neighborhoodFitness;
  
  // Set the flag for the Local Search.
  boolean isNotComplete = true;
  
  // Begin Local Search.
  while(isNotComplete)
  {
    isNotComplete = false;                                                // Reset the Local Search flag to false.
    neighborhood = createNeighborhood(bestPosition, bestFitness, alpha);  // Generate the neighborhood.
    neighborhoodFitness = calcFitness(neighborhood);                      // Calculate fitness of neighborhood.
    
    // If the neighborhoodFitness is better than the best fitness,
    // continue the Local Search. Else, Local search is ended.
    if(neighborhoodFitness < bestFitness)
    {
      bestPosition = neighborhood;        // Set the new best position that produced best fitness.
      bestFitness = neighborhoodFitness;  // Set the new best fitness.
      isNotComplete = true;               // Reset the loop flag to true to continue the Local Search.
    }
  }
  
  // Return the newly found best position.
  return bestPosition;
}

// ---------------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------------------------

/**
 *  Create a neghborhood (PVector position) using a firefly's
 *  position, fitness, and a mutation alpha value.
 */
PVector createNeighborhood(PVector ffPosition, float ffFitness, float alpha)
{
  PVector neighborhood;  // PVector to hold the neighborhood.
  float xNeighbor;       // Variable to hold the x coordinate of neighborhood.
  float yNeighbor;       // Variable to hold the y coordinate of neighborhood.
  
  PVector tempPosition;  // PVector to hold a temporary position.
  float tempFitness;     // Variable to hold the fitness of the temporary position.
  
  // Calculate xNeighbor.
  tempPosition = ffPosition;                                       // Create a temporary copy of the firefly's position.
  tempPosition.x += alpha;                                         // Mutate the temp copy x coordinate using alpha.
  tempFitness = calcFitness(tempPosition);                         // Calculate the fitness.
  xNeighbor = ffPosition.x - (alpha * (tempFitness - ffFitness));  // Calculate the xNeighbor.
  
  // Calculate yNeighbor.
  tempPosition = ffPosition;                                       // Create a temporary copy of the firefly's position.
  tempPosition.y += alpha;                                         // Mutate the temp copy y coordinate using alpha.
  tempFitness = calcFitness(tempPosition);                         // Calculate the fitness.
  yNeighbor = ffPosition.y - (alpha * (tempFitness - ffFitness));  // Calculate the yNeighbor.
  
  // Create the neighborhood and return it.
  neighborhood = new PVector(xNeighbor, yNeighbor);
  return neighborhood;
}

// ---------------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------------------------

/**
 *  Calculates the fitness of a PVector based on it's distance from the goal.
 *  The closer to the goal, the smaller the fitness (better).
 *  The farther from the goal, the bigger the fitness (worse).
 */
float calcFitness(PVector position)
{
  return dist(position.x, position.y, goal.x, goal.y);
}
