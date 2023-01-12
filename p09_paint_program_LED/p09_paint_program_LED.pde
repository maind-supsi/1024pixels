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

int size = 1;

PGraphics led;

void setup() {

  size(400, 400);

  noSmooth();

  led = createGraphics(MATRIX_WIDTH, MATRIX_HEIGHT);
  led.smooth();

  led.beginDraw();
  led.background(0);
  led.endDraw();

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

  int previewScale = 8;
  
  led.beginDraw();
  led.noStroke();
  led.background(0);
  
  
  
  float a1 = frameCount * 0.05;  
  float x1 = round(cos(a1) * 9 + MATRIX_WIDTH / 2);
  float y1 = round(sin(a1) * 9 + MATRIX_HEIGHT / 2);
  led.fill(255);
  led.rect(x1, y1, size, size);

    float a2 = -frameCount * 0.08;  
  float x2 = round(cos(a2) * 9 + MATRIX_WIDTH / 2);
  float y2 = round(sin(a2) * 9 + MATRIX_HEIGHT / 2);
  led.fill(255);
  led.rect(x2, y2, size, size);

  
  led.endDraw();
  
  image(led, 0, 0, MATRIX_WIDTH * previewScale, MATRIX_HEIGHT * previewScale);

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
  if (key == 's') {
    String file = System.currentTimeMillis() + ".png";
    println("Saving file: " + file);
    led.save("out/" + file);
  } else if (key == 'r') {
    led.beginDraw();
    led.background(0);
    led.endDraw();
  } else if (keyCode == UP) {
    size = size + 1;
  } else if (keyCode == DOWN) {
    size = max(size - 1, 1);
  }
}
