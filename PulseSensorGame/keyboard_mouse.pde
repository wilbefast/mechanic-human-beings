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

void stop()
{
  port.stop();
}

void keyPressed()
{
  if(key == CODED)
  {
    if(keyCode == 20) // CAPS
      creator.heartrate = clamp(creator.heartrate + Player.PULSE_INCREASE_SPEED, 0, 1);
    
    else if(keyCode == 16) // SHIFT
      destroyer.heartrate = clamp(destroyer.heartrate + Player.PULSE_INCREASE_SPEED, 0, 1);
  }
  
  setKeyState(key, keyCode, true);
}

void keyReleased()
{
  setKeyState(key, keyCode, false);
}

