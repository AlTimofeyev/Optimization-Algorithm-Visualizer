/**
 *  Author:  Al Timofeyev
 *  Date:    June 8, 2019
 *  Desc:    Implementation of a simple particle swarm optimization algorithm within a set of boundaries.
 *           The fitness is dependant on how close each particle is to
 *           the goal; The smaller the distance between goal and particle,
 *           the smaller the fitness value = better fitness.
 *
 *  Version:        2.0
 *  Date Modified:  Al
 *  Modified By:    Oct. 25 2021
 */


/**
 * @class   ParticleSwarmOptimization
 * @brief   Basic implementation of a particle swarm optimization algorithm.
 */
class ParticleSwarmOptimization
{
  // ------------------------------------------------------
  // ----------------------- FIELDS -----------------------
  // ------------------------------------------------------
  // ------ Public ------
  public static final int DEFAULT_POPULATION_SIZE = 1000;                 // Default size of data/population.
  public static final float DEFAULT_DAMPENER_K = 1.5;                     // Default velocity dampener k.
  public static final float DEFAULT_SCALING_FACTOR_PERSONAL_C1 = 0.9;     // Default personal scaling factor c1.
  public static final float DEFAULT_SCALING_FACTOR_GLOBAL_C2 = 0.001256;  // Default global scaling factor c2.
  // ----- Private ------
  private final int populationSize;              // The size of data for optimization algorithm.
  private final float dampener_K;                // Dampens the rate of change of the particles in the population.
  private final float personalScalingFactor_c1;  // Scaling factor brings particle close to it's personal best.
  private final float globalScalingFactor_c2;    // Scaling factor brings particle close to it's global best.
  private Particle[] population;                 // The dataset/population of this optimization algorithm.

  
  // ------------------------------------------------------
  // -------------------- CONSTRUCTORS --------------------
  // ------------------------------------------------------
  /**
   * @brief    Default Constructor
   * @details  Initializes this class object with all default values.
   */
  public ParticleSwarmOptimization()
  {
    this.populationSize = DEFAULT_POPULATION_SIZE;
    this.dampener_K = DEFAULT_DAMPENER_K;
    this.personalScalingFactor_c1 = DEFAULT_SCALING_FACTOR_PERSONAL_C1;
    this.globalScalingFactor_c2 = DEFAULT_SCALING_FACTOR_GLOBAL_C2;
    initializeParticleSwarm();
  }
  
  /**
   * @brief   Constructor 1
   * @details Initializes this class object with a population size and all of the scaling factors.
   *
   * @param populationSize  The size of the population/data.
   * @param k               The data dampener.
   * @param c1              The personal scaling factor.
   * @param c2              The global scaling factor.
   */
  public ParticleSwarmOptimization(int populationSize, float k, float c1, float c2)
  {
    this.populationSize = populationSize;
    this.dampener_K = k;
    this.personalScalingFactor_c1 = c1;
    this.globalScalingFactor_c2 = c2;
    initializeParticleSwarm();
  }

  // ------------------------------------------------------
  // --------------------- FUNCTIONS ----------------------
  // ------------------------------------------------------
  /**
   * @brief   Shows all the elements in the dataset/population on the canvas.
   * @note    This is NOT part of this optimization algorithm, it is only for this example.
   */
  public void show()
  {
    for(Particle element : population)
      element.show();
  }
  
  /**
   * @brief   Checks to see if most of the population has reached the goal.
   * @note    This is NOT part of this optimization algorithm, it is only for this example.
   */
  public boolean mostOfPopReachedGoal()
  {
    // Percentage threshold for elements that have reached the goal.
    float percentageThreshold = 0.25;  // Default set to 25%.
    boolean reached;
    
    // Sum up how many elements have reached the goal.
    int reachedSum = 0;
    for(int i = 0; i < population.length; i++)
    {
      if(population[i].reachedGoal == true)
        reachedSum++;
    }
    
    // Did more than 25% reach their goal?
    reached = float(reachedSum) / population.length > percentageThreshold;
    
    return reached;
  }
  
  /**
   * @brief   Revives the population by setting each element's reachedGoal variable to False so that they can move again.
   * @note    This is NOT part of this optimization algorithm, it is only for this example.
   */
  public void revivePopulation()
  {
    for(Particle element : population)
      element.reachedGoal = false;
  }
  
  /**
   * @brief   Runs the Particle Swarm Optimization algorithm.
   * @details Particle Swarm Optimization operates by continuously updating the dataset/population.
   * @note    Particle Swarm is usually initialized with a integer value dictating the number of iterations the algorithm is supposed to run.
   * @note    For this example, we do not pass it a integer number of iterations to complete because an outside loop (draw() function) will do that for us.
   */
  public void runParticleSwarmOptimization()
  {
    updatePopulation();
  }
  
  /**
   * @brief   Initializes the particle swarm.
   */
  private void initializeParticleSwarm()
  {
    population = new Particle[populationSize];
    for(int index = 0; index < population.length; index++)
    {
      // Create population element, calculate fitness, set it's personal best fitness.
      population[index] = new Particle();
      calculateFitness(population[index]);
      population[index].personalBestFit = population[index].fitness;
    }
    quicksort(population, 0, population.length-1);
    
    // Set the initial global best element in dataset/population.
    population[0].isGlobalBest = true;
  }
  
  /**
   * @brief   Updates the Optimization Algorithm's dataset/population.
   * @details The updating of elements uses the Global best element of dataset/population and all the scaling factors of this algorithm.
   */
  private void updatePopulation()
  {
    // ------------------ Update Dataset/Population -------------------
    for(Particle element : population)   // Update each element in the dataset/population.
    {
      element.updateParticle(population[0], dampener_K, personalScalingFactor_c1, globalScalingFactor_c2);  // Update the element using global best and scaling factors.
      calculateFitness(element);                                                                            // Calculate the fitness after element has been updated.
      
      // Check if the element's personal best has improved.
      if(element.fitness < element.personalBestFit)
      {
        element.personalBestPos = element.position; // Update the personal best position.
        element.personalBestFit = element.fitness;  // Update the personal best fitness.
      }
    }
    
    // ----- Reset the Global Best Element of Dataset/Population ------
    population[0].isGlobalBest = false;
    quicksort(population, 0, population.length-1);
    population[0].isGlobalBest = true;
  }
  
  /**
   * @brief   Calculates the fitness of an element.
   * @details The fitness of an element in the particle swarm is calculated based on its distance from the goal.
   *
   * @param element   The element for which the fitness is being calculated.
   */
  private void calculateFitness(Particle element)
  {
    element.fitness = dist(element.position.x, element.position.y, goal.x, goal.y);
  }
  
  
  // *******************************************************************
  // ******************** QUICKSORT IMPLEMENTATION *********************
  // *******************************************************************
  /**
   * @brief   Sorts the dataset/population in ascending order.
   *
   * @param elements  The dataset/population.
   * @param left      The left index from which to sort (inclusive).
   * @param right     The right index from which to sort (inclusive).
   */
  private void quicksort(Particle[] elements, int left, int right)
  {
    int i, j, mid;
    float pivot;
    i = left;
    j = right;
    mid = left + (right - left) / 2;
    pivot = elements[mid].fitness;
    
    while (i<right || j>left)
    {
      while (elements[i].fitness < pivot)
        i++;
      
      while (elements[j].fitness > pivot)
        j--;
      
      if (i <= j)
      {
        swap(elements, i, j);
        i++;
        j--;
      }
      else
      {
        if (i < right)
          quicksort(elements, i, right);
        if (j > left)
          quicksort(elements, left, j);
        return;
      }
    }
  }
  
  /**
   * @brief   Swap method for the quicksort.
   *
   * @param elements  The dataset/population.
   * @param index1    The first index of element to swap.
   * @param index2    The second index of element to swap.
   */
  private void swap(Particle[] elements, int index1, int index2)
  {
    // Swap the elements in the array.
    Particle tempElement = elements[index1];
    elements[index1] = elements[index2];
    elements[index2] = tempElement;
  }
  // *******************************************************************
  // ****************** QUICKSORT IMPLEMENTATION END *******************
  // *******************************************************************
}
