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

void draw_heart(float x, float y, float size, float heartrate)
{
  fill(255*heartrate, 0, 255*(1-heartrate));
  stroke(0);
  strokeWeight(3);
          
  smooth();   // draw the heart with two bezier curves
  bezier(x-1, y, 
             x-1+floor(20*size), y-40*size, 
             x-1+floor(40*size), y, 
             x-1, y+floor(20*size));
             
  bezier(x, y, 
             x-ceil(20*size), y-40*size, 
             x-ceil(40*size), y,
             x, y+floor(20*size));
  strokeWeight(1);          // reset the strokeWeight for next time 
}
