/*
 *  Author:  Al Timofeyev
 *  Date:    June 13, 2019
 *  Desc:    The Firefly population.
 *           The fitness is dependant on how close each firefly is to
 *           the goal; the smaller the distance between goal and firefly,
 *           the smaller the fitness value = better fitness.
 *
 *  Version:      1.0
 *  Modified By:  
 *  Modify Date:  
*/


class Population
{
  Firefly[] fireflies;  // Population of Fireflies.
  
  float alpha;          // Scaling factor of Firefly Algorithm.
  float beta0;          // Scaling factor of Firefly Algorithm.
  float gamma;          // Scaling factor of Firefly Algorithm.
  
  // ---------------------- Construrctor ----------------------
  /**
   *  Default Population Constructor.
   *  Only takes the population size, and the three scaling
   *  factors: alpha, beta0, and gamma.
   */
  Population(int popSize, float alpha, float beta0, float gamma)
  {
    // Assign the scaling factors.
    this.alpha = alpha;
    this.beta0 = beta0;
    this.gamma = gamma;
    
    // Initialize the population.
    fireflies = new Firefly[popSize];
    for(int i = 0; i < fireflies.length; i++)
      fireflies[i] = new Firefly();
      
    // Sort the population based on fitness.
    quicksort(fireflies, 0, fireflies.length-1);
    
    // Set the global best.
    fireflies[0].isGlobalBest = true;
  }
  
  /**
   *  Secondary Population Constructor.
   *  Takes the population size, best firefly size, and the three scaling
   *  factors: alpha, beta0, and gamma.
   */
  Population(int popSize, float alpha, float beta0, float gamma, int bestFireflySize)
  {
    // Assign the scaling factors.
    this.alpha = alpha;
    this.beta0 = beta0;
    this.gamma = gamma;
    
    // Initialize the population.
    fireflies = new Firefly[popSize];
    for(int i = 0; i < fireflies.length; i++)
      fireflies[i] = new Firefly(bestFireflySize);
      
    // Sort the population based on fitness.
    quicksort(fireflies, 0, fireflies.length-1);
    
    // Set the global best.
    fireflies[0].isGlobalBest = true;
  }
  
  /**
   *  Third Population Constructor.
   *  Takes the population size, firefly size, best firefly size, and
   *  the three scaling factors: alpha, beta0, and gamma.
   */
  Population(int popSize, float alpha, float beta0, float gamma, int fireflySize, int bestFireflySize)
  {
    // Assign the scaling factors.
    this.alpha = alpha;
    this.beta0 = beta0;
    this.gamma = gamma;
    
    // Initialize the population.
    fireflies = new Firefly[popSize];
    for(int i = 0; i < fireflies.length; i++)
      fireflies[i] = new Firefly(fireflySize, bestFireflySize);
      
    // Sort the population based on fitness.
    quicksort(fireflies, 0, fireflies.length-1);
    
    // Set the global best.
    fireflies[0].isGlobalBest = true;
  }
  
  // ----------------------- Functions ------------------------
  /**
   *  Shows all the fireflies in the population on the canvas.
   */
  void show()
  {
    for(int i = 0; i < fireflies.length; i++)
    {
      fireflies[i].show();
    }
  }
  
  /**
   *  Updates the firefly population.
   */
  void updatePopulation()
  {
    // Update all fireflies.
    for(int i = 0; i < fireflies.length; i++)
      updateFireflies(i);
    
    // Reset the current global best to false..
    fireflies[0].isGlobalBest = false;
    
    // Sort the population based on fitness.
    quicksort(fireflies, 0, fireflies.length-1);
    
    // Set the new global best.
    fireflies[0].isGlobalBest = true;
  }
  
  /**
   *  Updates all fireflies that are less brighter than the firefly
   *  that is at <index>.
   */
  void updateFireflies(int index)
  {
    float r;                    // Holds the distance between the main firefly at <index> and all other fireflies.
    double lightIntensityMain;   // Holds the light intensity of main firefly at <index>.
    double lightIntensity2;      // Holds the light intensity of firefly at index i.
    
    // Move all fireflies that are less brighter than firefly at <index>.
    for(int i = 0; i < fireflies.length; i++)
    {      
      r = fireflies[index].calcDistance(fireflies[i]);                      // Calculate the distance between fireflies.
      lightIntensityMain = fireflies[index].calcLightIntensity(gamma, r);   // Caclulate light intensity of main firefly.
      lightIntensity2 = fireflies[i].calcLightIntensity(gamma, r);          // Calculate light intensity of firefly at index i.
      
      // If firefly is less brighter than the main firefly.
      if(lightIntensity2 > lightIntensityMain)
        fireflies[i].updateFirefly(fireflies[index], alpha, beta0, gamma, r);  // Move firefly towards main firefly (update it).
    }
  }
  
  
  // *******************************************************************
  // ******************** QUICKSORT IMPLEMENTATION *********************
  // *******************************************************************
  /**
   *  Sorts the population in ascending order.
   */
  void quicksort(Firefly[] fFly, int L, int R)
  {
    int i, j, mid;
    float pivot;
    i = L;
    j = R;
    mid = L + (R - L) / 2;
    pivot = fFly[mid].fitness;
    
    while (i<R || j>L)
    {
      while (fFly[i].fitness < pivot)
        i++;
      
      while (fFly[j].fitness > pivot)
        j--;
      
      if (i <= j)
      {
        swap(fFly, i, j);
        i++;
        j--;
      }
      else
      {
        if (i < R)
          quicksort(fFly, i, R);
        if (j > L)
          quicksort(fFly, L, j);
        return;
      }
    }
  }
 
  void swap(Firefly[] fFly, int l, int r)
  {
    // Swap the fireflies in the array.
    Firefly tempFirefly = fFly[l];
    fFly[l] = fFly[r];
    fFly[r] = tempFirefly;
  }
}
