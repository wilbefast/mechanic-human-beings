/*
--------------------------------------------------------------------------------
BUBBLE CLASS
--------------------------------------------------------------------------------
*/

class Bubble
{
  static final float RADIUS = 32.0f, 
                    SPEED = 16.0f, 
                    DAMAGE_THRESHOLD = 0.1f, 
                    DAMAGE_SPEED = 0.02f,
                    RADIUS_CHANGE_SPEED = 0.1f,
                    WOBBLE_AMOUNT = 0.5f,
                    LINE_WIDTH = 5.0f,
                    CREATION_INTERVAL = 2.0f;
  
  float x, y, wobble, radius, heartrate, hitpoints;
  boolean purge = false;
  
  Bubble(float y, float heartrate)
  {
    this.x = RADIUS;
    
    this.y = y;
    this.radius = RADIUS;
    this.heartrate = heartrate;
    this.hitpoints = 1.0f;
  }
  
  void update(float dt)
  {
    // move
    x += dt*SPEED;
    
    // wobble
    float delta = abs(destroyer.y - y);
    if(x > RADIUS*2 && delta < RADIUS)
    {
      if(destroyer.target == null || destroyer.target.x < x)
      {
        if(destroyer.target != null)
          destroyer.target.wobble = 0;
        destroyer.target = this;
        wobble = 1 - delta/RADIUS;
      }
    }
    else
      wobble = 0.0f;
      
    // disppear off map
    if(x - RADIUS > width)
    {
      purge = true;
      creator.score += 5;
    }
  }
  
  void takeDamage()
  {
    hitpoints -= wobble * DAMAGE_SPEED;
    if(hitpoints <= 0)
    {
      purge = true;
      destroyer.score += 1;
    }
  }
  
  void draw()
  {
    if(!purge)
    {
      float target_radius = RADIUS * (1 + WOBBLE_AMOUNT*signedRand(wobble));
      radius = linter(target_radius, radius, RADIUS_CHANGE_SPEED);
      
      strokeWeight(LINE_WIDTH * hitpoints);
      fill(255*heartrate, 0, 255*(1-heartrate)); 
      if(x > RADIUS * 2) 
        draw_heart(x, y, radius/RADIUS*2, heartrate);
      else
        draw_heart(x, y, radius/RADIUS*(x/RADIUS), heartrate);
    }
  }
}
