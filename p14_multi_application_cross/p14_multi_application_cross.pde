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

PGraphics led, t1, t2;

Anim anim1, anim2;

void setup() {

  size(400, 300);

  noSmooth();

  t1 = createGraphics(MATRIX_WIDTH, MATRIX_HEIGHT);
  t2 = createGraphics(MATRIX_WIDTH, MATRIX_HEIGHT);

  led = createGraphics(MATRIX_WIDTH, MATRIX_HEIGHT);
  led.smooth();

  printArray(Serial.list());

  try {
    serial = new Serial(this, "/dev/cu.usbmodem91290301");
  }
  catch(Exception e) {
    println("Couldn't open the serial port...");
    println(e);
  }

  buffer = new byte[MATRIX_WIDTH * MATRIX_HEIGHT * NUM_CHANNELS];

  anim1 = new Earth();
  anim2 = new Ball();
}

void draw() {

  t1.beginDraw();
  anim1.loop(t1);
  t1.endDraw();

  t2.beginDraw();
  anim2.loop(t2);
  t2.endDraw();

  led.beginDraw();
  led.background(0);
  led.noTint();
  led.image(t1, 0, 0);
  led.tint(255, map(mouseX, 0, width, 0, 255));
  led.image(t2, 0, 0);
  led.endDraw();

  image(led, 10, 10, MATRIX_WIDTH * 8, MATRIX_HEIGHT * 8);

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


void keyPressed() {

  if (key == '1') anim1 = new Ball();
  else if (key == '2') anim1 = new SDF();
  else if (key == '3') anim2 = new MiniFont();
  else if (key == '4') anim2 = new Earth();
}
