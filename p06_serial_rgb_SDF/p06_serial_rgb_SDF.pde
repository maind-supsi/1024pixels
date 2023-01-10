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

void setup() {

  size(400, 300);

  noSmooth();

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
}

void draw() {


  led.beginDraw();
  led.loadPixels();
  
  float c1x = sin(frameCount * 0.02) * 0.7;
  float c1y = cos(frameCount * 0.03) * 0.7;
  
  
  for (int j=0; j<MATRIX_HEIGHT; j++) {
    for (int i=0; i<MATRIX_WIDTH; i++) {

      float x = 2.0 * i / MATRIX_WIDTH - 1.0;
      float y = 2.0 * j / MATRIX_HEIGHT - 1.0;

      float  d1 = dist(c1x, c1y, x, y);
      float  d2 = dist(-0.3, -0.1, x, y);
  
  
      float s = smoothUnion(d1, d2, float(mouseX) / width );

      float r = sin(s * 20 + frameCount * 0.1) * 0.5 + 0.5;


      float g = r;
      float b = r;



      led.pixels[i + j * MATRIX_WIDTH] = color(r * 255, g * 255, b * 255);
    }
  }
  led.updatePixels();
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
