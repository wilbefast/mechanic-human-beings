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

