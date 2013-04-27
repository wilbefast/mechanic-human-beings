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

Player creator, destroyer;



/*
--------------------------------------------------------------------------------
INIT 
--------------------------------------------------------------------------------
*/

void setup() 
{
  creator = new Player();
  destroyer = new Player();
  
  size(640, 480);
}



/*
--------------------------------------------------------------------------------
UPDATE
--------------------------------------------------------------------------------
*/

void __update(float dt) 
{
  creator.heartrate = destroyer.heartrate = clamp(destroyer.heartrate + signedRand(dt), 0, 1);
  println(destroyer.heartrate);
}



/*
--------------------------------------------------------------------------------
GRAPHICS
--------------------------------------------------------------------------------
*/

void __draw() 
{
  background(255*creator.heartrate, 0, 255*(1-creator.heartrate)); 
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
