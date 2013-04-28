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

void setup() 
{
<<<<<<< HEAD
  // screen resolution
  size(640, 480);
  //size(displayWidth, displayHeight);  // Stage size
  frameRate(MAX_FPS);  
  
  
  font = loadFont("Arial-BoldMT-24.vlw");
=======
  size(700, 600);  // Stage size
  frameRate(100);  
  font = loadFont("CooperBlackStd-24.vlw");
>>>>>>> right
  textFont(font);
  textAlign(CENTER);
  rectMode(CENTER);
  ellipseMode(CENTER);  
  text("Pulse War!!!", width/2,height/2);
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
   
// GO FIND THE ARDUINO
  println(Serial.list());    // print a list of available serial ports
  // choose the number between the [] that is connected to the Arduino
  port = new Serial(this, Serial.list()[6], 115200);  // make sure Arduino is talking serial at this baud rate
  port.clear();            // flush buffer
  port.bufferUntil('\n');  // set buffer full flag on receipt of carriage return
  
  
  destroyer = new Player(width - 32);
  creator = new Player(32);
  
  bubbles = new ArrayList<Bubble>();
  
  //size(displayWidth, displayHeight);
  size(960, 640);
}



/*
--------------------------------------------------------------------------------
UPDATE
--------------------------------------------------------------------------------
*/

float creation_timer = 0;
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
=======
  creator.heartrate = clamp((BPM-50.0f)/100.0f,0,1);
  destroyer.heartrate = clamp((BPM2-50.0f)/100.0f,0,1);
>>>>>>> right
  
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
<<<<<<< HEAD
  
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
=======
    
  color(0);
  fill(0,0,0);  
  text("Creator: " + BPM + " BPM, rate " + creator.heartrate ,200,600);
  text("Destroyer: " + BPM2 + " BPM, rate " + destroyer.heartrate ,750,600);
  
  text("Score: " + bubblecount,200,620);
  text("Score: " + popcount,750,620);
>>>>>>> right
}



/*
--------------------------------------------------------------------------------
MAIN LOOP
--------------------------------------------------------------------------------
*/

float DT = 1.0/60.0;
void draw() 
{ 
  __update(DT);
  __draw();
}
