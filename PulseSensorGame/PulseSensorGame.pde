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
  
  destroyer = new Player(width - 32);
  creator = new Player(32);
  
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
  
  destroyer.y = (1-destroyer.heartrate)*(height - 2*Bubble.RADIUS) + Bubble.RADIUS;
  creator.y = (1-creator.heartrate)*(height - 2*Bubble.RADIUS) + Bubble.RADIUS;
  
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
  stroke(0);
  strokeWeight(5.0f);
  fill(255*destroyer.heartrate, 0, 255*(1-destroyer.heartrate));
  float bar_y = destroyer.y, bar_h = 2*Bubble.RADIUS*Bubble.DAMAGE_THRESHOLD;
  rectMode(CORNER);
  rect(0, bar_y - 16, width, 32); 
  
  // draw bubbles
  for(Bubble b : bubbles)
    b.draw();
  
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
  if(use_pulsesensor)
  {
    text(BPM + " BPM (" + (int)(creator.heartrate*100) + "%)", 64, height - 16);
    text(BPM2 + " BPM = (" + (int)(destroyer.heartrate*100) + "%)", width - 64, height - 16);
  }
  else
  { 
    text((int)(creator.heartrate*100) + "%",  32, height - 16);
    text((int)(destroyer.heartrate*100) + "%", width - 32, height - 16);
  }
  text(creator.score,  32, 32);
  text(destroyer.score, width - 32, 32);
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
