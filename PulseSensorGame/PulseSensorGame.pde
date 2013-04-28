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
boolean use_pulsesensor = true;

void setup() 
{
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



/*
--------------------------------------------------------------------------------
UPDATE
--------------------------------------------------------------------------------
*/

float creation_timer = 0;
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
    creation_timer = Bubble.CREATION_INTERVAL;
    bubbles.add(new Bubble(creator.heartrate));
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
  // draw the background based on destroyer heartrate
  background(255);
  //background(255*destroyer.heartrate, 0, 255*(1-destroyer.heartrate)); 
  
  // draw destroyer bar
  strokeWeight(5.0f);
  fill(255*destroyer.heartrate, 0, 255*(1-destroyer.heartrate));
  float bar_y = (1-destroyer.heartrate)*height, bar_h = 2*Bubble.RADIUS*Bubble.DAMAGE_THRESHOLD;
  rectMode(CORNER);
  rect(0, bar_y - 16, width, 32); 
  
  // draw bubbles
  for(Bubble b : bubbles)
    b.draw();
    
  fill(0, 0, 0); 
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
