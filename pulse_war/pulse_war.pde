/*
--------------------------------------------------------------------------------
IMPORTS
--------------------------------------------------------------------------------
*/

import java.util.Iterator;

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
void setup() { game_setup(); }
void game_setup() 
{
  creator = new Player();
  destroyer = new Player();
  
  bubbles = new ArrayList<Bubble>();
  
  //size(displayWidth, displayHeight);
  //size(960, 640);
}



/*
--------------------------------------------------------------------------------
UPDATE
--------------------------------------------------------------------------------
*/

float creation_timer = 0;
float CREATION_INTERVAL = 2;
void game_update(float dt) 
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
  Iterator<Bubble> i = bubbles.iterator();
  while(i.hasNext())
  {
    Bubble b = i.next();
    if(b.purge)
      i.remove();
    else
      b.update(dt);
  }
}



/*
--------------------------------------------------------------------------------
GRAPHICS
--------------------------------------------------------------------------------
*/

void game_draw() 
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
  game_update(DT);
  game_draw();
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
