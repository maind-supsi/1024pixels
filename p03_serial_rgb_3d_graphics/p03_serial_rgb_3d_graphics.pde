/**
 * This sketch sends all the pixels of the canvas to the serial port.
 */

import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3;

Serial serial;
byte[]buffer;

void setup() {

  size(32, 32, P3D);

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


  frameRate(30);
}

void draw() {

  background(0, 0, 0);
  noFill();
  stroke(255);

  translate(width/2, height/2);
  rotateX(frameCount * 0.031);
  rotateY(frameCount * 0.042);
  rotateZ(frameCount * 0.053);

  float l = map(sin(frameCount * 0.06), -1, 1, 5, 40);
  float h = l * 3;

  box(h, l, l);
  box(l, h, l);
  box(l, l, h);

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
