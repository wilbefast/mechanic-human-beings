/*
THIS PROGRAM WORKS WITH PulseSensorAmped_Arduino-xx ARDUINO CODE
THE PULSE DATA WINDOW IS SCALEABLE WITH SCROLLBAR AT BOTTOM OF SCREEN
PRESS 'S' OR 's' KEY TO SAVE A PICTURE OF THE SCREEN IN SKETCH FOLDER (.jpg)
MADE BY JOEL MURPHY AUGUST, 2012
*/


import processing.serial.*;
PFont font;
Scrollbar scaleBar;

Serial port;     

int Sensor;      // HOLDS PULSE SENSOR DATA FROM ARDUINO
int IBI;         // HOLDS TIME BETWEN HEARTBEATS FROM ARDUINO
int BPM;         // HOLDS HEART RATE VALUE FROM ARDUINO
int[] RawY;      // HOLDS HEARTBEAT WAVEFORM DATA BEFORE SCALING
int[] ScaledY;   // USED TO POSITION SCALED HEARTBEAT WAVEFORM
int[] rate;      // USED TO POSITION BPM DATA WAVEFORM

int Sensor2;      // HOLDS PULSE SENSOR DATA FROM ARDUINO
int IBI2;         // HOLDS TIME BETWEN HEARTBEATS FROM ARDUINO
int BPM2;         // HOLDS HEART RATE VALUE FROM ARDUINO
int[] RawY2;      // HOLDS HEARTBEAT WAVEFORM DATA BEFORE SCALINGnjhvegtnnnnn

float zoom;      // USED WHEN SCALING PULSE WAVEFORM TO PULSE WINDOW
float offset;    // USED WHEN SCALING PULSE WAVEFORM TO PULSE WINDOW
color eggshell = color(255, 253, 248);
int heart = 0;   // This variable times the heart image 'pulse' on screen
int heart2 = 0;   // This variable times the heart image 'pulse' on screen
//  THESE VARIABLES DETERMINE THE SIZE OF THE DATA WINDOWS
int PulseWindowWidth = 490;
int PulseWindowHeight = 512; 
int BPMWindowWidth = 180;
int BPMWindowHeight = 340;
boolean beat = false;    // set when a heart beat is detected, then cleared when the BPM graph is advanced
boolean beat2 = false;    // set when a heart beat is detected, then cleared when the BPM graph is advanced
int oldBPM;
  


