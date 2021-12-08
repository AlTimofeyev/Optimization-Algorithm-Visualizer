/**
 * Copyright © 2021 Al Timofeyev. All rights reserved.
 * @author  Al Timofeyev
 * @date    October 23, 2021
 * @brief   A Button class for the Optimization Algorithm Visualizer Desktop Application.
 *
 * @version 1.0
 * Modified By:
 * Modified Date:
 * *********************************************************/

class Button
{
  // ------------------------------------------------------
  // ----------------------- FIELDS -----------------------
  // ------------------------------------------------------
  // ----- Private ------
  private final color BUTTON_STATIC_COLOR = color(220, 225, 220);    
  private final color BUTTON_HOVER_COLOR =  color(205, 240, 205);
  private final color BUTTON_ACTIVE_COLOR = color(200, 255, 200);
  private final color BUTTON_ACTIVE_HOVER_COLOR = color(180, 255, 180);
  private final float BTN_PADDING = 20.0;
  private final float BTN_RADII = 60.0;
  
  private final Lable BTN_LABLE;  // The name on the button.
  private final float BTN_X;         // The starting x-coordinate position of button.
  private final float BTN_Y;         // The starting y-coordinate position of button.
  private final boolean DEFINED_BY_LABLE;
  
  private color btnColor;      // The color of the button.
  private float btnWidth;  // The width of the button.
  private float btnHeight;  // The height of the button.
  private float btnRadii;
  private boolean isPressable;    // Toggle flag for if the button is pressable or not.
  private boolean hoverActive;    // Toggle flag for button hover event.
  private boolean isClicked;      // Toggle flag for button click event.
  
  //private float btnPadding;
  
  
  // ------------------------------------------------------
  // -------------------- CONSTRUCTORS --------------------
  // ------------------------------------------------------
  public Button(String lable, float x, float y, float buttonWidth, float buttonHeight)
  {
    BTN_LABLE = new Lable(lable, x, y);
    BTN_X = x;
    BTN_Y = y;
    btnWidth = buttonWidth;
    btnHeight = buttonHeight;
    DEFINED_BY_LABLE = false;
    
    btnColor = BUTTON_STATIC_COLOR;
    btnRadii = BTN_RADII;
    hoverActive = false;
    isClicked = false;
    isPressable = true;
    
    BTN_LABLE.setLableCenter(BTN_X + btnWidth/2, BTN_Y + btnHeight/2);
  }
  
  public Button(String lable, float x, float y)
  {
    BTN_LABLE = new Lable(lable, x, y);
    BTN_X = BTN_LABLE.LBL_X;
    BTN_Y = BTN_LABLE.LBL_Y;
    btnWidth = BTN_LABLE.getTextWidth() + BTN_PADDING;
    btnHeight = BTN_LABLE.getTextHeight() + BTN_PADDING;
    DEFINED_BY_LABLE = true;
    
    btnColor = BUTTON_STATIC_COLOR;
    btnRadii = BTN_RADII;
    hoverActive = false;
    isClicked = false;
    isPressable = true;
    
    BTN_LABLE.setLableCenter(BTN_X + btnWidth/2, BTN_Y + btnHeight/2);
  }
  
  public Button(Lable lable)
  {
    BTN_LABLE = lable;
    BTN_X = BTN_LABLE.LBL_X;
    BTN_Y = BTN_LABLE.LBL_Y;
    btnWidth = BTN_LABLE.getTextWidth() + BTN_PADDING;
    btnHeight = BTN_LABLE.getTextHeight() + BTN_PADDING;
    DEFINED_BY_LABLE = true;
    
    btnColor = BUTTON_STATIC_COLOR;
    btnRadii = BTN_RADII;
    hoverActive = false;
    isClicked = false;
    isPressable = true;
    
    BTN_LABLE.setLableCenter(BTN_X + btnWidth/2, BTN_Y + btnHeight/2);
  }
  
  // ------------------------------------------------------
  // ---------------------- METHODS -----------------------
  // ------------------------------------------------------
  public void drawButton()
  {
    updateButton();
    
    if(isClicked && hoverActive)
      btnColor = BUTTON_ACTIVE_HOVER_COLOR;
    else if(isClicked)
      btnColor = BUTTON_ACTIVE_COLOR;
    else if(hoverActive)
      btnColor = BUTTON_HOVER_COLOR;
    else
      btnColor = BUTTON_STATIC_COLOR;
    
    // Draw button and lable.
    fill (btnColor);
    stroke(0);
    strokeWeight(0);
    rect(BTN_X, BTN_Y, btnWidth, btnHeight, btnRadii);
    BTN_LABLE.drawLable();
  }
  
  public void updateButton()
  {
    if(!isPressable)  // If it's not pressable.
      return;
    
    hoverActive = isHoverActive();
  }
  
  public boolean isHoverActive()
  {
    if(mouseX >= BTN_X && mouseX <= BTN_X + btnWidth && mouseY >= BTN_Y && mouseY <= BTN_Y + btnHeight)
      return true;
    else
      return false;
  }
  
  public boolean isButtonClicked()
  {
    return isClicked;
  }
  
  public void togglePressable()
  {
    isPressable = !isPressable;
  }
  
  public void pressEvent()
  {
    if(!isPressable)  // If the button isn't pressable, don't do anything.
      return;
    
    if(hoverActive && isPressable)
      isClicked = !isClicked; 
  }
  
  public void setFontSize(int newFontSize)
  {
    BTN_LABLE.setFontSize(newFontSize);
    
    if(DEFINED_BY_LABLE)
    {
      btnWidth = BTN_LABLE.getTextWidth() + BTN_PADDING;
      btnHeight = BTN_LABLE.getTextHeight() + BTN_PADDING;
    }
    BTN_LABLE.setLableCenter(BTN_X + btnWidth/2, BTN_Y + btnHeight/2);
  }
  
  public void setFontColor(color newFontColor)
  {
    BTN_LABLE.setFontColor(newFontColor);
  }
  
  public Lable getBtnLable()
  {
    return BTN_LABLE;
  }
  
  public String getBtnText()
  {
    return BTN_LABLE.getLableText();
  }
  
  public PVector getBtnOrigin()
  {
    return new PVector(BTN_X, BTN_Y);
  }
  
  public float getBtnX()
  {
    return BTN_X;
  }
  
  public float getBtnY()
  {
    return BTN_Y;
  }
  
  public float getBtnWidth()
  {
    return btnWidth;
  }
  
  public float getBtnHeight()
  {
    return btnHeight;
  }
}
