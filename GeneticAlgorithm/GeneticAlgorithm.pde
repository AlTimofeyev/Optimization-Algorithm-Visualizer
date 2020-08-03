/**
 * Author:  Al Timofeyev
 * Date:    Jul 22, 2020
 * Desc:    Example of a simple Genetic Algorithm. Please refer to the README.txt file
 *          for explanations on what the changable variable are and what they do.
 *
 * Version:      1.0
 * Modified By:  
 * Modify Date:  
 */


Population population;  // The population of dots.
PVector goal;           // The goal vector of the Genetic Algorithm.
ArrayList<Wall> walls = new ArrayList<Wall>();  // List of obstacles (walls).

// ********************************************************************************
// ******************* CHANGE THESE TO CONTROL GENETIC ALGORITHM ******************
// ********************************************************************************
int goalSize = 15;      // The size of the goal.

int popSize = 1500;     // The size of the population.
int numOfMoves = 1000;  // The number of times each dot in population can move towards the goal before "dying".
int selectionType = 2;  // The type of selection to use to select a new generations. (1 = Tournament Selection, 2 = Roulette Wheel Selection)
float crProbability = 0.8;         // The probability of a crossover between 2 parents in the population, in the range of [0, 1).
float mutationProbability = 0.01;  // The probability of a mutation of a Dot's directions happening, in the range of [0, 1).
float elitismRate = 0.2;           // The elitism rate used to save a percentage of the old population, in the range of [0, 1).
// ********************************************************************************
// ********************************************************************************

void setup()
{
  size(800, 800);  // Size of the canvas is 800 by 800 (x, y).
  goal = new PVector(width/2, 10);  // Set a goal for the Genetic Algorithm.
  
  // Create as many walls as you would like and add them to the list.
  // NOTE: Coordinate system starts at Top Left corner of screen (0,0)
  // and ends at Bottom Right corner of screen (width, height).
  // EXAMPLE: Wall(topLeft_X, topLeft_Y, topRight_X, topRight_Y, bottomRight_X, bottomRight_Y, bottomLeft_X, bottomLeft_Y)
  walls.add(new Wall(150, 300, 400, 300, 400, 350, 150, 350));
  walls.add(new Wall(300, 600, width-100, 600, width-100, 650, 300, 650));
  walls.add(new Wall(350, 100, 400, 100, 400, 500, 350, 500));
  walls.add(new Wall(width/2, 325, width-250, 325, width-250, 375, width/2, 375));
  walls.add(new Wall(450, 200, width, 200, width, 250, 450, 250));
  walls.add(new Wall(0, height/2+50, 300, height/2+50, 300, height/2+100, 0, height/2+100));
  walls.add(new Wall(250, 50, 300, 50, 300, 100, 250, 100));
  walls.add(new Wall(425, 75, 475, 75, 475, 125, 425, 125));

  //population = new Population();
  //population = new Population(popSize);
  population = new Population(popSize, numOfMoves);
}


void draw()
{
  background(255);  // Set canvas background color.
  
  for(Wall wall : walls)  // Show all the walls.
    shape(wall.wall);

  // Set the fill color and size of the goal.
  fill(255, 0, 0);
  ellipse(goal.x, goal.y, goalSize, goalSize);
  
  // If all Dots in the population are dead, start the genetic algorithm.
  if (population.isPopulationDead())
  {
    population.run_Genetic_Algorithm();
  }
  else
  {
    population.update();
    population.show();
  }
}
