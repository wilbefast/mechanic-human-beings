/*
--------------------------------------------------------------------------------
PLAYER CLASS
--------------------------------------------------------------------------------
*/


class Player
{
  static final float PULSE_INCREASE_SPEED = 0.04f,
              PULSE_DECREASE_SPEED = 0.1f,
              PULSE_RANDOMVAR_SPEED = 1.0f,
              PULSE_KEYBOARD_SPEED = 0.3f;
  
  
  float heartrate;
  boolean ai_controlled;
  
  Player()
  {
    ai_controlled = false;
    heartrate = 0.5;
  }
  
  void decay_heartrate(float dt)
  {
    heartrate = clamp(heartrate -dt*PULSE_DECREASE_SPEED, 0, 1);
  }
  
  void random_heartrate(float dt)
  {
    heartrate = clamp(heartrate + signedRand(dt*PULSE_RANDOMVAR_SPEED), 0, 1);
  }
  
  void keyboard_heartrate(float dt, boolean keyIncrease, boolean keyDecrease)
  {
    int delta = 0;
    if(keyIncrease) delta++; if(keyDecrease) delta--;
    heartrate = clamp(heartrate + delta*dt*PULSE_KEYBOARD_SPEED, 0, 1);
  }
}

