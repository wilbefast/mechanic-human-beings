/*
--------------------------------------------------------------------------------
IMPORTS
--------------------------------------------------------------------------------
*/

import java.util.Iterator;

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


/*
--------------------------------------------------------------------------------
PLAYER CLASS
--------------------------------------------------------------------------------
*/


class Player
{
  float heartrate;
  
  Player()
  {
    heartrate = 0.5;
  }
}


/*
--------------------------------------------------------------------------------
BUBBLE CLASS
--------------------------------------------------------------------------------
*/

class Bubble
{
  static final float RADIUS = 128.0f, 
                    SPEED = 32.0f, 
                    DAMAGE_THRESHOLD = 0.06f, 
                    DAMAGE_SPEED = 0.05f,
                    RADIUS_CHANGE_SPEED = 0.1f,
                    WOBBLE_AMOUNT = 0.5f,
                    LINE_WIDTH = 8.0f;
  
  float x, y, wobble, radius, heartrate, hitpoints;
  boolean purge = false;
  
  Bubble(float heartrate)
  {
    this.x = random(1.0f)*(width - 2*RADIUS) + RADIUS;
    this.y = -RADIUS/2;
    this.radius = RADIUS;
    this.heartrate = heartrate;
    this.hitpoints = 1.0f;
  }
  
  void update(float dt)
  {
    // move
    y += dt*SPEED;
    
    // wobble
    float drate = abs(destroyer.heartrate - heartrate);
    if(drate < DAMAGE_THRESHOLD)
      wobble = 1 - drate/DAMAGE_THRESHOLD;
    else
      wobble = 0.0f;
      
    // take damage
    if(y > 0)
    {
      hitpoints -= wobble * DAMAGE_SPEED;
      if(hitpoints <= 0)
        purge = true;
    }
    
    // disppear off map
    if(y - RADIUS > height)
      purge = true;
  }
  
  void draw()
  {
    if(!purge)
    {
      float target_radius = RADIUS * (1 + WOBBLE_AMOUNT*signedRand(wobble));
      radius = linter(target_radius, radius, RADIUS_CHANGE_SPEED);
      
      strokeWeight(LINE_WIDTH * hitpoints);
      fill(255*heartrate, 0, 255*(1-heartrate)); 
      ellipseMode(CENTER);
      ellipse(x, y, radius, radius);
    }
  }
}


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
boolean use_pulsesensor = true;

void setup() 
{
  // screen resolution
  size(displayWidth, displayHeight);  // Stage size
  frameRate(MAX_FPS);  
  
  
  font = loadFont("Arial-BoldMT-24.vlw");
  textFont(font);
  textAlign(CENTER);
  rectMode(CENTER);
  ellipseMode(CENTER);  
// Scrollbar constructor inputs: x,y,width,height,minVal,maxVal
  scaleBar = new Scrollbar (400, 575, 180, 12, 0.5, 1.0);  // set parameters for the scale bar
  RawY = new int[PulseWindowWidth];          // initialize raw pulse waveform array
  ScaledY = new int[PulseWindowWidth];       // initialize scaled pulse waveform array
  rate = new int [BPMWindowWidth];           // initialize BPM waveform array
  zoom = 0.75;                               // initialize scale of heartbeat window
    
// set the visualizer lines to 0
 for (int i=0; i<rate.length; i++){
    rate[i] = 555;      // Place BPM graph line at bottom of BPM Window 
   }
 for (int i=0; i<RawY.length; i++){
    RawY[i] = height/2; // initialize the pulse window data line to V/2
 }
   
  if(use_pulsesensor) 
  {
    try
    {
      // GO FIND THE ARDUINO
      println(Serial.list());    // print a list of available serial ports
      
      // choose the number between the [] that is connected to the Arduino
      port = new Serial(this, Serial.list()[6], 115200);  // make sure Arduino is talking serial at this baud rate
      port.clear();            // flush buffer
      port.bufferUntil('\n');  // set buffer full flag on receipt of carriage return
      
      use_pulsesensor = true;
    }
    catch(Exception e)
    {
      println("Arduin Pulsesensor startup failed (" + e + ").");
      println("Defaulting to keyboard control.");
      use_pulsesensor = false;
    }
  }
  
  creator = new Player();
  destroyer = new Player();
  
  bubbles = new ArrayList<Bubble>();
}



/*
--------------------------------------------------------------------------------
UPDATE
--------------------------------------------------------------------------------
*/

float creation_timer = 0;
float CREATION_INTERVAL = 2;
int bubblecount=0;
int popcount=0;
void __update(float dt) 
{
<<<<<<< HEAD
  /// SET HEARTRATES BASED ON PULSENSOR OR KEYBOARD
  if(use_pulsesensor)
  {
    creator.heartrate = clamp((BPM-50.0f)/100.0f,0,1);
    destroyer.heartrate = clamp((BPM2-50.0f)/100.0f,0,1);
  }
  else
  {
    // random creator heartrate
    creator.heartrate = clamp(creator.heartrate + signedRand(dt), 0, 1);
    
    // controlled destroyer heartrate
    int delta = 0;
    if(keyUp) delta++; if(keyDown) delta--;
    destroyer.heartrate = clamp(destroyer.heartrate + delta*dt*0.3f, 0, 1);
  }
=======
  creator.heartrate = clamp((BPM-50.0f)/100.0f,0,1);
  destroyer.heartrate = clamp((BPM2-50.0f)/100.0f,0,1);
>>>>>>> few changes
  
  // create bubbles
  creation_timer = creation_timer - dt;
  if(creation_timer < 0)
  {
    creation_timer = CREATION_INTERVAL;
    bubbles.add(new Bubble(creator.heartrate));
    bubblecount++;
  }
  
  // update bubbles
  Iterator<Bubble> biter = bubbles.iterator();
  while(biter.hasNext())
  {
    Bubble b = biter.next();
    if(b.purge){
      biter.remove();
      popcount++;
      //bubblecount--;
    }
    else
    {
      b.update(dt);
    }
  }
}



/*
--------------------------------------------------------------------------------
GRAPHICS
--------------------------------------------------------------------------------
*/

void __draw() 
{
  // draw the background based on destroy heartrate
  background(255*destroyer.heartrate, 0, 255*(1-destroyer.heartrate)); 
  
  // draw bubbles
  for(Bubble b : bubbles)
    b.draw();
    
  color(0);
  fill(0,0,0);  
  text("creator: " + BPM + " BPM, rate " + creator.heartrate ,150,50);
  text("destroyer: " + BPM2 + " BPM, rate " + destroyer.heartrate ,800,50);
  
  text("score: " + bubblecount,150,70);
  text("score: " + popcount,800,70);
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
  setKeyState(key, keyCode, true);
}

void keyReleased()
{
  setKeyState(key, keyCode, false);
}
