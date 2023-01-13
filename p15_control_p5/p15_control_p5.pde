

/**
 * Control P5 example. 
 * To run this skecth you need to install the Control P5 library! 
 */

import controlP5.*;
import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3;

Serial serial;
byte[]buffer;

PGraphics led;

float ball_diameter = 24;
float range_x = 12;
float range_y = 12;
int freq_x = 7;
int freq_y = 8;

void setup() {

  size(600, 300);

  noSmooth();

  led = createGraphics(MATRIX_WIDTH, MATRIX_HEIGHT);
  led.smooth();

  led.beginDraw();
  led.background(0);
  led.endDraw();

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
  cp5.addSlider("ball_diameter").setRange(1, 64).setWidth(w).setHeight(h).linebreak();
  cp5.addSlider("range_x").setRange(0, 16).setWidth(w).setHeight(h).linebreak();
  cp5.addSlider("range_y").setRange(0, 16).setWidth(w).setHeight(h).linebreak();
  cp5.addSlider("freq_x").setRange(0, 10).setWidth(w).setHeight(h).linebreak();
  cp5.addSlider("freq_y").setRange(0, 10).setWidth(w).setHeight(h).linebreak();
}

void draw() {

  background(180);

  float x = sin(frameCount * freq_x * 0.01) * range_x + MATRIX_WIDTH * 0.5;
  float y = cos(frameCount * freq_y * 0.01) * range_y + MATRIX_HEIGHT * 0.5;
  float r = map(sin(frameCount * 0.041), -1, 1, 0, 255);
  float g = map(sin(frameCount * 0.052), -1, 1, 0, 255);
  float b = map(sin(frameCount * 0.063), -1, 1, 0, 255);

  led.beginDraw();
  led.noStroke();
  led.fill(r, g, b);
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
