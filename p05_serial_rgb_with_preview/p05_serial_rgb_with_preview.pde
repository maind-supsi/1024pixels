/**
 * This sketch sends all the pixels of the canvas to the serial port.
 * A helper function to scan all the serial ports for a configured controller is provided.
 */

import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3;

Serial serial;
byte[]buffer;

void setup() {

  size(32, 32);

  //printArray(Serial.list());


  serial = new Serial(this, "/dev/cu.usbmodem91269301");

  buffer = new byte[MATRIX_WIDTH * MATRIX_HEIGHT * NUM_CHANNELS];
}

void draw() {

   background(255,0,0);
  
  // Write to the serial port (if open)

  if (serial != null) {
    loadPixels();
    int idx = 0;
    for (int i=0; i<pixels.length; i++) {
      color c = pixels[i];
      buffer[idx++] = (byte)(c >> 16 & 0xFF); // r
      buffer[idx++] = (byte)(c >> 8  & 0xFF); // g
      buffer[idx++] = (byte)(c       & 0xFF); // b
    }
    serial.write('*');     // The 'data' command
    serial.write(buffer);  // ...and the pixel values
  }
}
