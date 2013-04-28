/*
--------------------------------------------------------------------------------
INPUT HANDLING
--------------------------------------------------------------------------------
*/

boolean keyUp = false, keyDown = false, keyM, keyA;

void setKeyState(int _key, int _keyCode, boolean newState)
{
  if(_key == CODED)
  {
    if(_keyCode == UP)
      keyUp = newState;
    else if (_keyCode == DOWN)
      keyDown = newState;
  }
  
  if(key == 'm')
    keyM = newState;
  else if(key == 'a')
    keyA = newState;
}

void keyPressed()
{
  if(key == 'm')
    destroyer.boost_heartrate();
  else if(key == 'a')
    creator.boost_heartrate();
  
  setKeyState(key, keyCode, true);
}

void keyReleased()
{
  setKeyState(key, keyCode, false);
}

