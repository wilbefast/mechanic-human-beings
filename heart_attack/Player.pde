/*
--------------------------------------------------------------------------------
PLAYER CLASS
--------------------------------------------------------------------------------
*/


class Player
{
  static final float PULSE_INCREASE_SPEED = 0.02f,
              PULSE_DECREASE_SPEED = 0.1f,
              PULSE_RANDOMVAR_SPEED = 1.0f,
              PULSE_KEYBOARD_SPEED = 0.3f;
  
  
  float heartrate;
  float x, y;
  boolean ai_controlled;
  int score;
  Bubble target;

  Player(float _x)
  {
    ai_controlled = false;
    heartrate = 0.5;
    x = _x;
    y = 0.5;
    score = 0;
  }
  
  void draw_heart()
  {
     fill(255*destroyer.heartrate, 0, 255*(1-destroyer.heartrate));
     stroke(0);
     strokeWeight(3);
        
     smooth();   // draw the heart with two bezier curves
     bezier(x, y, 
           x+20, y-40, 
           x+40, y, 
           x, y+20);
           
     bezier(x, y, 
           x-20, y-40, 
           x-40, y,
           x, y+20);
     strokeWeight(1);          // reset the strokeWeight for next time 
  }
  
  void boost_heartrate()
  {
    heartrate = clamp(heartrate + PULSE_INCREASE_SPEED, 0, 1);
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

