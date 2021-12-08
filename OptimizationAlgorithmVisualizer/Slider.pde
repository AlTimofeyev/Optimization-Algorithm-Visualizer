/**
 * Copyright © 2021 Al Timofeyev. All rights reserved.
 * @author  Al Timofeyev
 * @date    October 27, 2021
 * @brief   A Slider class for the Optimization Algorithm Visualizer Desktop Application.
 *
 * @version 1.0
 * Modified By:
 * Modified Date:
 * *********************************************************/

class Slider
{
  // ------------------------------------------------------
  // ----------------------- FIELDS -----------------------
  // ------------------------------------------------------
  // ----- Private ------
  private final color SLIDER_STATIC_COLOR = color(200, 255, 200, 100);
  private final color SLIDER_ACTIVE_COLOR = color(180, 255, 180);
  private final color HANDLE_STATIC_COLOR = color(75, 130, 75);
  private final color HANDLE_HOVER_COLOR = color(105, 205, 105);
  private final color HANDLE_ACTIVE_COLOR = color(125, 255, 125);
  private final float DEFAULT_SLIDER_WIDTH = 150.0;
  private final float DEFAULT_SLIDER_HEIGHT = 15.0;
  private final float ELEMENT_PADDING = 10.0;
  private final float SLIDER_RADII = 60.0;
  
  private final boolean HAS_BUTTON;        // Toggle flag for if this slider has a button or not.
  private final boolean HAS_LABLE;
  private final float SLIDER_ORIGIN_X;    // Origin x-coordinate of all slider elements.
  private final float SLIDER_ORIGIN_Y;    // Origin y-coordinate fo all slider elements.
  private final float SLIDER_LOWER_BOUND;  // The minimum value the slider can display.
  private final float SLIDER_UPPER_BOUND;  // The maximum value the slider can display.
  
  private Lable sliderLable;       // The name on the slider
  private ValueLable sliderValueLable;
  private Button sliderButton;
  private boolean isSlidable;            // Toggle flag for if the slider is slidable or not.
  private boolean hoverActive;           // Toggle flag for slider hover event.
  private boolean isPressed;             // Toggle flag for slider handle pressed event.
  private boolean isLocked;              // Toggle flag for when slider is being dragged.
  private float sliderX;              // The starting x-coordinate position of slider.
  private float sliderY;              // The starting y-coordinate position of slider.
  private float sliderWidth;          // The width of the slider.
  private float sliderHeight;         // The height of the slider.
  private float sliderRadii;
  private float handleSize;           // The size of the handle used to move the slider.
  private float handleRadius;         // The radius of the handle used to move the slider.
  private float stretch;
  private float handleX;
  private float handleY;
  private color handleColor;
  
  
  
  
  
  // ------------------------------------------------------
  // -------------------- CONSTRUCTORS --------------------
  // ------------------------------------------------------
  //public Slider(boolean hasButton, String lable, float x, float y, float sldrWidth, float lowerBound, float upperBound)
  //{
  //  HAS_BUTTON = hasButton;
  //  HAS_LABLE = true;
  //  SLIDER_ORIGIN_X = x;
  //  SLIDER_ORIGIN_Y = y;
  //  SLIDER_LOWER_BOUND = lowerBound;
  //  SLIDER_UPPER_BOUND = upperBound;
    
  //  if(HAS_BUTTON)
  //    init_ButtonSlider(lable, x, y, sldrWidth);
  //  else
  //    init_LableSlider(lable, x, y, sldrWidth);
    
  //  //  DEFINE SLIDER ORIGIN POINT AND USE SLIDER ORIGIN INSTEAD OF BTN X, BTN Y, LABLE X, LABLE Y *******************************************************************
  //  sliderValueLable = new ValueLable(0, sliderX+sliderWidth+ELEMENT_PADDING, SLIDER_ORIGIN_Y);
  //  updateSliderValue();
  //}
  
  
  // Blank slider
  public Slider(float x, float y, float sldrWidth, float sldrHeight, float lowerBound, float upperBound)
  {
    HAS_BUTTON = false;
    HAS_LABLE = false;
    SLIDER_ORIGIN_X = x;
    SLIDER_ORIGIN_Y = y;
    SLIDER_LOWER_BOUND = lowerBound;
    SLIDER_UPPER_BOUND = upperBound;
    
    isSlidable = true;
    hoverActive = false;
    isPressed = false;
    isLocked = false;
    
    sliderX = x;
    sliderY = y;
    sliderWidth = sldrWidth;
    sliderHeight = sldrHeight;
    handleSize = sliderHeight;
    handleRadius = handleSize / 2;
    
    stretch = 0.0;
    handleX = sliderX + handleRadius + stretch;
    handleY = sliderY + handleRadius;
    handleColor = HANDLE_STATIC_COLOR;
    
    sliderValueLable = new ValueLable(0, 0, 0);
    sliderValueLable = new ValueLable(0, sliderX+sliderWidth+ELEMENT_PADDING, sliderY+(sliderHeight/2)-(sliderValueLable.getLableHeight()/2));
    updateSliderValue();
  }
  
  // Normal slider
  public Slider(boolean hasButton, String lable, float x, float y, float sldrWidth, float sldrHeight, float lowerBound, float upperBound)
  {
    HAS_BUTTON = hasButton;
    HAS_LABLE = !HAS_BUTTON;
    SLIDER_ORIGIN_X = x;
    SLIDER_ORIGIN_Y = y;
    SLIDER_LOWER_BOUND = lowerBound;
    SLIDER_UPPER_BOUND = upperBound;
    sliderWidth = sldrWidth;
    sliderHeight = sldrHeight;
    
    if(HAS_BUTTON)
      init_ButtonSlider(lable, x, y);
    else
      init_LableSlider(lable, x, y);
    
    sliderValueLable = new ValueLable(0, 0, 0);
    sliderValueLable = new ValueLable(0, sliderX+sliderWidth+ELEMENT_PADDING, sliderY+(sliderHeight/2)-(sliderValueLable.getLableHeight()/2));
    updateSliderValue();
  }
  
  // Lable slider.
  public Slider(Lable lable, float lowerBound, float upperBound)
  {
    HAS_BUTTON = false;
    HAS_LABLE = true;
    SLIDER_ORIGIN_X = lable.getLblX();
    SLIDER_ORIGIN_Y = lable.getLblY();
    SLIDER_LOWER_BOUND = lowerBound;
    SLIDER_UPPER_BOUND = upperBound;
    
    isSlidable = true;
    hoverActive = false;
    isPressed = false;
    isLocked = false;
    
    sliderLable = lable;
    sliderWidth = DEFAULT_SLIDER_WIDTH;
    sliderHeight = DEFAULT_SLIDER_HEIGHT;
    sliderX = sliderLable.getLblX() + sliderLable.getTextWidth() + ELEMENT_PADDING;
    sliderY = sliderLable.getLblY() + sliderHeight/2;
    handleSize = sliderHeight;
    handleRadius = handleSize / 2;
    
    stretch = 0.0;
    handleX = sliderX + handleRadius + stretch;
    handleY = sliderY + handleRadius;
    handleColor = HANDLE_STATIC_COLOR;
    
    sliderValueLable = new ValueLable(0, 0, 0);  // This is a dummy ValueLable to help retrieve the width/height of ValueLable.
    sliderValueLable = new ValueLable(0, sliderX+sliderWidth+ELEMENT_PADDING, sliderY+(sliderHeight/2)-(sliderValueLable.getLableHeight()/2));
    updateSliderValue();
  }
  
  // Button slider
  public Slider(Button button, float lowerBound, float upperBound)
  {
    HAS_BUTTON = true;
    HAS_LABLE = false;
    SLIDER_ORIGIN_X = button.getBtnX();
    SLIDER_ORIGIN_Y = button.getBtnY();
    SLIDER_LOWER_BOUND = lowerBound;
    SLIDER_UPPER_BOUND = upperBound;
    
    isSlidable = button.isButtonClicked();
    hoverActive = false;
    isPressed = false;
    isLocked = false;
    
    sliderButton = button;
    sliderWidth = DEFAULT_SLIDER_WIDTH;
    sliderHeight = DEFAULT_SLIDER_HEIGHT;
    sliderX = sliderButton.getBtnX() + sliderButton.getBtnWidth() + ELEMENT_PADDING;
    sliderY = sliderButton.getBtnY() + sliderHeight/2;
    handleSize = sliderHeight;
    handleRadius = handleSize / 2;
    
    stretch = 0.0;
    handleX = sliderX + handleRadius + stretch;
    handleY = sliderY + handleRadius;
    handleColor = HANDLE_STATIC_COLOR;
    
    sliderValueLable = new ValueLable(0, 0, 0);  // This is a dummy ValueLable to help retrieve the width/height of ValueLable.
    sliderValueLable = new ValueLable(0, sliderX+sliderWidth+ELEMENT_PADDING, sliderY+(sliderHeight/2)-(sliderValueLable.getLableHeight()/2));
    updateSliderValue();
  }
  
  
  // ------------------------------------------------------
  // ---------------------- METHODS -----------------------
  // ------------------------------------------------------
  public void drawSlider()
  {
    updateSlider();

    // Slider lable.
    if(HAS_BUTTON)
      sliderButton.drawButton();
    else
      sliderLable.drawLable();
    
    // Slider Static section.
    fill(SLIDER_STATIC_COLOR);
    stroke(255);
    rect(sliderX, sliderY, sliderWidth, sliderHeight, SLIDER_RADII);
    
    // Slider Active section.
    fill(SLIDER_ACTIVE_COLOR);
    stroke(255);
    rect(sliderX, sliderY, handleRadius+stretch, sliderHeight, SLIDER_RADII, 0, 0 ,SLIDER_RADII);
    
    // Slider handle.
    if (isPressed )
      handleColor = HANDLE_ACTIVE_COLOR;
    else if(hoverActive)
      handleColor = HANDLE_HOVER_COLOR;
    else
      handleColor = HANDLE_STATIC_COLOR;
    
    fill(handleColor);
    stroke(255);
    ellipse(handleX, handleY, handleSize, handleSize);
    
    sliderValueLable.drawValueLable();
    // delete these circles later, this is debugging.
    //fill(255, 0, 0);
    //ellipse(sliderLable.LBL_X, sliderLable.LBL_Y, 5, 5);
  }
  
  public void updateSlider()
  {
    if(!isSlidable || isLocked)  // If it's not slidable.
      return;
    
    if (isHovering())
      hoverActive = true;
    else
      hoverActive = false;
  
    if(isPressed)
    {
      stretch = min(max(mouseX-sliderX-handleRadius, 0), sliderWidth-handleSize);
      handleX = sliderX + handleRadius + stretch;
      updateSliderValue();
    }
  }
  
  public void updateSliderValue()
  {
    // I am normalizing the slider's handleX coordinate location to the upper and lower bound of slider.
    // Normalizing a value to a given range [lower, upper], use the following equation:
    // Nomalized_Value = (upper - lower) * ( (valueX - minX) / (maxX - minX) ) + lower
    float sliderValue = (SLIDER_UPPER_BOUND - SLIDER_LOWER_BOUND) * ( (handleX - (sliderX+handleRadius)) / ((sliderX+sliderWidth-handleRadius)-(sliderX+handleRadius)) ) + SLIDER_LOWER_BOUND;
    sliderValueLable.setValue(sliderValue);
  }
  
  public boolean isHovering()
  {
    float distFromCenter = abs( dist(handleX, handleY, mouseX, mouseY) );
    if(distFromCenter <= handleRadius)
      return true;
    else
      return false;
  }
  
  public boolean isSliderSlidable()
  {
    return isSlidable;
  }
  
  public void toggleSlidable()
  {
    isSlidable = !isSlidable;
    
    if(HAS_BUTTON)
      sliderButton.togglePressable();
  }
  
  public void pressEvent()
  {
    if(HAS_BUTTON)
    {//is button pressable?????????????????????????????????????????????????????????
      sliderButton.pressEvent();
      isSlidable = sliderButton.isButtonClicked();
    }
      
    if(!isSlidable)  // If it's not slidable.
      return;
    
    if(hoverActive)
    {
      cursor(HAND);
      isPressed = true;
      //isLocked = false;  // not sure if this is needed yet but it works without this.
    }
    else
      isLocked = true;
  }
  
  public void releaseEvent()
  {
    cursor(ARROW);
    isPressed = false;
    isLocked = false;
  }
  
  public void setFontSize(int newFontSize)
  {
    if(HAS_BUTTON)
      sliderButton.setFontSize(newFontSize);
    else if(HAS_LABLE)
      sliderLable.setFontSize(newFontSize);
    
    resetSliderElements();
  }
  
  public void setFontColor(color newFontColor)
  {
    if(HAS_BUTTON)
      sliderButton.setFontColor(newFontColor);
    else
      sliderLable.setFontColor(newFontColor);
  }
  
  public void setWidthHeight(float sldrWidth, float sldrHeight)
  {
    sliderWidth = sldrWidth;
    sliderHeight = sldrHeight;
    
    resetSliderElements();
    updateSliderValue();
  }
  
  private void init_LableSlider(String lable, float x, float y)
  {
    isSlidable = true;
    hoverActive = false;
    isPressed = false;
    isLocked = false;
    
    sliderLable = new Lable(lable, x, y);
    sliderX = sliderLable.getLblX() + sliderLable.getTextWidth() + ELEMENT_PADDING;
    sliderY = sliderLable.getLblY() + sliderLable.getTextHeight()/2 - sliderHeight/2;
    handleSize = sliderHeight;
    handleRadius = handleSize / 2;
    
    stretch = 0.0;
    handleX = sliderX + handleRadius + stretch;
    handleY = sliderY + handleRadius;
    handleColor = HANDLE_STATIC_COLOR;
  }
  
  private void init_ButtonSlider(String lable, float x, float y)
  {
    isSlidable = false;
    hoverActive = false;
    isPressed = false;
    isLocked = false;
    
    sliderButton = new Button(new Lable(lable, x, y));
    sliderX = sliderButton.getBtnX() + sliderButton.getBtnWidth() + ELEMENT_PADDING;
    sliderY = sliderButton.getBtnY() + sliderButton.getBtnHeight()/2 - sliderHeight/2;
    handleSize = sliderHeight;
    handleRadius = handleSize / 2;
    
    stretch = 0.0;
    handleX = sliderX + handleRadius + stretch;
    handleY = sliderY + handleRadius;
    handleColor = HANDLE_STATIC_COLOR;
  }
  
  private void resetSliderElements()
  {
    if(HAS_BUTTON)
    {
      sliderX = sliderButton.getBtnX() + sliderButton.getBtnWidth() + ELEMENT_PADDING;
      sliderY = sliderButton.getBtnY() + sliderButton.getBtnHeight()/2 - sliderHeight/2;
    }
    else if(HAS_LABLE)
    {
      sliderX = sliderLable.LBL_X + sliderLable.getTextWidth() + ELEMENT_PADDING;
      sliderY = sliderLable.LBL_Y + sliderLable.getTextHeight()/2 - sliderHeight/2;
    }
    
    handleSize = sliderHeight;
    handleRadius = handleSize / 2;
    handleX = sliderX + handleRadius + stretch;
    handleY = sliderY + handleRadius;
    
    // Center the value lable to the center of the slider.
    sliderValueLable = new ValueLable(sliderValueLable.getValue(), sliderX+sliderWidth+ELEMENT_PADDING, sliderY+(sliderHeight/2)-(sliderValueLable.getLableHeight()/2));
  }
}
