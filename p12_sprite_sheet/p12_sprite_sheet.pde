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

PGraphics led;

PImage[] sprite;


void setup() {

  size(400, 300);

  noSmooth();

  PImage earthSprite = loadImage("earth.png");
  sprite = new PImage[16 * 16];
  for (int i=0; i<sprite.length; i++) {
    int x = i % 16 * 32;
    int y = i / 16 * 32;
    sprite[i] = earthSprite.get(x, y, 32, 32);
  }

  led = createGraphics(MATRIX_WIDTH, MATRIX_HEIGHT);
  //led.smooth();

  printArray(Serial.list());

  try {
    serial = new Serial(this, "/dev/cu.usbmodem91290301");
  }
  catch(Exception e) {
    println("Couldn't open the serial port...");
    println(e);
  }

  buffer = new byte[MATRIX_WIDTH * MATRIX_HEIGHT * NUM_CHANNELS];

  frameRate(30);
}

void draw() {

  led.beginDraw();
  
  led.background(0);

  led.image(sprite[frameCount * 2 % sprite.length], 0, 0);

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

float smoothUnion( float d1, float d2, float k ) {
  float h = constrain(0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0 );
  return lerp( d2, d1, h ) - k * h * (1.0 - h);
}
