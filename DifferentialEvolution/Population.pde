/**
 * Author:  Al Timofeyev
 * Date:    August 7, 2020
 * Desc:    
 * 
 * Version:      1.0
 * Modified By:  
 * Modify Date:  
 */

class Population
{
  Dot[] population;  // Population of Dots.

  // ************************************************************************
  // ***************************** CONSTRUCTORS *****************************
  // ************************************************************************

  /**
   * @brief Constructor.
   * Initializes the population of Dots with a specified population size.
   * 
   * @param populationSize The size of the population.
   */
  Population(int populationSize)
  {
    // Create a new population of Dots.
    population = new Dot[populationSize];
    for (int i = 0; i < populationSize; i++)
      population[i] = new Dot();

    // Sort the new population based on fitness.
    quicksort(population, 0, population.length-1);

    // Mark the best Dot.
    population[0].isBest = true;
  }

  // ************************************************************************
  // ******************************* METHODS ********************************
  // ************************************************************************

  /**
   * Shows the Population on the canvas.
   */
  void show()
  {
    // Show each dot in the population on the canvas.
    for (Dot dot : population)
      dot.show();
  }

  // *************************************************************************************

  /**
   * Shows the Population on the canvas.
   */
  void run_Differential_Evolution()
  {
    // For every Dot in the population.
    for (Dot dot : population)
    {
      // Initialize a list of the best Dot and 5 other random Dots.
      Dot[] randDotList = new Dot[6];
      int[] randDotIndexList = new int[6];

      // Save the best Dot first.
      randDotList[0] = population[0].clone();
      randDotIndexList[0] = 0;

      // Choose 5 more random Unique Dots from the population.
      int tempIndex, i = 1;
      boolean found = false;
      while (i < 6)
      {
        // Generate a random index from the population.
        tempIndex = int(random(1, population.length));

        for (int index : randDotIndexList)  // Check all the indices in the list.
        {
          if (tempIndex == index)  // If the index was chosen previously.
          {
            found = true;  // Set found flag.
            break;
          }
        }

        // If the Dot was NOT previously chosen.
        if (found == false)
        {
          randDotList[i] = population[tempIndex].clone();  // Add Dot to list.
          randDotIndexList[i] = tempIndex;                 // Add the Dot's index to list.
          i++;                                             // Increment the counter.
        }

        // Reset the flag to false if it was set to true.
        found = false;
      }

      // Mutate and do Crossover to make one new Dot.
      Dot newDot = mutateAndCrossover(dot.clone(), randDotList);

      // Select function - used as our update function for the Dots in the population.
      // Either moves the old Dot towards the new Dot, or continues moving the old Dot
      // in it's current direction.
      select(dot, newDot);
    }

    // Reset the previous best Dot's isBest flag to false.
    population[0].isBest = false;

    // Sort the new population based on fitness.
    quicksort(population, 0, population.length-1);

    // Mark the new best Dot.
    population[0].isBest = true;
  }

  // *************************************************************************************

  /**
   * @brief Mutate and Crossover produces one new Dot.
   *
   * @note dotList parameter variable has the best Dot at index 0 and 5 random Dots at indices 1 - 5.
   
   * @param currDot The current dot of the population.
   * @param dotList A list of the best Dot and 5 random Dots from the population.
   *
   * @return A new potential Dot of the population.
   */
  Dot mutateAndCrossover(Dot currDot, Dot[] dotList)
  {
    switch(STRATEGY)
    {
    case 1:
      return de_Strategy1(currDot, dotList[0], dotList[2], dotList[3]);
    case 2:
      return de_Strategy2(currDot, dotList[1], dotList[2], dotList[3]);
    case 3:
      return de_Strategy3(currDot, dotList[0], dotList[1], dotList[2]);
    case 4:
      return de_Strategy4(currDot, dotList[0], dotList[1], dotList[2], dotList[3], dotList[4]);
    case 5:
      return de_Strategy5(currDot, dotList[1], dotList[2], dotList[3], dotList[4], dotList[5]);
    case 6:
      return de_Strategy6(currDot, dotList[0], dotList[2], dotList[3]);
    case 7:
      return de_Strategy7(currDot, dotList[1], dotList[2], dotList[3]);
    case 8:
      return de_Strategy8(currDot, dotList[0], dotList[1], dotList[2]);
    case 9:
      return de_Strategy9(currDot, dotList[0], dotList[1], dotList[2], dotList[3], dotList[4]);
    case 10:
      return de_Strategy10(currDot, dotList[1], dotList[2], dotList[3], dotList[4], dotList[5]);
    default:
      print("\n***************************************************************\n");
      print("****************** Strategy " + STRATEGY + " Does Not Exist ******************\n");
      print("***************************************************************\n");
      print("------------------ USING DEFAULT STRATEGY 1 -------------------\n");
      print("***************************************************************\n\n");
      return de_Strategy1(currDot, dotList[0], dotList[2], dotList[3]);
    }
  }

  // *************************************************************************************

  /**
   * @brief Selects a new individual to be part of the next generation.
   * 
   * @note Normally, this function selects a new individual to REPLACE the old individual in the new population, but for this example we will move the old Dot towards the new Dot if the new Dot is better.
   * @note Since we are only moving the dot in this function, this function will be used as our update function for the Dots in the population.
   *
   * @param currDot The original Dot (solution) of the population.
   * @param newDot A new potential Dot (solution) of the population.
   */
  void select(Dot currDot, Dot newDot)
  {
    // Evaluate the new Dot and get it's fitness value.
    newDot.calculateFitness();

    // If the new Dot is better than the original Dot,
    // then move original Dot towards the new Dot.
    // Normally, if the new Dot (solution) was better than the old Dot (solution), we
    // would replace the old Dot (solution) with the new Dot (solution). But for this
    // example, we will only MOVE the old Dot towards the new Dot if the new Dot is better,
    // and not replace the old Dot.
    if (newDot.fitness < currDot.fitness)
      currDot.update(newDot);
    // Otherwise, just move the original Dot in the direction it was going previously.
    else
      currDot.update();

    // Calculate the new fitness.
    currDot.calculateFitness();
  }

  // *************************************************************************************

  /**
   * @brief Prints out the analysis for the Differential Evolution.
   * Prints out the Best Fitness value, the Average Fitness of the population, 
   * the Standard Deviation of fitness values in the poulation, and the range 
   * of fitness values (The best and worst fitness in the population).
   */
  void print_Differential_Evolution_Population_Analysis()
  {
    float averageFitnessOfPopulation;
    float bestFitnessValue, worstFitnessValue;
    float standardDeviation;
    float percentReachedGoal;
    float summedUp;
    int size = population.length;

    // ------------ Calculate Average ------------
    summedUp = 0;
    for (Dot dot : population)
      summedUp += dot.fitness;

    averageFitnessOfPopulation = summedUp / size;

    // ------------ Calculate Standard Deviation ------------
    summedUp = 0;
    for (Dot dot : population)
      summedUp += pow((dot.fitness - averageFitnessOfPopulation), 2);

    standardDeviation = sqrt((1.0/size) * summedUp);

    // ------------ Calculate How Much of Population Reached Goal ------------
    summedUp = 0;
    for (Dot dot : population)
    {
      if (dot.reachedGoal)
        summedUp++;
    }

    percentReachedGoal = (summedUp / size) * 100;

    // ------------ Set Best and Worst Fitness values ------------
    bestFitnessValue = population[0].fitness;
    worstFitnessValue = population[size-1].fitness;

    // ------------ Print Results ------------
    println("*******************************************************************");
    println("*************** ANALYSIS OF DIFFERENTIAL EVOLUTION ****************");
    println("*******************************************************************");
    println("PERCENTAGE OF POPULATION THAT REACHED GOAL:\t\t" + percentReachedGoal + "%");
    println("BEST FITNESS FROM POPULATION:\t\t\t\t" + bestFitnessValue);
    println("AVERAGE FITNESS OF POPULATION:\t\t\t\t" + averageFitnessOfPopulation);
    println("RANGE OF FITNESS VALUES IN POPULATION:\t\t\t" + "[best]: " + bestFitnessValue + "\t[worst]: " + worstFitnessValue);
    println("STANDARD DEVIATION OF FITNESS VALUES IN POPULATION:\t\t" + standardDeviation);
    println("*******************************************************************");
  }

  // *************************************************************************************

  /**
   * @brief Checks to see if most of the population has reached the goal.
   */
  boolean mostOfPopulationReachedGoal()
  {
    int size = population.length;
    boolean reached;

    // Sum up how many particles have reached the goal.
    int reachedSum = 0;
    for (Dot dot : population)
    {
      if (dot.reachedGoal)
        reachedSum++;
    }

    // Did more than 1/4 reach their goal?
    reached = float(reachedSum) / size > 0.25;

    // Return reached.
    return reached;
  }

  // *************************************************************************************

  /**
   * @brief Revives the population.
   * Revives the population by setting each particle's reachedGoal variable
   * to False so that they can move again.
   */
  void revivePopulation()
  {
    for (Dot dot : population)
      dot.reachedGoal = false;
  }

  // ****************************** STRATEGIES ******************************

  /**
   * @brief Strategy 1: DE/best/1/exp.
   *
   * @note bestDot != randDot2 != randDot3 (where "!=" means "not equal to").
   * @note In this context, solution = Dot object.
   * 
   * @param currDot The current solution of the population.
   * @param bestDot The best solution of the population.
   * @param randDot2 A randomly chosen solution from the population.
   * @param randDot3 A randomly chosen solution from the population.
   *
   * @return A new solution (Dot).
   */
  Dot de_Strategy1(Dot currDot, Dot bestDot, Dot randDot2, Dot randDot3)
  {
    // Declare a trial Dot and new solution Dot.
    Dot trialDot = new Dot();
    Dot newSolution;

    // ------------ Perform Mutation -------------
    // Normally, this would be done in a loop for every dimension of the trial Dot, but
    // for this example there are only two dimensions in the trial Dot (x,y) so we
    // don't use a loop for simplicity.
    // Mutation the position of the trial Dot
    trialDot.position.x = bestDot.position.x + F * (randDot2.position.x - randDot3.position.x);
    trialDot.position.y = bestDot.position.y + F * (randDot2.position.y - randDot3.position.y);

    // Generate a random crossover probability in the range of [0, 1).
    float randomCRProbability = random(1);

    // ------------ Perform Crossover ------------
    // Normally, this would be done in a loop for every dimension of a new solution, but
    // for this example there are only two dimensions in the new solution (x,y) so we
    // don't use a loop for simplicity.
    newSolution = currDot.clone();

    if (randomCRProbability < CR_PROBABILITY)
      newSolution.position.x = trialDot.position.x;  // Do crossover on the x coordinate.

    randomCRProbability = random(1);  // Generate another random crossover probability.

    if (randomCRProbability < CR_PROBABILITY)
      newSolution.position.y = trialDot.position.y;  // Do crossover on the y coordinate.

    // Return the new solution.
    return newSolution;
  }

  // *************************************************************************************

  /**
   * @brief Strategy 2: DE/rand/1/exp.
   *
   * @note randDot1 != randDot2 != randDot3 (where "!=" means "not equal to").
   * @note In this context, solution = Dot object.
   * 
   * @param currDot The current solution of the population.
   * @param randDot1 A randomly chosen solution from the population.
   * @param randDot2 A randomly chosen solution from the population.
   * @param randDot3 A randomly chosen solution from the population.
   *
   * @return A new solution (Dot).
   */
  Dot de_Strategy2(Dot currDot, Dot randDot1, Dot randDot2, Dot randDot3)
  {
    // Declare a trial Dot and new solution Dot.
    Dot trialDot = new Dot();
    Dot newSolution;

    // ------------ Perform Mutation -------------
    // Normally, this would be done in a loop for every dimension of the trial Dot, but
    // for this example there are only two dimensions in the trial Dot (x,y) so we
    // don't use a loop for simplicity.
    // Mutation the position of the trial Dot
    trialDot.position.x = randDot1.position.x + F * (randDot2.position.x - randDot3.position.x);
    trialDot.position.y = randDot1.position.y + F * (randDot2.position.y - randDot3.position.y);

    // Generate a random crossover probability in the range of [0, 1).
    float randomCRProbability = random(1);

    // ------------ Perform Crossover ------------
    // Normally, this would be done in a loop for every dimension of a new solution, but
    // for this example there are only two dimensions in the new solution (x,y) so we
    // don't use a loop for simplicity.
    newSolution = currDot.clone();

    if (randomCRProbability < CR_PROBABILITY)
      newSolution.position.x = trialDot.position.x;  // Do crossover on the x coordinate.

    randomCRProbability = random(1);  // Generate another random crossover probability.

    if (randomCRProbability < CR_PROBABILITY)
      newSolution.position.y = trialDot.position.y;  // Do crossover on the y coordinate.

    // Return the new solution.
    return newSolution;
  }

  // *************************************************************************************

  /**
   * @brief Strategy 3: DE/rand-to-best/1/exp.
   *
   * @note bestDot != randDot1 != randDot2 (where "!=" means "not equal to").
   * @note In this context, solution = Dot object.
   * 
   * @param currDot The current solution of the population.
   * @param bestDot The best solution of the population.
   * @param randDot1 A randomly chosen solution from the population.
   * @param randDot2 A randomly chosen solution from the population.
   *
   * @return A new solution (Dot).
   */
  Dot de_Strategy3(Dot currDot, Dot bestDot, Dot randDot1, Dot randDot2)
  {
    // Declare a trial Dot and new solution Dot.
    Dot trialDot = new Dot();
    Dot newSolution;

    // ------------ Perform Mutation -------------
    // Normally, this would be done in a loop for every dimension of the trial Dot, but
    // for this example there are only two dimensions in the trial Dot (x,y) so we
    // don't use a loop for simplicity.
    // Mutation the position of the trial Dot
    trialDot.position.x = currDot.position.x + LAMBDA * (bestDot.position.x - currDot.position.x) + F * (randDot1.position.x - randDot2.position.x);
    trialDot.position.y = currDot.position.y + LAMBDA * (bestDot.position.y - currDot.position.y) + F * (randDot1.position.y - randDot2.position.y);

    // Generate a random crossover probability in the range of [0, 1).
    float randomCRProbability = random(1);

    // ------------ Perform Crossover ------------
    // Normally, this would be done in a loop for every dimension of a new solution, but
    // for this example there are only two dimensions in the new solution (x,y) so we
    // don't use a loop for simplicity.
    newSolution = currDot.clone();

    if (randomCRProbability < CR_PROBABILITY)
      newSolution.position.x = trialDot.position.x;  // Do crossover on the x coordinate.

    randomCRProbability = random(1);  // Generate another random crossover probability.

    if (randomCRProbability < CR_PROBABILITY)
      newSolution.position.y = trialDot.position.y;  // Do crossover on the y coordinate.

    // Return the new solution.
    return newSolution;
  }

  // *************************************************************************************

  /**
   * @brief Strategy 4: DE/best/2/exp.
   *
   * @note bestDot != randDot1 != randDot2 != randDot3 != randDot4 (where "!=" means "not equal to").
   * @note In this context, solution = Dot object.
   * 
   * @param currDot The current solution of the population.
   * @param bestDot The best solution of the population.
   * @param randDot1 A randomly chosen solution from the population.
   * @param randDot2 A randomly chosen solution from the population.
   * @param randDot3 A randomly chosen solution from the population.
   * @param randDot4 A randomly chosen solution from the population.
   *
   * @return A new solution (Dot).
   */
  Dot de_Strategy4(Dot currDot, Dot bestDot, Dot randDot1, Dot randDot2, Dot randDot3, Dot randDot4)
  {
    // Declare a trial Dot and new solution Dot.
    Dot trialDot = new Dot();
    Dot newSolution;

    // ------------ Perform Mutation -------------
    // Normally, this would be done in a loop for every dimension of the trial Dot, but
    // for this example there are only two dimensions in the trial Dot (x,y) so we
    // don't use a loop for simplicity.
    // Mutation the position of the trial Dot
    trialDot.position.x = bestDot.position.x + F * (randDot1.position.x + randDot2.position.x - randDot3.position.x - randDot4.position.x);
    trialDot.position.y = bestDot.position.y + F * (randDot1.position.y + randDot2.position.y - randDot3.position.y - randDot4.position.y);

    // Generate a random crossover probability in the range of [0, 1).
    float randomCRProbability = random(1);

    // ------------ Perform Crossover ------------
    // Normally, this would be done in a loop for every dimension of a new solution, but
    // for this example there are only two dimensions in the new solution (x,y) so we
    // don't use a loop for simplicity.
    newSolution = currDot.clone();

    if (randomCRProbability < CR_PROBABILITY)
      newSolution.position.x = trialDot.position.x;  // Do crossover on the x coordinate.

    randomCRProbability = random(1);  // Generate another random crossover probability.

    if (randomCRProbability < CR_PROBABILITY)
      newSolution.position.y = trialDot.position.y;  // Do crossover on the y coordinate.

    // Return the new solution.
    return newSolution;
  }

  // *************************************************************************************

  /**
   * @brief Strategy 5: DE/rand/2/exp.
   *
   * @note randDot1 != randDot2 != randDot3 != randDot4 != randDot5 (where "!=" means "not equal to").
   * @note In this context, solution = Dot object.
   * 
   * @param currDot The current solution of the population.
   * @param randDot1 A randomly chosen solution from the population.
   * @param randDot2 A randomly chosen solution from the population.
   * @param randDot3 A randomly chosen solution from the population.
   * @param randDot4 A randomly chosen solution from the population.
   * @param randDot5 A randomly chosen solution from the population.
   *
   * @return A new solution (Dot).
   */
  Dot de_Strategy5(Dot currDot, Dot randDot1, Dot randDot2, Dot randDot3, Dot randDot4, Dot randDot5)
  {
    // Declare a trial Dot and new solution Dot.
    Dot trialDot = new Dot();
    Dot newSolution;

    // ------------ Perform Mutation -------------
    // Normally, this would be done in a loop for every dimension of the trial Dot, but
    // for this example there are only two dimensions in the trial Dot (x,y) so we
    // don't use a loop for simplicity.
    // Mutation the position of the trial Dot
    trialDot.position.x = randDot5.position.x + F * (randDot1.position.x + randDot2.position.x - randDot3.position.x - randDot4.position.x);
    trialDot.position.y = randDot5.position.y + F * (randDot1.position.y + randDot2.position.y - randDot3.position.y - randDot4.position.y);

    // Generate a random crossover probability in the range of [0, 1).
    float randomCRProbability = random(1);

    // ------------ Perform Crossover ------------
    // Normally, this would be done in a loop for every dimension of a new solution, but
    // for this example there are only two dimensions in the new solution (x,y) so we
    // don't use a loop for simplicity.
    newSolution = currDot.clone();

    if (randomCRProbability < CR_PROBABILITY)
      newSolution.position.x = trialDot.position.x;  // Do crossover on the x coordinate.

    randomCRProbability = random(1);  // Generate another random crossover probability.

    if (randomCRProbability < CR_PROBABILITY)
      newSolution.position.y = trialDot.position.y;  // Do crossover on the y coordinate.

    // Return the new solution.
    return newSolution;
  }

  // *************************************************************************************

  /**
   * @brief Strategy 6: DE/best/1/bin.
   *
   * @note bestDot != randDot2 != randDot3 (where "!=" means "not equal to").
   * @note In this context, solution = Dot object.
   * 
   * @param currDot The current solution of the population.
   * @param bestDot The best solution of the population.
   * @param randDot2 A randomly chosen solution from the population.
   * @param randDot3 A randomly chosen solution from the population.
   *
   * @return A new solution (Dot).
   */
  Dot de_Strategy6(Dot currDot, Dot bestDot, Dot randDot2, Dot randDot3)
  {
    // Declare a trial Dot and new solution Dot.
    Dot trialDot = new Dot();
    Dot newSolution;

    // ------------ Perform Mutation -------------
    // Normally, this would be done in a loop for every dimension of the trial Dot, but
    // for this example there are only two dimensions in the trial Dot (x,y) so we
    // don't use a loop for simplicity.
    // Mutation the position of the trial Dot
    trialDot.position.x = bestDot.position.x + F * (randDot2.position.x - randDot3.position.x);
    trialDot.position.y = bestDot.position.y + F * (randDot2.position.y - randDot3.position.y);

    // Generate a random index whithin range of the size of the position PVector.
    int randomIndex = int(random(2));  // In this case: 0 = x coordinate, 1 = y coordinate.

    // Generate a random crossover probability in the range of [0, 1).
    float randomCRProbability = random(1);

    // ------------ Perform Crossover ------------
    // Normally, this would be done in a loop for every dimension of a new solution, but
    // for this example there are only two dimensions in the new solution (x,y) so we
    // don't use a loop for simplicity.
    newSolution = currDot.clone();

    if (randomCRProbability < CR_PROBABILITY || randomIndex == 0)
      newSolution.position.x = trialDot.position.x;  // Do crossover on the x coordinate.

    randomCRProbability = random(1);  // Generate another random crossover probability.

    if (randomCRProbability < CR_PROBABILITY || randomIndex == 1)
      newSolution.position.y = trialDot.position.y;  // Do crossover on the y coordinate.

    // Return the new solution.
    return newSolution;
  }

  // *************************************************************************************

  /**
   * @brief Strategy 7: DE/rand/1/bin.
   *
   * @note randDot1 != randDot2 != randDot3 (where "!=" means "not equal to").
   * @note In this context, solution = Dot object.
   * 
   * @param currDot The current solution of the population.
   * @param randDot1 A randomly chosen solution from the population.
   * @param randDot2 A randomly chosen solution from the population.
   * @param randDot3 A randomly chosen solution from the population.
   *
   * @return A new solution (Dot).
   */
  Dot de_Strategy7(Dot currDot, Dot randDot1, Dot randDot2, Dot randDot3)
  {
    // Declare a trial Dot and new solution Dot.
    Dot trialDot = new Dot();
    Dot newSolution;

    // ------------ Perform Mutation -------------
    // Normally, this would be done in a loop for every dimension of the trial Dot, but
    // for this example there are only two dimensions in the trial Dot (x,y) so we
    // don't use a loop for simplicity.
    // Mutation the position of the trial Dot
    trialDot.position.x = randDot1.position.x + F * (randDot2.position.x - randDot3.position.x);
    trialDot.position.y = randDot1.position.y + F * (randDot2.position.y - randDot3.position.y);

    // Generate a random index whithin range of the size of the position PVector.
    int randomIndex = int(random(2));  // In this case: 0 = x coordinate, 1 = y coordinate.

    // Generate a random crossover probability in the range of [0, 1).
    float randomCRProbability = random(1);

    // ------------ Perform Crossover ------------
    // Normally, this would be done in a loop for every dimension of a new solution, but
    // for this example there are only two dimensions in the new solution (x,y) so we
    // don't use a loop for simplicity.
    newSolution = currDot.clone();

    if (randomCRProbability < CR_PROBABILITY || randomIndex == 0)
      newSolution.position.x = trialDot.position.x;  // Do crossover on the x coordinate.

    randomCRProbability = random(1);  // Generate another random crossover probability.

    if (randomCRProbability < CR_PROBABILITY || randomIndex == 1)
      newSolution.position.y = trialDot.position.y;  // Do crossover on the y coordinate.

    // Return the new solution.
    return newSolution;
  }

  // *************************************************************************************

  /**
   * @brief Strategy 8: DE/rand-to-best/1/bin.
   *
   * @note bestDot != randDot1 != randDot2 (where "!=" means "not equal to").
   * @note In this context, solution = Dot object.
   * 
   * @param currDot The current solution of the population.
   * @param bestDot The best solution of the population.
   * @param randDot1 A randomly chosen solution from the population.
   * @param randDot2 A randomly chosen solution from the population.
   *
   * @return A new solution (Dot).
   */
  Dot de_Strategy8(Dot currDot, Dot bestDot, Dot randDot1, Dot randDot2)
  {
    // Declare a trial Dot and new solution Dot.
    Dot trialDot = new Dot();
    Dot newSolution;

    // ------------ Perform Mutation -------------
    // Normally, this would be done in a loop for every dimension of the trial Dot, but
    // for this example there are only two dimensions in the trial Dot (x,y) so we
    // don't use a loop for simplicity.
    // Mutation the position of the trial Dot
    trialDot.position.x = currDot.position.x + LAMBDA * (bestDot.position.x - currDot.position.x) + F * (randDot1.position.x - randDot2.position.x);
    trialDot.position.y = currDot.position.y + LAMBDA * (bestDot.position.y - currDot.position.y) + F * (randDot1.position.y - randDot2.position.y);

    // Generate a random index whithin range of the size of the position PVector.
    int randomIndex = int(random(2));  // In this case: 0 = x coordinate, 1 = y coordinate.

    // Generate a random crossover probability in the range of [0, 1).
    float randomCRProbability = random(1);

    // ------------ Perform Crossover ------------
    // Normally, this would be done in a loop for every dimension of a new solution, but
    // for this example there are only two dimensions in the new solution (x,y) so we
    // don't use a loop for simplicity.
    newSolution = currDot.clone();

    if (randomCRProbability < CR_PROBABILITY || randomIndex == 0)
      newSolution.position.x = trialDot.position.x;  // Do crossover on the x coordinate.

    randomCRProbability = random(1);  // Generate another random crossover probability.

    if (randomCRProbability < CR_PROBABILITY || randomIndex == 1)
      newSolution.position.y = trialDot.position.y;  // Do crossover on the y coordinate.

    // Return the new solution.
    return newSolution;
  }

  // *************************************************************************************

  /**
   * @brief Strategy 9: DE/best/2/bin.
   *
   * @note bestDot != randDot1 != randDot2 != randDot3 != randDot4 (where "!=" means "not equal to").
   * @note In this context, solution = Dot object.
   * 
   * @param currDot The current solution of the population.
   * @param bestDot The best solution of the population.
   * @param randDot1 A randomly chosen solution from the population.
   * @param randDot2 A randomly chosen solution from the population.
   * @param randDot3 A randomly chosen solution from the population.
   * @param randDot4 A randomly chosen solution from the population.
   *
   * @return A new solution (Dot).
   */
  Dot de_Strategy9(Dot currDot, Dot bestDot, Dot randDot1, Dot randDot2, Dot randDot3, Dot randDot4)
  {
    // Declare a trial Dot and new solution Dot.
    Dot trialDot = new Dot();
    Dot newSolution;

    // ------------ Perform Mutation -------------
    // Normally, this would be done in a loop for every dimension of the trial Dot, but
    // for this example there are only two dimensions in the trial Dot (x,y) so we
    // don't use a loop for simplicity.
    // Mutation the position of the trial Dot
    trialDot.position.x = bestDot.position.x + F * (randDot1.position.x + randDot2.position.x - randDot3.position.x - randDot4.position.x);
    trialDot.position.y = bestDot.position.y + F * (randDot1.position.y + randDot2.position.y - randDot3.position.y - randDot4.position.y);

    // Generate a random index whithin range of the size of the position PVector.
    int randomIndex = int(random(2));  // In this case: 0 = x coordinate, 1 = y coordinate.

    // Generate a random crossover probability in the range of [0, 1).
    float randomCRProbability = random(1);

    // ------------ Perform Crossover ------------
    // Normally, this would be done in a loop for every dimension of a new solution, but
    // for this example there are only two dimensions in the new solution (x,y) so we
    // don't use a loop for simplicity.
    newSolution = currDot.clone();

    if (randomCRProbability < CR_PROBABILITY || randomIndex == 0)
      newSolution.position.x = trialDot.position.x;  // Do crossover on the x coordinate.

    randomCRProbability = random(1);  // Generate another random crossover probability.

    if (randomCRProbability < CR_PROBABILITY || randomIndex == 1)
      newSolution.position.y = trialDot.position.y;  // Do crossover on the y coordinate.

    // Return the new solution.
    return newSolution;
  }

  // *************************************************************************************

  /**
   * @brief Strategy 10: DE/rand/2/bin.
   *
   * @note randDot1 != randDot2 != randDot3 != randDot4 != randDot5 (where "!=" means "not equal to").
   * @note In this context, solution = Dot object.
   * 
   * @param currDot The current solution of the population.
   * @param randDot1 A randomly chosen solution from the population.
   * @param randDot2 A randomly chosen solution from the population.
   * @param randDot3 A randomly chosen solution from the population.
   * @param randDot4 A randomly chosen solution from the population.
   * @param randDot5 A randomly chosen solution from the population.
   *
   * @return A new solution (Dot).
   */
  Dot de_Strategy10(Dot currDot, Dot randDot1, Dot randDot2, Dot randDot3, Dot randDot4, Dot randDot5)
  {
    // Declare a trial Dot and new solution Dot.
    Dot trialDot = new Dot();
    Dot newSolution;

    // ------------ Perform Mutation -------------
    // Normally, this would be done in a loop for every dimension of the trial Dot, but
    // for this example there are only two dimensions in the trial Dot (x,y) so we
    // don't use a loop for simplicity.
    // Mutation the position of the trial Dot
    trialDot.position.x = randDot5.position.x + F * (randDot1.position.x + randDot2.position.x - randDot3.position.x - randDot4.position.x);
    trialDot.position.y = randDot5.position.y + F * (randDot1.position.y + randDot2.position.y - randDot3.position.y - randDot4.position.y);

    // Generate a random index whithin range of the size of the position PVector.
    int randomIndex = int(random(2));  // In this case: 0 = x coordinate, 1 = y coordinate.

    // Generate a random crossover probability in the range of [0, 1).
    float randomCRProbability = random(1);

    // ------------ Perform Crossover ------------
    // Normally, this would be done in a loop for every dimension of a new solution, but
    // for this example there are only two dimensions in the new solution (x,y) so we
    // don't use a loop for simplicity.
    newSolution = currDot.clone();

    if (randomCRProbability < CR_PROBABILITY || randomIndex == 0)
      newSolution.position.x = trialDot.position.x;  // Do crossover on the x coordinate.

    randomCRProbability = random(1);  // Generate another random crossover probability.

    if (randomCRProbability < CR_PROBABILITY || randomIndex == 1)
      newSolution.position.y = trialDot.position.y;  // Do crossover on the y coordinate.

    // Return the new solution.
    return newSolution;
  }

  // *************************************************************************************
  // *************************************************************************************

  /**
   * A Quicksort implementation for a Dot array based on their fitness.
   *
   * @note Sorted in Ascending Order.
   *
   * @param dots  The array of Dots.
   * @param start  The starting index of Dots for the quicksort (inclusive).
   * @param end    The ending index of Dots for the quicksort (inclusive).
   */
  void quicksort(Dot[] dots, int start, int end)
  {
    int leftIndex = start;
    int rightIndex = end;
    int mid = start + (end - start) / 2;

    float pivot = dots[mid].fitness;

    while (leftIndex < end || rightIndex > start)
    {
      // Ignore all the numbers greater than pivot to the left.
      while (dots[leftIndex].fitness < pivot)    // Change it to > for Descending Order.
        leftIndex++;

      // Ignore all the numbers less than pivot to the right.
      while (dots[rightIndex].fitness > pivot)   // Change it to < for Descending Order.
        rightIndex--;

      if (leftIndex <= rightIndex)
      {
        swap(dots, leftIndex, rightIndex);
        leftIndex++;
        rightIndex--;
      } else
      {
        if (leftIndex < end)
          quicksort(dots, leftIndex, end);
        if (rightIndex > start)
          quicksort(dots, start, rightIndex);
        return;
      }
    }
  }

  /**
   * Swaps two values of a Dot array.
   *
   * @param dots    The array of Dots.
   * @param index1  The 1st index of the Dots for the swap.
   * @param index2  The 2nd index of the Dots for the swap.
   */
  void swap(Dot[] dots, int index1, int index2)
  {
    Dot temp = dots[index1];
    dots[index1] = dots[index2];
    dots[index2] = temp;
  }
}
