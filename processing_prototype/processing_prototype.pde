/*
--------------------------------------------------------------------------------
USEFUL FUNCTIONS
--------------------------------------------------------------------------------
*/


float clamp(float value, float min, float max)
{
  return(value > max ? max : (value < min ? min : value));
}

float signedRand(float value)
{
  float r = random(1.0f);
  return value*2*(r < 0.5 ? r : -r + 0.5);
}

float linter(float a, float b, float weight)
{
  return (a*weight + b*(1-weight));
}


/*
--------------------------------------------------------------------------------
PLAYER CLASS
--------------------------------------------------------------------------------
*/


class Player
{
  float heartrate;
  
  Player()
  {
    heartrate = 0.5;
  }
}


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
    if(y > RADIUS)
    {
      hitpoints -= wobble * DAMAGE_SPEED;
      if(hitpoints <= 0)
        purge = true;
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
      ellipseMode(CENTER);
      ellipse(x, y, radius, radius);
    }
  }
}


/*
--------------------------------------------------------------------------------
GLOBAL OBJECTS 
--------------------------------------------------------------------------------
*/


Player creator, destroyer;

ArrayList<Bubble> bubbles;

/*
--------------------------------------------------------------------------------
INIT 
--------------------------------------------------------------------------------
*/

void setup() 
{
  creator = new Player();
  destroyer = new Player();
  
  bubbles = new ArrayList<Bubble>();
  
  //size(displayWidth, displayHeight);
  size(960, 640);
}



/*
--------------------------------------------------------------------------------
UPDATE
--------------------------------------------------------------------------------
*/

float creation_timer = 0;
float CREATION_INTERVAL = 2;
void __update(float dt) 
{
  // random creator heartrate
  creator.heartrate = clamp(destroyer.heartrate + signedRand(dt), 0, 1);
  
  // controlled destroyer heartrate
  int delta = 0;
  if(keyUp) delta++; if(keyDown) delta--;
  destroyer.heartrate = clamp(destroyer.heartrate + delta*dt*0.3f, 0, 1);
  
  // create bubbles
  creation_timer = creation_timer - dt;
  if(creation_timer < 0)
  {
    creation_timer = CREATION_INTERVAL;
    bubbles.add(new Bubble(creator.heartrate));
  }
  
  // update bubbles
  for(Bubble b : bubbles)
    b.update(dt);
}



/*
--------------------------------------------------------------------------------
GRAPHICS
--------------------------------------------------------------------------------
*/

void __draw() 
{
  // draw the background based on destroy heartrate
  background(255*destroyer.heartrate, 0, 255*(1-destroyer.heartrate)); 
  
  // draw bubbles
  for(Bubble b : bubbles)
    b.draw();
}



/*
--------------------------------------------------------------------------------
MAIN LOOP
--------------------------------------------------------------------------------
*/

float DT = 1.0/60.0;
void draw() 
{
  __update(DT);
  __draw();
}


/*
--------------------------------------------------------------------------------
INPUT HANDLING
--------------------------------------------------------------------------------
*/

boolean keyUp = false, keyDown = false;

void setKeyState(int _key, int _keyCode, boolean newState)
{
  if(_key == CODED)
  {
    if(_keyCode == UP)
      keyUp = newState;
    else if (_keyCode == DOWN)
      keyDown = newState;
  }
}

void keyPressed()
{
  setKeyState(key, keyCode, true);
}

void keyReleased()
{
  setKeyState(key, keyCode, false);
}
