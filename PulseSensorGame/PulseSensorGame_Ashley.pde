



/*
--------------------------------------------------------------------------------
IMPORTS
--------------------------------------------------------------------------------
*/

import java.util.Iterator;
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

/*
--------------------------------------------------------------------------------
GLOBAL OBJECTS 
--------------------------------------------------------------------------------
*/



Player creator, destroyer;

ArrayList<Bubble> bubbles;
// A list for all of our rectangles
ArrayList<Box> boxes;
PBox2D box2d;

// Create ArrayLists
boxes = new ArrayList<Box>();

/*
--------------------------------------------------------------------------------
INIT 
--------------------------------------------------------------------------------
*/

int MAX_FPS = 120;
boolean use_pulsesensor = true;

void setup() 
{
  
  
  // box2D
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);
 // Create ArrayLists
boxes = new ArrayList<Box>();
  
  // emd box2d
  
  // screen resolution
  size(640, 480);
  //size(displayWidth, displayHeight);  // Stage size
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


void makeBody(float x, float y) {
    // define a dynamic body positioned at xy in box2d world coordinates,
    // create it and set the initial values for this box2d body's speed and angle
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(new Vec2(x, y)));

    
  }

/*
--------------------------------------------------------------------------------
UPDATE
--------------------------------------------------------------------------------
*/

float creation_timer = 0;
float CREATION_INTERVAL = 2;
void __update(float dt) 
{
  /// SET HEARTRATES BASED ON PULSENSOR OR KEYBOARD
  if(use_pulsesensor)
  {
    creator.heartrate = clamp((BPM-50.0f)/100.0f,0,1);
    destroyer.heartrate = clamp((BPM2-50.0f)/100.0f,0,1);
  }
  else
  {
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
  }
  
  // create bubbles
  creation_timer = creation_timer - dt;
  if(creation_timer < 0)
  {
    creation_timer = CREATION_INTERVAL;
    bubbles.add(new Bubble(creator.heartrate));
    
    // box2d
    makeBody(100,100);
    

    
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
  
  if(use_pulsesensor)
  {
    text("CREATOR: " + BPM + " BPM (" + (int)(creator.heartrate*100) + "%)", 128, height - 32);
    text("DESTROYER: " + BPM2 + " BPM = (" + (int)(destroyer.heartrate*100) + "%)", width - 128, height - 32);
  }
  else
  { 
    text("CREATOR: " + (int)(creator.heartrate*100) + "%",  128, height - 32);
    text("DESTROYER: "  + (int)(destroyer.heartrate*100) + "%", width - 128, height - 32);
  }
  
   // We must always step through time!
  box2d.step();    

  // When the mouse is clicked, add a new Box object
  if (mousePressed) {
    Box p = new Box(mouseX,mouseY);
    boxes.add(p);
  }

  // Display all the boxes
  for (Box b: boxes) {
    b.display();
  }
  
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