/*
--------------------------------------------------------------------------------
BUBBLE CLASS
--------------------------------------------------------------------------------
*/

class Bubble
{
  static final float RADIUS = 64.0f, 
                    SPEED = 16.0f, 
                    DAMAGE_THRESHOLD = 0.2f, 
                    DAMAGE_SPEED = 0.05f,
                    RADIUS_CHANGE_SPEED = 0.1f,
                    WOBBLE_AMOUNT = 0.5f,
                    LINE_WIDTH = 8.0f,
                    CREATION_INTERVAL = 4.5f;
  
  float x, y, wobble, radius, heartrate, hitpoints;
  boolean purge = false;
  
  Bubble(float heartrate)
  {
    this.x = -RADIUS/2;
    
    this.y = (1-heartrate)*(height - 2*RADIUS) + RADIUS;
    this.radius = RADIUS;
    this.heartrate = heartrate;
    this.hitpoints = 1.0f;
  }
  
  void update(float dt)
  {
    // move
    x += dt*SPEED;
    
    // wobble
    float drate = abs(destroyer.heartrate - heartrate);
    if(drate < DAMAGE_THRESHOLD)
      wobble = 1 - drate/DAMAGE_THRESHOLD;
    else
      wobble = 0.0f;
      
    // take damage
    if(x > 0)
    {
      hitpoints -= wobble * DAMAGE_SPEED;
      if(hitpoints <= 0)
        purge = true;
    }
    
    // disppear off map
    if(x - RADIUS > width)
      purge = true;
  }
  
  void draw()
  {
    if(!purge)
    {
      float target_radius = RADIUS * (1 + WOBBLE_AMOUNT*signedRand(wobble));
      radius = linter(target_radius, radius, RADIUS_CHANGE_SPEED);
      
      strokeWeight(LINE_WIDTH * hitpoints);
      fill(255*heartrate, 0, 255*(1-heartrate)); 
      ellipseMode(CENTER);
      ellipse(x, y, radius, radius);
    }
  }
}
