/**
 * Copyright © 2021 Al Timofeyev. All rights reserved.
 * @author  Al Timofeyev
 * @date    September 17, 2021
 * @brief   Optimization Algorithm Visualizer Desktop Application.
 * @details  A desktop application for visualizing basic optimization algorithms for help with visual learning.
 *
 * @version 1.0
 * Modified By:
 * Modified Date:
 * *********************************************************/

import optimizationalgorithms.library.*;
 
OptimizationAlgorithm algorithm;
int algorithmType = -1;
boolean algorithmSelected = false;
PVector goal;
int goalSize = 15;

Lable lable;
Lable lable2;
ValueLable vLable;
Button button;
Button button2;
Button button3;
Slider slider;
Slider slider2;
Slider slider3;
float i = 0;

void setup()
{
  size(800, 800); 
  //size(displayWidth, displayHeight);
  surface.setTitle("Optimization Algorithm Visualizer");
  surface.setResizable(true);  // Makes canvas user-resizable and changes height/width.
  //surface.setLocation(100, 100);  // Set location where window opens.
  
  lable = new Lable("TEXINGTON a BUNCH", 20, 20);
  lable2 = new Lable("Test", width/2, height/3);
  vLable = new ValueLable(34534.2, 50, 50);
  button = new Button("Test", width/2, height/2, 50, 30);
  button2 = new Button(lable2);
  //button2.setFontSize(60);
  button3 = new Button(lable);
  slider = new Slider(button, -10, 10);
  slider2 = new Slider(button2, -10, 10);
  slider3 = new Slider(false, "Testron and nova", 50, height-200, 100, 50, -10, 10);
  //button2.togglePressable();
  slider2.toggleSlidable();
}

void draw()
{
  background(100);  // Set canvas background color.
  
  stroke(0);
  line(width/2, button.BTN_Y+button.getBtnHeight(), slider.sliderValueLable.LBL_X + slider.sliderValueLable.textWidth, button.BTN_Y+button.getBtnHeight());
  vLable.drawValueLable();
  //button.drawButton();
  button3.drawButton();
  //button.setFontSize(60);
  slider2.setFontSize(60);
  slider.drawSlider();
  slider2.drawSlider();
  slider3.drawSlider();
  slider3.setWidthHeight(200, 30);
  //slider3.setFontSize(100);
  //slider3.setFontSize(80);
  //slider.setFontSize(60);
  
  //switch(algorithmType)
  //{
  //  case 1:
  //    run_ParticleSwarmOptimization_Example();
  //    break;
  //  default:
  //    run_ParticleSwarmOptimization_Example();
  //    break;
  //}
}


void mousePressed()
{
  //button.pressEvent();
  //button2.pressEvent();
  button3.pressEvent();
  slider.pressEvent();
  slider2.pressEvent();
  slider3.pressEvent();
}

void mouseReleased()
{
  slider.releaseEvent();
  slider2.releaseEvent();
  slider3.releaseEvent();
}

void mouseMoved()
{
}

void mouseDragged()
{
}


//void mouseClicked()
//{
//  if(button.hoverOverButton())
//    button.buttonClicked();
//}

void run_ParticleSwarmOptimization_Example()
{
  if(!algorithmSelected)  // If this algorithm hasn't been set yet.
  {
    algorithmSelected = true;
    goal = getNewGoal();
    algorithm = new ParticleSwarmOptimization(this, goal, goalSize);
  }
  
  // This is for if the window is resized during runtime.
  if(goal.x > width || goal.x < 0 || goal.y > height || goal.y < 0)
  {
    goal = getNewGoal();
    ((ParticleSwarmOptimization)algorithm).setGoal(goal);
    ((ParticleSwarmOptimization)algorithm).revivePopulation();
  }
  
  // Change goal and revive the population if more than 1/4 the population
  // has reached the goal within 350 iterations.
  if(frameCount > 350 && ((ParticleSwarmOptimization)algorithm).mostOfPopReachedGoal())
  {
    goal = getNewGoal();
    ((ParticleSwarmOptimization)algorithm).setGoal(goal);
    ((ParticleSwarmOptimization)algorithm).revivePopulation();
  }
  else if(frameCount%500 == 0)  // Change goal if population hasn't reached the goal every 500 iterations.
  {
    goal = getNewGoal();
    ((ParticleSwarmOptimization)algorithm).setGoal(goal);
    ((ParticleSwarmOptimization)algorithm).revivePopulation();
  }
  
  background(255);  // Set canvas background color.
  
  // Set the fill color and size of the goal.
  fill(255, 0, 0);
  ellipse(goal.x, goal.y, goalSize, goalSize);
  
  ((ParticleSwarmOptimization)algorithm).runParticleSwarmOptimization();
  ((ParticleSwarmOptimization)algorithm).show();  // Have to cast it to the child class due to polymorphism.
}

// Returns a new Goal PVector within window limits.
PVector getNewGoal()
{
  // Get two random values between [0,1].
  float rand1 = random(1);
  float rand2 = random(1);
  
  // Normalize the two random values to within the bounds.
  float x = 0 + rand1*(width - 0);
  float y = 0 + rand2*(height - 0);
  
  // Return a new PVector with the x and y coordinates.
  return new PVector(x, y);
}
