/** //<>// //<>//
 * Author:  Al Timofeyev
 * Date:    July 28, 2020
 */

class Population
{
  Dot[] population;       // Set of dots in this population.
  float fitnessSum = 0;   // Sum of all the dots' fitness in this population.
  int generation = 1;     // The generation of this population.
  int stepsToTake = 500;  // The number of times each dot can move.

  // ************************************************************************
  // ***************************** CONSTRUCTORS *****************************
  // ************************************************************************

  /**
   * Default Constructor
   */
  Population()
  {
    population = new Dot[500];
    for (int i = 0; i < population.length; i++)
    {
      population[i] = new Dot(stepsToTake);
    }
  }

  // *************************************************************************************

  /**
   * Overloading the default constructor
   * @param size  The size of the population.
   */
  Population(int size)
  {
    population = new Dot[size];
    for (int i = 0; i < population.length; i++)
    {
      population[i] = new Dot(stepsToTake);
    }
  }

  // *************************************************************************************

  /**
   * Overloading the default constructor
   * @param size  The size of the population.
   * @param numOfSteps  The number of steps a dot can take.
   */
  Population(int size, int numOfSteps)
  {
    stepsToTake = numOfSteps;
    population = new Dot[size];
    for (int i = 0; i < population.length; i++)
    {
      population[i] = new Dot(stepsToTake);
    }
  }

  // ************************************************************************
  // ******************************* METHODS ********************************
  // ************************************************************************

  /**
   * Shows the Population on the canvas.
   */
  void show()
  {
    for (int i = 0; i < population.length; i++)
    {
      population[i].show();
    }
  }

  // *************************************************************************************

  /**
   * Updates each dot in the population.
   */
  void update()
  {
    for (Dot dot : population)  // For each dot in the population.
      dot.update();  // Update the dot.
  }

  // *************************************************************************************

  /**
   * Checks to see if the population has died off.
   */
  boolean isPopulationDead()
  {
    for (Dot dot : population)  // For each dot in the population.
    {
      // If at least one dot isn't dead, return false.
      if (!dot.dead && !dot.reachedGoal)
      {
        return false;
      }
    }

    // Otherwise, all dots are dead or have reached the goal, return true.
    return true;
  }

  // *************************************************************************************

  /**
   * @brief Run The Genetic Algorithm.
   * Makes calls to calculate the fitness of each dot in the population, Selects parents, 
   * performs Crossover using the parents to create new children for the next population, 
   * Mutates the children, and then reduces and creates new population, making sure the 
   * best Dot from the previous generation of the population survives to the new population.
   */
  void run_Genetic_Algorithm()
  {
    // Calculate the fitness of each Dot in the current population.
    calculateFitness();

    // Calculate the fitness sum of the current population.
    calculateFitnessSum();

    // Find and save the Dot with the best fitness from the current population.
    Dot bestDot = findBestDot();

    // Initialize the new population of Dots.
    ArrayList<Dot> newPopulation = new ArrayList<Dot>();

    // Generate the new population from the old population.
    for (int i = 0; i < population.length; i += 2)
    { 
      // Select two parents from current population.
      int[] parentIndex = selectTwoParents();

      // Perform Crossover using the parents to get the children.
      Dot[] children = crossover(population[parentIndex[0]].clone(), population[parentIndex[1]].clone());

      // Mutate and add children to population.
      for (Dot child : children)
      {
        child.mutate();            // Mutate child.
        newPopulation.add(child);  // Add child to new population.
      }
    }

    // Reduce and combine the (overpopulated) new population with the old population
    // to make the next generation of Dots.
    reduceAndCombine(newPopulation);

    // Make sure the best dot from the previous population survives to the next population.
    population[0] = bestDot;

    // Update the generation of the population.
    generation++;
  }

  // *************************************************************************************

  /**
   * Calculate the fitness of each dot in the population.
   */
  void calculateFitness()
  {
    for (Dot dot : population)  // For each dot in the population.
      dot.calculateFitness();   // Calculate fitness.
  }

  // *************************************************************************************

  /**
   * Calculate the sum of all fitness values in the population.
   */
  void calculateFitnessSum()
  {
    fitnessSum = 0;
    for (Dot dot : population)    // For each dot in the population.
      fitnessSum += dot.fitness;  // Add the dot's fitness to the fitness sum.
  }

  // *************************************************************************************

  /**
   * Selects two parents from the population.
   * @return An array with the index of two parents.
   */
  int[] selectTwoParents()
  {
    int[] parents = new int[2];
    for (int i = 0; i < parents.length; i++)
    {
      switch(selectionType)
      {
      case 1:
        parents[i] = tournament_Selection();
        break;
      case 2:
        parents[i] = roulette_Wheel_Selection();
        break;
      default:
        parents[i] = roulette_Wheel_Selection();
        break;
      }
    }

    return parents;
  }

  // *************************************************************************************

  /**
   * Uses Tournament Selection to select one parent from population.
   * @return The index of the parent in the population.
   */
  int tournament_Selection()
  {
    // Set the tournament size. (Cannot exceed population size or be smaller than 1)
    int tournamentSize = population.length/2;

    Dot[] tournamentList = new Dot[tournamentSize];       // Keeps track of the dot in the population.
    int[] tournamentIndexList = new int[tournamentSize];  // Keeps track of the index of the dot in the population.

    // Select the specified number of individuals for the tournament.
    for (int i = 0, index; i < tournamentSize; i++)
    {
      index = int(random(population.length));  // Generate random index in range [0, population size).
      tournamentIndexList[i] = index;          // Save the index of the Dot that was generated.
      tournamentList[i] = population[index];   // Save the Dot at that index.
    }

    // Set the initial values for the (best) parent Dot and its index.
    int parentIndex = tournamentIndexList[0];
    Dot parentDot = tournamentList[0];

    // Select best (minimum) fitness from tournament.
    for (int i = 1; i < tournamentList.length; i++)
    {
      // If the next fitness in the tournament is better than the current one.
      if (tournamentList[i].fitness > parentDot.fitness)
      {
        parentIndex = tournamentIndexList[i];  // Update the parent Index.
        parentDot = tournamentList[i];         // Update the parent Fitness.
      }
    }

    return parentIndex;  // Return the index of the parent.
  }

  // *************************************************************************************

  /**
   * Uses Roulette Wheel Selection to select one parent from population.
   * @return The index of the parent in the population.
   */
  int roulette_Wheel_Selection()
  {
    // Calculate the probability of each dot's fitness value in the population.
    float[] probabilities = new float[population.length];
    float probability;
    for (int i = 0; i < population.length; i++)
    {
      probability = population[i].fitness / fitnessSum;
      probabilities[i] = probability;
    }

    // Generate a random probability between [0, 1).
    double randProbability = random(1);

    // Start Roulette Wheel Selection.
    double probabilitySum = 0;
    int parentIndex = 0;
    for (int i = 0; i < probabilities.length; i = ((i+1) % probabilities.length))
    {
      // Add probability to probability sum.
      probabilitySum += probabilities[i];

      // The first probability found that makes probabilitySum greater
      // than the random probability gets chosen as the parent.
      if (probabilitySum > randProbability)
      {
        parentIndex = i;  // Update parent index.
        break;            // Only leave the loop once parentIndex is found.
      }
    }

    return parentIndex;  // Return the index of the parent.
  }

  // *************************************************************************************

  /**
   * Returns two children that are a crossover of the parents using 1 crossover point.
   *
   * @param parent1  The first parent.
   * @param parent2  The second parent.
   *
   * @return  Returns two children that are a crossover of the parents.
   */
  Dot[] crossover(Dot parent1, Dot parent2)
  {
    // Declare the children.
    // For this example, the children will be the same as their respective parent by default.
    Dot[] children = new Dot[2];
    Dot child1 = parent1.clone();
    Dot child2 = parent2.clone();

    // Generate a random crossover probability in the range of [0, 1).
    float randomCRProbability = random(1);

    int crIndex;  // Declare a crossover index.

    // If the random crossover probability is less than the initial crossover probability.
    if (randomCRProbability < crProbability)
    {
      crIndex = int(random(stepsToTake));  // Assign a crossover index.

      // Copy the second half of each parent to the opposite child.
      for (int i = crIndex; i < stepsToTake; i++)
      {
        child1.directions[i] = parent2.directions[i].copy();  // 2nd half of parent2 goes to child1.
        child2.directions[i] = parent1.directions[i].copy();  // 2nd half of parent1 goes to child2.
      }
    }

    // Add the two children to the list.
    children[0] = child1;
    children[1] = child2;

    return children;  // Return the two children.
  }

  // *************************************************************************************

  /**
   * Reduces new population and combines it with the old one.
   * @param newPopulation The new population.
   */
  void reduceAndCombine(ArrayList<Dot> newPopulation)
  {
    // Sort the old populations based on fitness.
    quicksort(population, 0, population.length-1);

    // Set the Elite Index using the Elitism Rate.
    int eliteIndex = int(elitismRate * population.length);

    // Make sure some of the best Dots from the old population survive to the new population.
    // DON'T REPLACE ANYTHING YET!!
    for (int i = 0; i < eliteIndex; i++)
      newPopulation.add(population[i]);

    // Sort the new populations based on fitness.
    quicksort(newPopulation, 0, newPopulation.size()-1);

    // Replace the old population with the new population, except for
    // the very first Dot, which is the best from the old population.
    for (int i = 1, j = 0; i < population.length; i++, j++)
      population[i] = newPopulation.get(j).clone();
  }

  // *************************************************************************************

  /**
   * Finds and returns the best dot in the population.
   */
  Dot findBestDot()
  {
    Dot bestDot;

    float tempFitness = 0;     // Holds a temporary fitness value.
    int bestFitnessIndex = 0;  // Holds the index of the Dot with the best fitness in the population.

    // Find the index of the best Dot in the population.
    for (int i = 0; i < population.length; i++)
    {
      if (population[i].fitness > tempFitness)
      {
        tempFitness = population[i].fitness;
        bestFitnessIndex = i;
      }
    }

    // Save the best Dot by making a clone of it.
    bestDot = population[bestFitnessIndex].clone();
    bestDot.isBest = true;
    bestDot.fitness = population[bestFitnessIndex].fitness;

    // Print the generation and the steps taken by the best Dot in population.
    println("Generation: " + generation + "\tSteps: " + population[bestFitnessIndex].stepsTaken + "\t\tBest Fitness: " + population[bestFitnessIndex].fitness);

    return bestDot;
  }

  // *************************************************************************************
  // *************************************************************************************

  /**
   * A Quicksort implementation for a Dot array based on their fitness.
   *
   * @note Sorted in Descending Order.
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
      while (dots[leftIndex].fitness > pivot)    // Change it to < for Ascending Order.
        leftIndex++;

      // Ignore all the numbers less than pivot to the right.
      while (dots[rightIndex].fitness < pivot)   // Change it to > for Ascending Order.
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

  // *************************************************************************************
  // *************************************************************************************

  /**
   * A Quicksort implementation for a Dot ArrayList based on their fitness.
   *
   * @note Sorted in Descending Order.
   *
   * @param dots  The ArrayList of Dots.
   * @param start  The starting index of Dots for the quicksort (inclusive).
   * @param end    The ending index of Dots for the quicksort (inclusive).
   */
  void quicksort(ArrayList<Dot> dots, int start, int end)
  {
    int leftIndex = start;
    int rightIndex = end;
    int mid = start + (end - start) / 2;

    float pivot = dots.get(mid).fitness;

    while (leftIndex < end || rightIndex > start)
    {
      // Ignore all the numbers greater than pivot to the left.
      while (dots.get(leftIndex).fitness > pivot)    // Change it to < for Ascending Order.
        leftIndex++;

      // Ignore all the numbers less than pivot to the right.
      while (dots.get(rightIndex).fitness < pivot)   // Change it to > for Ascending Order.
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
  void swap(ArrayList<Dot> dots, int index1, int index2)
  {
    Dot temp = dots.get(index1);
    dots.set(index1, dots.get(index2));
    dots.set(index2, temp);
  }
}
