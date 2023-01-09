/**
 * This sketch sends all the pixels of the canvas to the serial port.
 */

import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3;

Serial serial;
byte[]buffer;

PImage cat;

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

  cat = loadImage("cat.png");

  frameRate(30);
}

void draw() {

  background(0, 0, 0);

  float w = map(sin(frameCount * 0.061), -1, 1, width*0.2, width * 5.0);
  float h = map(sin(frameCount * 0.072), -1, 1, width*0.2, width * 5.0);
  
  image(cat, width/2-w/2, height/2-h/2, w, h);

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
