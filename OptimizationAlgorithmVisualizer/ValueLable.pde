/**
 * Copyright © 2021 Al Timofeyev. All rights reserved.
 * @author  Al Timofeyev
 * @date    November 5, 2021
 * @brief   A Value Lable class for the Optimization Algorithm Visualizer Desktop Application.
 *
 * @version 1.0
 * Modified By:
 * Modified Date:
 * *********************************************************/
 
class ValueLable
{
  // ------------------------------------------------------
  // ----------------------- FIELDS -----------------------
  // ------------------------------------------------------
  // ----- Private ------
  private final color FONT_COLOR = color(0);  // Default font color.
  private final int FONT_SIZE = 12;           // Default font size.
  private final float LBL_PADDING = 15.0;
  private final float RADII = 60.0;
  
  private final float LBL_X;   // The starting x-coordinate position of lable.
  private final float LBL_Y;   // The starting y-coordinate position of lable.
  
  private String valueLable;  // The value on the lable
  private float value;
  private float lblCenterX;  // The center x-coordinate position of lable.
  private float lblCenterY;  // The center y-coordinate position of lable.
  private float textWidth;   // Width of text based on text size.
  private float textHeight;  // Height of text based on text size.
  private float lableWidth;
  private float lableHeight;
  private color fontColor;   // Font color.
  private int fontSize;      // Font size.
  
  
  // ------------------------------------------------------
  // -------------------- CONSTRUCTORS --------------------
  // ------------------------------------------------------
  public ValueLable(float lableValue, float x, float y)
  {
    fontColor = FONT_COLOR;
    fontSize = FONT_SIZE;
    
    value = lableValue;
    valueLable = str(lableValue);
    
    textSize(fontSize);  // This is for textWidth/Height and lable center x/y.
    textWidth = textWidth(valueLable);
    textHeight = textAscent() + textDescent();
    lableWidth = textWidth + LBL_PADDING;
    lableHeight = textHeight + LBL_PADDING;
    
    LBL_X = x;
    LBL_Y = y;
    lblCenterX = LBL_X + lableWidth / 2.0;
    lblCenterY = LBL_Y + lableHeight / 2.0;
  }
  
  
  // ------------------------------------------------------
  // ---------------------- METHODS -----------------------
  // ------------------------------------------------------
  public void drawValueLable()
  {
    fill(255);
    stroke(0);
    strokeWeight(1);
    rect(LBL_X, LBL_Y, lableWidth, lableHeight, RADII);
    
    textAlign(CENTER, CENTER);
    fill(fontColor);
    textSize(fontSize);
    text(valueLable, lblCenterX, lblCenterY);
  }
  
  public void setValue(float newValue)
  {
    value = newValue;
    valueLable = str(newValue);
    
    textSize(fontSize);  // This is for textWidth/Height and lable center x/y.
    textWidth = textWidth(valueLable);
    textHeight = textAscent() + textDescent();
    lableWidth = textWidth + LBL_PADDING;
    lableHeight = textHeight + LBL_PADDING;
    
    lblCenterX = LBL_X + lableWidth / 2.0;
    lblCenterY = LBL_Y + lableHeight / 2.0;
  }
  
  public void setLableCenter(float newLblCenterX, float newLblCenterY)
  {
    lblCenterX = newLblCenterX;
    lblCenterY = newLblCenterY;
  }
  
  public float getValue()
  {
    return value;
  }
  
  public String getLableText()
  {
    return valueLable;
  }
  
  public float getTextWidth()
  {
    return textWidth;
  }
  
  public float getTextHeight()
  {
    return textHeight;
  }
  
  public float getLableWidth()
  {
    return lableWidth;
  }
  
  public float getLableHeight()
  {
    return lableHeight;
  }
  
  public PVector getLableOrigin()
  {
    return new PVector(LBL_X, LBL_Y);
  }
  
  public float getLblX()
  {
    return LBL_X;
  }
  
  public float getLblY()
  {
    return LBL_Y;
  }
  
  public PVector getLableCenter()
  {
    return new PVector(lblCenterX, lblCenterY);
  }
  
  public float getLblCenterX()
  {
    return lblCenterX;
  }
  public float getLblCenterY()
  {
    return lblCenterY;
  }
}
