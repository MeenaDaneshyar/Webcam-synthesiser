// For use with webcam_noise_midi
// Takes numbers over serial from 0-127 and outputs a MIDI note over pin 3 of the arduino.
//uses example 'TwoPortReceive' and tutorial MIDI note player on the arduino website

// Import library
#include <SoftwareSerial.h>;

// Variables
byte note = 0; // The note which will be played 
String inString; // The string recieved from the computer over serial
boolean stringComplete; // A check to see if the serial message if finished

// Because the normal serial pins of the arduino are being used to talk to the computer,
// set up SoftwareSerial to create a new virtual serial port on pins 2 and 3 for MIDI
SoftwareSerial midiSerial(2, 3); // digital pins that we'll use for soft serial RX & TX

void setup() {
  //  Set MIDI baud rate:
  Serial.begin(115200); // Communicate with the computer at 115200 baud
  midiSerial.begin(31250); // Communicate with the synth at 31250 baud, the standard MIDI clock rate
}

void loop() {
  if(stringComplete){
    noteOn(0x90, lastNotePlayed, 0x00);
    noteOn(0x90, note, 0x45);
    stringComplete = false;
  }
}

//  plays a MIDI note.  Doesn't check to see that
//  cmd is greater than 127, or that data values are  less than 127:
void noteOn(byte cmd, byte data1, byte data2) {
  midiSerial.write(cmd);
  midiSerial.write(data1);
  midiSerial.write(data2);
}

void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    // add it to the inputString:
    inString += inChar;
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') {
      note = inString.toInt();
      Serial.println(note);
      stringComplete = true;
      inString = "";
    }
  }
}
