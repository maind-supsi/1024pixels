

/**
 * This sketch sends all the pixels of the canvas to the serial port.
 * A helper function to scan all the serial ports for a configured controller is provided.
 */

import controlP5.*;
import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3;

Serial serial;
byte[]buffer;

PGraphics led;

float ball_diameter = 9;
float range_x = 10;
float range_y = 10;

void setup() {

  size(600, 300);

  noSmooth();

  led = createGraphics(MATRIX_WIDTH, MATRIX_HEIGHT);
  led.smooth();

  //printArray(Serial.list());

  try {
    serial = new Serial(this, "/dev/cu.usbmodem91269301");
  }
  catch(Exception e) {
    println("Couldn't open the serial port...");
    println(e);
  }

  buffer = new byte[MATRIX_WIDTH * MATRIX_HEIGHT * NUM_CHANNELS];

  ControlP5 cp5 = new ControlP5(this);

  int w = 200;
  int h = 18;
  cp5.addSlider("ball_diameter").setRange(1, 40).setWidth(w).setHeight(h).linebreak();
  cp5.addSlider("range_x").setRange(0, 40).setWidth(w).setHeight(h).linebreak();
  cp5.addSlider("range_y").setRange(0, 40).setWidth(w).setHeight(h).linebreak();

}

void draw() {

  background(180);

  float x = sin(frameCount * 0.1) * range_x + MATRIX_WIDTH * 0.5;
  float y = cos(frameCount * 0.3) * range_y + MATRIX_HEIGHT * 0.5;
  led.beginDraw();
  //led.noStroke();
  led.background(200, 0, 180);
  led.ellipse(x, y, ball_diameter, ball_diameter);
  led.endDraw();

  image(led, width -MATRIX_WIDTH * 8 - 10, 10, MATRIX_WIDTH * 8, MATRIX_HEIGHT * 8);

  // Write to the serial port (if open)

  if (serial != null) {
    led.loadPixels();
    int idx = 0;
    for (int i=0; i<led.pixels.length; i++) {
      color c = led.pixels[i];
      buffer[idx++] = (byte)(c >> 16 & 0xFF); // r
      buffer[idx++] = (byte)(c >> 8  & 0xFF); // g
      buffer[idx++] = (byte)(c       & 0xFF); // b
    }
    serial.write('*');     // The 'data' command
    serial.write(buffer);  // ...and the pixel values
  }
}
