/*
--------------------------------------------------------------------------------
INPUT HANDLING
--------------------------------------------------------------------------------
*/

<<<<<<< HEAD
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

void stop()
{
  port.stop();
}

void keyPressed()
{
  if(key == CODED)
  {
    if(keyCode == 20) // CAPS
      creator.boost_heartrate();
    
    else if(keyCode == 16) // SHIFT
      destroyer.boost_heartrate();
  }
  else if(key == 'm')
    destroyer.boost_heartrate();
  else if(key == 'a')
    creator.boost_heartrate();
  else
    setKeyState(key, keyCode, true);
}

void keyReleased()
{
  setKeyState(key, keyCode, false);
}

=======
>>>>>>> right
