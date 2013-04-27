class Player
{
  float heartrate;
  
  Player()
  {
    heartrate = 0.5;
  }
}

Player creator = new Player();
Player destroy = new Player();



void setup() 
{
  size(640, 480);
}

void draw() 
{
  background(255*creator.heartrate, 0, 255*(1-creator.heartrate)); 
  
  if (mousePressed) 
    fill(0);
  else
    fill(255);
  ellipse(mouseX, mouseY, 80, 80);
}
