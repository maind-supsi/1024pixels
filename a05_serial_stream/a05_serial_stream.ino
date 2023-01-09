// SmartLED Shield for Teensy 4 (V5)
#include <MatrixHardware_Teensy4_ShieldV5.h>
#include <SmartMatrix.h>

// Choose the color depth used for storing pixels in the layers: 24 or 48
#define COLOR_DEPTH 24
// Set to the width of your display, must be a multiple of 8
const uint16_t WIDTH = 32;
// Set to the HEIGHT of your display
const uint16_t HEIGHT = 32;

// Tradeoff of color quality vs refresh rate, max brightness, and RAM usage.
// 36 is typically good, drop down to 24 if you need to.
const uint8_t kRefreshDepth = 24;
// known working: 2-4, use 2 to save RAM, more to keep from dropping frames
const uint8_t kDmaBufferRows = 4;
// Choose the configuration that matches your panels.
// See more details in MatrixCommonHub75.h
// and the docs: https://github.com/pixelmatix/SmartMatrix/wik
const uint8_t kPanelType = SM_PANELTYPE_HUB75_16ROW_MOD8SCAN;

// see docs for options: https://github.com/pixelmatix/SmartMatrix/wiki
const uint32_t kMatrixOptions = (SM_HUB75_OPTIONS_NONE);
const uint8_t kBackgroundLayerOptions = (SM_HUB75_OPTIONS_MATRIXCALC_LOWPRIORITY);

SMARTMATRIX_ALLOCATE_BUFFERS(matrix, WIDTH, HEIGHT, kRefreshDepth, kDmaBufferRows, kPanelType, kMatrixOptions);
SMARTMATRIX_ALLOCATE_BACKGROUND_LAYER(bg, WIDTH, HEIGHT, COLOR_DEPTH, kBackgroundLayerOptions);


const uint16_t NUM_LEDS = WIDTH * HEIGHT;
const uint16_t BUFFER_SIZE = NUM_LEDS * 3;  // Number of channels
uint8_t buf[BUFFER_SIZE];                   // A buffer for the incoming data

void setup() {

  pinMode(LED_BUILTIN, OUTPUT);
  Serial.setTimeout(50);

  matrix.addLayer(&bg);
  matrix.begin();
  matrix.setBrightness(255);
  bg.enableColorCorrection(false);
}

void loop() {
  static uint32_t frame = 0;

  char chr = Serial.read();
  if (chr == '*') {  // Incoming data
    // masterFrame^
    uint16_t count = Serial.readBytes((char *)buf, BUFFER_SIZE);
    if (count == BUFFER_SIZE) {
      rgb24 *buffer = bg.backBuffer();
      uint16_t idx = 0;
      for (uint16_t i = 0; i < NUM_LEDS; i++) {
        //rgb24 *col = &buffer[i];
        drawPixel(i % WIDTH, i / WIDTH, {buf[idx++], buf[idx++], buf[idx++]});
      }
      bg.swapBuffers(false);
    }
  }
  digitalWrite(LED_BUILTIN, frame / 100 % 2);  // Let's animate the built-in LED as well
  
  frame++;
}

// This is a quick hack to correct the row layout of the LED panels.
// Rows 8-15 need to be swapped with rows 16-23:
// if (y >= 8 && y < 16) y += 8;
// else if (y >= 16 && y < 24) y -= 8;
// instead of an if we use a faster map.
void drawPixel(int x, int y, const rgb24& color) {
  static uint8_t y_map[] = {
    0, 1, 2, 3, 4, 5, 6, 7,          // first 8 rows are ok
    16, 17, 18, 19, 20, 21, 22, 23,  // swap these rows
    8, 9, 10, 11, 12, 13, 14, 15,    // ... with these
    24, 25, 26, 27, 28, 29, 30, 31   // last 8 rows are ok
  };
  bg.drawPixel(x, y_map[y], color);
}
