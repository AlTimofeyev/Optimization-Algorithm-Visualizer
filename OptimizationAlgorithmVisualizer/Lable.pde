/**
 * Copyright © 2021 Al Timofeyev. All rights reserved.
 * @author  Al Timofeyev
 * @date    October 30, 2021
 * @brief   A Lable class for the Optimization Algorithm Visualizer Desktop Application.
 *
 * @version 1.0
 * Modified By:
 * Modified Date:
 * *********************************************************/

class Lable
{
  // ------------------------------------------------------
  // ----------------------- FIELDS -----------------------
  // ------------------------------------------------------
  // ----- Private ------
  private final color FONT_COLOR = color(0);  // Default font color.
  private final int FONT_SIZE = 12;           // Default font size.
  
  private final String LABLE;  // The name on the lable
  private final float LBL_X;   // The starting x-coordinate position of lable.
  private final float LBL_Y;   // The starting y-coordinate position of lable.
  
  private float lblCenterX;  // The center x-coordinate position of lable.
  private float lblCenterY;  // The center y-coordinate position of lable.
  private float textWidth;   // Width of text based on text size.
  private float textHeight;  // Height of text based on text size.
  private color fontColor;   // Font color.
  private int fontSize;      // Font size.
  
  
  // ------------------------------------------------------
  // -------------------- CONSTRUCTORS --------------------
  // ------------------------------------------------------
  public Lable(String lable, float x, float y)
  {
    fontColor = FONT_COLOR;
    fontSize = FONT_SIZE;
    
    textSize(fontSize);  // This is for textWidth/Height and lable center x/y.
    textWidth = textWidth(lable);
    textHeight = textAscent() + textDescent();
    
    LABLE = lable;
    LBL_X = x;
    LBL_Y = y;
    lblCenterX = LBL_X + textWidth / 2.0;
    lblCenterY = LBL_Y + textHeight / 2.0;
  }
  
  public Lable(String lable, float x, float y, int sizeOfFont)
  {
    fontColor = FONT_COLOR;
    fontSize = sizeOfFont;
    
    textSize(fontSize);  // This is for textWidth/Height and lable center x/y.
    textWidth = textWidth(lable);
    textHeight = textAscent() + textDescent();
    
    LABLE = lable;
    LBL_X = x;
    LBL_Y = y;
    lblCenterX = LBL_X + textWidth / 2.0;
    lblCenterY = LBL_Y + textHeight / 2.0;
  }
  
  // ------------------------------------------------------
  // ---------------------- METHODS -----------------------
  // ------------------------------------------------------
  public void drawLable()
  {
    textAlign(CENTER, CENTER);
    fill(fontColor);
    textSize(fontSize);
    text(LABLE, lblCenterX, lblCenterY);
    
    fill(255, 0,0);
    ellipse(LBL_X, LBL_Y, 5, 5); // TL
    ellipse(LBL_X+textWidth, LBL_Y, 5, 5); // TR
    ellipse(LBL_X+textWidth, LBL_Y+textHeight, 5, 5); // BR
    ellipse(LBL_X, LBL_Y+textHeight, 5, 5); // BL
    ellipse(lblCenterX, lblCenterY, 5, 5); // Center
  }
  
  public void setFontSize(int newFontSize)
  {
    fontSize = newFontSize;
    
    // Update the lable data based on the set text size.
    textSize(fontSize);
    textWidth = textWidth(LABLE);
    textHeight = textAscent() + textDescent();
    lblCenterX = LBL_X + textWidth / 2.0;
    lblCenterY = LBL_Y + textHeight / 2.0;
  }
  
  public void setFontColor(color newFontColor)
  {
    fontColor = newFontColor;
  }
  
  public void resetLableCenter()
  {
    textSize(fontSize);
    
    // Update the lable data based on the set text size.
    textWidth = textWidth(LABLE);
    textHeight = textAscent() + textDescent();
    lblCenterX = LBL_X + textWidth / 2.0;
    lblCenterY = LBL_Y + textHeight / 2.0;
  }
  
  public void setLableCenter(float newLblCenterX, float newLblCenterY)
  {
    lblCenterX = newLblCenterX;
    lblCenterY = newLblCenterY;
  }
  
  public String getLableText()
  {
    return LABLE;
  }
  
  public float getTextWidth()
  {
    return textWidth;
  }
  
  public float getTextHeight()
  {
    return textHeight;
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
