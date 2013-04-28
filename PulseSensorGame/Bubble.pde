/*
--------------------------------------------------------------------------------
BUBBLE CLASS
--------------------------------------------------------------------------------
*/

class Bubble
{
  static final float RADIUS = 128.0f, 
                    SPEED = 32.0f, 
                    DAMAGE_THRESHOLD = 0.06f, 
                    DAMAGE_SPEED = 0.05f,
                    RADIUS_CHANGE_SPEED = 0.1f,
                    WOBBLE_AMOUNT = 0.5f,
                    LINE_WIDTH = 8.0f;
  
  float x, y, wobble, radius, heartrate, hitpoints;
  boolean purge = false;
  
  Bubble(float heartrate)
  {
    this.x = random(1.0f)*(width - 2*RADIUS) + RADIUS;
    this.y = -RADIUS/2;
    this.radius = RADIUS;
    this.heartrate = heartrate;
    this.hitpoints = 1.0f;
  }
  
  void update(float dt)
  {
    // move
    y += dt*SPEED;
    
    // wobble
    float drate = abs(destroyer.heartrate - heartrate);
    if(drate < DAMAGE_THRESHOLD)
      wobble = 1 - drate/DAMAGE_THRESHOLD;
    else
      wobble = 0.0f;
      
    // take damage
    if(y > 0)
    {
      hitpoints -= wobble * DAMAGE_SPEED;
      if(hitpoints <= 0)
        purge = true;
    }
    
    // disppear off map
    if(y - RADIUS > height)
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
