
import processing.video.*;
Capture video;

import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3;

Serial serial;
byte[]buffer;

void setup() {

  size(32, 32);

  // Displays all the available serial ports…
  // On macOS you can type
  // > ls -1 /dev/cu*
  // in the terminal for the same result
  // printArray(Serial.list());

  // Windows
  // serial = new Serial(this, "COM3");

  // macOS / unix systems:
  serial = new Serial(this, "/dev/cu.usbmodem91269301");
  
  buffer = new byte[MATRIX_WIDTH * MATRIX_HEIGHT * NUM_CHANNELS];
   
  video = new Capture(this, 64, 42, "pipeline:autovideosrc");
  video.start();  

  frameRate(30);
}

void draw() {

  background(0, 0, 0);
  
  image(video, width/2 - video.width/2, height/2 - video.height/2);

  // Write to the serial port (if open)
  if (serial != null) {
    loadPixels();
    int idx = 0;
    for (int i=0; i<pixels.length; i++) {
      color c = pixels[i];
      buffer[idx++] = (byte)(c >> 16 & 0xFF); // r
      buffer[idx++] = (byte)(c >> 8 & 0xFF);  // g
      buffer[idx++] = (byte)(c & 0xFF);       // b
    }
    serial.write('*');     // The 'data' command
    serial.write(buffer);  // ...and the pixel values
  }
}

void captureEvent(Capture c) {
  c.read();
}
