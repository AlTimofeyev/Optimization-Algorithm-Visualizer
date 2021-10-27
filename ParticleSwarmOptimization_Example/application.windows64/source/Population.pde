/**
 *  Author:  Al Timofeyev
 *  Date:    June 8, 2019
 *  Desc:    The Particle Swarm population.
 *           The fitness is dependant on how close each particle is to
 *           the goal; the smaller the distance between goal and particle,
 *           the smaller the fitness value = better fitness.
 *
 *  Version:        1.0
 *  Date Modified:
 *  Modified By:    
 */


class Population
{
  Particle[] particles;  // Population of particles.
  
  float c1;              // Scaling factor to bring particle closer to personal best.
  float c2;              // Scaling factor to bring particle closer to global best.
  float k;               // Velocity Dampening factor.
  
  // ---------------------- Construrctor ----------------------
  Population(int size, float k, float c1, float c2)
  {
    // Assign the scaling/dampening factors.
    this.c1 = c1;
    this.c2 = c2;
    this.k = k;
    
    // Initialize the particles.
    particles = new Particle[size];
    for(int i = 0; i < particles.length; i++)
      particles[i] = new Particle();
    
    // Sort the population based on fitness.
    quicksort(particles, 0, particles.length-1);
    
    // Set the global best.
    particles[0].isGlobalBest = true;
  }
  
  // ----------------------- Functions ------------------------
  /**
   *  Shows all the particles in the population on the canvas.
   */
  void show()
  {
    for(int i = 0; i < particles.length; i++)
    {
      particles[i].show();
    }
  }
  
  /**
   *  Update all the particles in the population and check the global best.
   */
  void updatePopulation()
  {
    // Update each particle's position.
    for(int i = 0; i < particles.length; i++)
      particles[i].updateParticle(particles[0].position, k, c1, c2);
    
    // Reset the global best to false.
    particles[0].isGlobalBest = false;
    
    // Sort the population based on fitness.
    quicksort(particles, 0, particles.length-1);
    
    // Set the global best.
    particles[0].isGlobalBest = true;
  }
  
  /**
   *  Checks to see if most of the population has reached the goal.
   */
  boolean mostOfPopReachedGoal()
  {
    boolean reached;
    
    // Sum up how many particles have reached the goal.
    int reachedSum = 0;
    for(int i = 0; i < particles.length; i++)
    {
      if(particles[i].reachedGoal == true)
        reachedSum++;
    }
    
    // Did more than 1/4 reach their goal?
    reached = float(reachedSum) / particles.length > 0.25;
    
    // Return reached.
    return reached;
  }
  
  /**
   *  Revives the population by setting each particle's reachedGoal variable
   *  to False so that they can move again.
   */
  void revivePopulation()
  {
    for(int i = 0; i < particles.length; i++)
      particles[i].reachedGoal = false;
  }
  
  // *******************************************************************
  // ******************** QUICKSORT IMPLEMENTATION *********************
  // *******************************************************************
  /**
   *  Sorts the population in ascending order.
   */
  void quicksort(Particle[] parti, int L, int R)
  {
    int i, j, mid;
    float pivot;
    i = L;
    j = R;
    mid = L + (R - L) / 2;
    pivot = parti[mid].fitness;
    
    while (i<R || j>L)
    {
      while (parti[i].fitness < pivot)
        i++;
      
      while (parti[j].fitness > pivot)
        j--;
      
      if (i <= j)
      {
        swap(parti, i, j);
        i++;
        j--;
      }
      else
      {
        if (i < R)
          quicksort(parti, i, R);
        if (j > L)
          quicksort(parti, L, j);
        return;
      }
    }
  }
 
  void swap(Particle[] parti, int l, int r)
  {
    // Swap the particles in the array.
    Particle tempParticle = parti[l];
    parti[l] = parti[r];
    parti[r] = tempParticle;
  }
}
