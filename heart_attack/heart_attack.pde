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

int MAX_FPS = 120;
PFont font;

void setup() 
{
  // screen resolution
  size(640, 480);
  frame.setTitle("Heart Attack!");
  //size(displayWidth, displayHeight);  // Stage size
  frameRate(MAX_FPS);  
  
  font = loadFont("Arial-BoldMT-24.vlw");
  textFont(font);
  textAlign(CENTER);
  rectMode(CENTER);
  ellipseMode(CENTER);  
   
  destroyer = new Player(width - 32);
  creator = new Player(32);
  bubbles = new ArrayList<Bubble>();
}



/*
--------------------------------------------------------------------------------
UPDATE
--------------------------------------------------------------------------------
*/

float creation_timer = Bubble.CREATION_INTERVAL * 3;
void __update(float dt) 
{
  // reset destroyer target
  destroyer.target = null;
  
  
  /// SET HEARTRATES BASED ON KEYBOARD
    // update creator heartrate
    if(creator.ai_controlled)
      creator.random_heartrate(dt);
    else
      creator.decay_heartrate(dt);
      
    // update destroyer heartrate
    if(destroyer.ai_controlled)
      destroyer.random_heartrate(dt);
    else
      destroyer.decay_heartrate(dt);
  
  // move players
  float target_y = (1-destroyer.heartrate)*(height - 128) + 64;
    destroyer.y = linter(destroyer.y, target_y, 0.9f);
    
  target_y = (1-creator.heartrate)*(height - 128) + 64;
    creator.y = linter(creator.y, target_y, 0.9f);
  
  // create bubbles
  creation_timer = creation_timer - dt;
  if(creation_timer < 0)
  {
    creation_timer = Bubble.CREATION_INTERVAL;
    bubbles.add(new Bubble(creator.y, creator.heartrate));
  }
  
  // update bubbles
  Iterator<Bubble> biter = bubbles.iterator();
  while(biter.hasNext())
  {
    Bubble b = biter.next();
    if(b.purge)
      biter.remove();
    else
      b.update(dt);
  }
  
  // destroy bubbles
  if(destroyer.target != null)
    destroyer.target.takeDamage();
}



/*
--------------------------------------------------------------------------------
GRAPHICS
--------------------------------------------------------------------------------
*/

void __draw() 
{
  // draw the background based on destroyer heartrate
  background(255);
  //background(255*destroyer.heartrate, 0, 255*(1-destroyer.heartrate)); 
  
  // draw destroyer bar
  stroke(255*destroyer.heartrate*2, 128, 255*(1-destroyer.heartrate));
  strokeWeight(5.0f);
  fill(255*destroyer.heartrate, 0, 255*(1-destroyer.heartrate));
  float bar_y = destroyer.y, bar_h = Bubble.RADIUS*Bubble.DAMAGE_THRESHOLD;
  rectMode(CORNER);
  
  // explosion
  float r = 24+signedRand(4);
  if(destroyer.target == null)
    rect(0, bar_y - 16, width, 16);
  else
  {
    rect(destroyer.target.x, bar_y - 16, width - destroyer.target.x, 16); 
    // draw explosions
    ellipseMode(RADIUS);
    fill(255*destroyer.heartrate, 0, 255*(1-destroyer.heartrate));
    ellipse(destroyer.target.x+signedRand(4), bar_y+signedRand(4), r, r); 
  }
    
  // draw bubbles
  for(Bubble b : bubbles)
    b.draw();
    
  if(destroyer.target != null)
  {
    stroke(255*destroyer.heartrate*2, 128, 255*(1-destroyer.heartrate));
    strokeWeight(5.0f);
    fill(255*destroyer.heartrate, 0, 255*(1-destroyer.heartrate), 128);
    ellipse(destroyer.target.x+signedRand(4), bar_y+signedRand(4), r, r); 
  }
  
  // draw GUI boxes
  fill(255);
  stroke(0);
  strokeWeight(5.0f);
  rect(0, 0, 64, height);
  rect(width-64, 0, 64, height);
  
  // draw hearts
  creator.draw_heart();
  destroyer.draw_heart();
    
  // draw GUI text
  fill(0, 0, 0); 
  text(creator.score,  32, height - 16);
  text(destroyer.score, width - 32, height - 16);
  
  fill(keyA ? 255 : 0, 0, keyA ? 0 : 255);
  text("A",  32, 24);
  fill(keyM ? 255 : 0, 0, keyM ? 0 : 255);
  text("M", width - 32, 24);
}



/*
--------------------------------------------------------------------------------
MAIN LOOP
--------------------------------------------------------------------------------
*/

float DT = 1.0f/MAX_FPS;
void draw() 
{ 
  __update(DT);
  __draw();
}
