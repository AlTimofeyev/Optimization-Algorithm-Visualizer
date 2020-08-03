/**
 * Author:  Al Timofeyev
 * Date:    July 29, 2020
 * Desc:    Used to create obstacles for the population of dots
 *          in the Genetic Algorithm.
 */

class Wall
{
  PShape wall;  // The wall object.

  // The (x, y) coordinates of the 4 corners of the Wall shape.
  PVector topLeftCorner;
  PVector topRightCorner;
  PVector bottomRightCorner;
  PVector bottomLeftCorner;
  
  // ************************************************************************
  // ***************************** CONSTRUCTORS *****************************
  // ************************************************************************
  
  /**
   * @brief Constructor
   * Creates a PShape "wall" barrier object.
   * 
   * @param tl_X  Top left x coordinate of the Wall.
   * @param tl_Y  Top left y coordinate of the Wall.
   * @param tr_X  Top right x coordinate of the Wall.
   * @param tr_Y  Top right y coordinate of the Wall.
   * @param br_X  Bottom right x coordinate of the Wall.
   * @param br_Y  Bottom right y coordinate of the Wall.
   * @param bl_X  Bottom left x coordinate of the Wall.
   * @param bl_Y  Bottom left y coordinate of the Wall.
   */
  Wall(int tl_X, int tl_Y, int tr_X, int tr_Y, int br_X, int br_Y, int bl_X, int bl_Y)
  {
    // Assign these coordinates to the propper corners.
    topLeftCorner = new PVector(tl_X, tl_Y);
    topRightCorner = new PVector(tr_X, tr_Y);
    bottomRightCorner = new PVector(br_X, br_Y);
    bottomLeftCorner = new PVector(bl_X, bl_Y);

    // Make the Wall object.
    wall = createShape();
    wall.beginShape();
    wall.fill(162, 54, 182);  // Set the color of the shape.
    wall.noStroke();          // Make sure there's no stroke.
    wall.vertex(tl_X, tl_Y);  // Top Left corner.
    wall.vertex(tr_X, tr_Y);  // Top Right corner.
    wall.vertex(br_X, br_Y);  // Bottom Right corner.
    wall.vertex(bl_X, bl_Y);  // Bottom Left corner.
    wall.endShape();
  }
  
  // ************************************************************************
  // ******************************* METHODS ********************************
  // ************************************************************************

  /**
   * @brief Checks to see if a dot is touching or is inside this wall.
   * 
   * @param dot The PVector that contains the Dot object's x and y coordinates.
   * @return A true or false flag.
   */
  boolean isDotTouchingWall(PVector dot)
  {
    // If the dot is touching this wall, return true;
    if(dot.x >= bottomLeftCorner.x && dot.x <= bottomRightCorner.x && dot.y >= topLeftCorner.y && dot.y <= bottomLeftCorner.y)
      return true;
    
    return false;  // Otherwise, dot is not touching wall, return false.
  }
}
