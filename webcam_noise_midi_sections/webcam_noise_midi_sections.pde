
//Uses parts of the processing video example "Background Subtraction" by Golan Levin. 
// Uses parts of the Processing examples "GettingStartedCapture" and "FrameDifferencing"

// Import libraries
import processing.video.*;
import netP5.*;
import oscP5.*;
import processing.serial.*;

// Declare new OSC, Serial, NetAddress and Video
Serial serialPort;
Capture video;
OscP5 oscP5;
NetAddress myRemotelocation;

// Declare some variables
int numPixels;
int avgRed =0;
int avgGreen =0;
int avgBlue =0;
int avgRedPrev = 0; // Used to only send data to the synth when the note changes

void setup(){
  size(700,540); // Canvas size is 30px larger than the video size around all edges to allow for a border to be drawn
  fill(255,255,0); // Fill the text yellow so it shows up clearly
  frameRate(60); // Set the framerate high so the sketch runs as quickly as it can
  
  textSize(30); // Make the text a size that can be read on top of the video
  
  // Set up the serial port to communicate with the Arduino
 String portName = Serial.list()[0];
  serialPort = new Serial(this, portName, 115200); //matches the speed of the arduino 
  
  // Set up OSC to communicate with PD
  oscP5 =new OscP5(this,12000);
  myRemotelocation = new NetAddress("127.0.0.1", 12000);
  
  // Set up the video to capture images from the webcam
  video = new Capture(this,640,480);
  video.start();
  
  // Calculate the number of pixels in the image
  numPixels=video.width * video.height;
  
  loadPixels();
}

void draw(){
if (video.available()){ // Do nothing unless the video is available to read
  video.read(); // Read the video data
  video.loadPixels(); // Make the pixels[] array available
  
  // Reset the current red, green and blue variables so a new average can be taken
  int currR =0;
  int currG =0;
  int currB =0;
  
  for(int i=0; i<numPixels/4; i++){ // Loop over a quater of the pixels in the frame
    color currColor =video.pixels[i]; // Extract the colour information from the current pixel
    currR += (currColor >> 16) &0xFF; // Extract red using bit-shifting for speed (as per examples) and add it to the running total
    currG += (currColor >> 8) & 0xFF; // Extract green
    currB += currColor & 0xFF;        // Extract blue
  }
  
  // Calculate average colours by dividing running total by the number of pixels
  avgRed =currR/(numPixels/4);
  avgGreen = currG/(numPixels/4);
  avgBlue = currB/(numPixels/4);

  background (avgRed, avgGreen,avgBlue); // Set the background colour (the border) to be the average overall colour
  image(video,30,30); // Draw the image from the webcam in the middle of the canvas
 // text(avgRed + " "+ avgGreen + " " + avgBlue,45,60); // Print the average values in the top left of the screen
  
  // OSC Stuff
  OscBundle bundle = new OscBundle(); // Create new blank OSC bundle
  OscMessage message =new OscMessage("/red1"); // Create the first part of the message
  
  message.add(avgRed); // Add the average red value to the message
  bundle.add(message); // Add the message to the bundle
  message.clear(); // Clear the message
  
  // Repeat the above for the green and blue averages
  message.setAddrPattern("/green1");
  message.add(avgGreen);
  bundle.add(message);
  message.clear();
  
  message.setAddrPattern("/blue1");
  message.add(avgBlue);
  bundle.add(message);
  message.clear();
  
  
   // Reset the current red, green and blue variables so a new average can be taken for the next section
   currR =0;
   currG =0;
   currB =0;
  
  for(int i=numPixels/4; i<numPixels/2; i++){ // Loop over a quater of the pixels in the frame
    color currColor =video.pixels[i]; // Extract the colour information from the current pixel
    currR += (currColor >> 16) &0xFF; // Extract red using bit-shifting for speed (as per examples) and add it to the running total
    currG += (currColor >> 8) & 0xFF; // Extract green
    currB += currColor & 0xFF;        // Extract blue
  }
  
  // Calculate average colours by dividing running total by the number of pixels
  avgRed =currR/(numPixels/4);
  avgGreen = currG/(numPixels/4);
  avgBlue = currB/(numPixels/4);

  background (avgRed, avgGreen,avgBlue); // Set the background colour (the border) to be the average overall colour
  image(video,30,30); // Draw the image from the webcam in the middle of the canvas
 // text(avgRed + " "+ avgGreen + " " + avgBlue,45,60); // Print the average values in the top left of the screen
  
  
  message.setAddrPattern("/red2"); // Create the first part of the message
  message.add(avgRed); // Add the average red value to the message
  bundle.add(message); // Add the message to the bundle
  message.clear(); // Clear the message
  
  // Repeat the above for the green and blue averages
  message.setAddrPattern("/green2");
  message.add(avgGreen);
  bundle.add(message);
  message.clear();
  
  message.setAddrPattern("/blue2");
  message.add(avgBlue);
  bundle.add(message);
  message.clear();
  
  // Reset the current red, green and blue variables so a new average can be taken for the next section
   currR =0;
   currG =0;
   currB =0;
  
  for(int i=numPixels/2; i<(3*numPixels/4); i++){ // Loop over a quater of the pixels in the frame
    color currColor =video.pixels[i]; // Extract the colour information from the current pixel
    currR += (currColor >> 16) &0xFF; // Extract red using bit-shifting for speed (as per examples) and add it to the running total
    currG += (currColor >> 8) & 0xFF; // Extract green
    currB += currColor & 0xFF;        // Extract blue
  }
  
  // Calculate average colours by dividing running total by the number of pixels
  avgRed =currR/(numPixels/4);
  avgGreen = currG/(numPixels/4);
  avgBlue = currB/(numPixels/4);

  background (avgRed, avgGreen,avgBlue); // Set the background colour (the border) to be the average overall colour
  image(video,30,30); // Draw the image from the webcam in the middle of the canvas
 // text(avgRed + " "+ avgGreen + " " + avgBlue,45,60); // Print the average values in the top left of the screen
  
  
  message.setAddrPattern("/red3"); // Create the first part of the message
  message.add(avgRed); // Add the average red value to the message
  bundle.add(message); // Add the message to the bundle
  message.clear(); // Clear the message
  
  // Repeat the above for the green and blue averages
  message.setAddrPattern("/green3");
  message.add(avgGreen);
  bundle.add(message);
  message.clear();
  
  message.setAddrPattern("/blue3");
  message.add(avgBlue);
  bundle.add(message);
  message.clear();
  
   // Reset the current red, green and blue variables so a new average can be taken for the next section
   currR =0;
   currG =0;
   currB =0;
  
  for(int i=(3*numPixels/4); i<numPixels; i++){ // Loop over a quater of the pixels in the frame
    color currColor =video.pixels[i]; // Extract the colour information from the current pixel
    currR += (currColor >> 16) &0xFF; // Extract red using bit-shifting for speed (as per examples) and add it to the running total
    currG += (currColor >> 8) & 0xFF; // Extract green
    currB += currColor & 0xFF;        // Extract blue
  }
  
  // Calculate average colours by dividing running total by the number of pixels
  avgRed =currR/(numPixels/4);
  avgGreen = currG/(numPixels/4);
  avgBlue = currB/(numPixels/4);

  background (avgRed, avgGreen,avgBlue); // Set the background colour (the border) to be the average overall colour
  image(video,30,30); // Draw the image from the webcam in the middle of the canvas
 // text(avgRed + " "+ avgGreen + " " + avgBlue,45,60); // Print the average values in the top left of the screen
  
  
  message.setAddrPattern("/red4"); // Create the first part of the message
  message.add(avgRed); // Add the average red value to the message
  bundle.add(message); // Add the message to the bundle
  message.clear(); // Clear the message
  
  // Repeat the above for the green and blue averages
  message.setAddrPattern("/green4");
  message.add(avgGreen);
  bundle.add(message);
  message.clear();
  
  message.setAddrPattern("/blue4");
  message.add(avgBlue);
  bundle.add(message);
  message.clear();
  
  oscP5.send(bundle,myRemotelocation); // Send the bundle to localhost
  
  if (avgRed!=avgRedPrev){ // Only send a new value to the arduino if the average red has changed
    serialPort.write(byte(avgRed/2)+"\n"); // Send the average red value, divided by 2 to correspond to MIDI notes 0-127
    avgRedPrev = avgRed; // Save the current value of average red to check if it changes next time
  }
 }
}