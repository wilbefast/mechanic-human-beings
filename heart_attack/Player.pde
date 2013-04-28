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
              PULSE_KEYBOARD_SPEED = 0.3f,
              PULSE_LENGTH = 0.1f, // seconds
              PULSE_SIZE = 0.7f;
  
  float heartrate;
  float pulse;
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
    pulse = 0.0f;
  }
  
  void draw_heart()
  {
     float size = 1.0f + pulse*PULSE_SIZE;
    
     fill(255*destroyer.heartrate, 0, 255*(1-destroyer.heartrate));
     stroke(0);
     strokeWeight(3);
        
     smooth();   // draw the heart with two bezier curves
     bezier(x, y, 
           x+size*20, y-size*40, 
           x+size*40, y, 
           x, y+size*20);
           
     bezier(x, y, 
           x-size*20, y-size*40, 
           x-size*40, y,
           x, y+size*20);
     strokeWeight(1);          // reset the strokeWeight for next time 
  }
  
  void boost_heartrate()
  {
    heartrate = clamp(heartrate + PULSE_INCREASE_SPEED, 0, 1);
    pulse = PULSE_LENGTH;
  }
  
  void decay_heartrate(float dt)
  {
    heartrate = clamp(heartrate -dt*PULSE_DECREASE_SPEED, 0, 1);
    pulse = clamp(pulse - dt, 0, 1);
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

