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
const uint8_t kBackgroundLayerOptions = (SM_BACKGROUND_OPTIONS_NONE);

SMARTMATRIX_ALLOCATE_BUFFERS(matrix, WIDTH, HEIGHT, kRefreshDepth, kDmaBufferRows, kPanelType, kMatrixOptions);
SMARTMATRIX_ALLOCATE_BACKGROUND_LAYER(bg, WIDTH, HEIGHT, COLOR_DEPTH, kBackgroundLayerOptions);

void setup() {
  matrix.addLayer(&bg);
  matrix.begin();
  matrix.setBrightness(255);
  bg.enableColorCorrection(false);
}

void drawPixel(int x, int y, const rgb24& color) {
  if (y >= 8 && y < 16) y += 8;
  else if (y >= 16 && y < 24) y -= 8;
  bg.drawPixel(x, y, color);
}

void loop() {
  bg.fillScreen({ 0, 0, 0 });  // Clear to a color {r,g,b}
  drawPixel(5, 5, { 255, 0, 0 });
  bg.swapBuffers(true);  // The library offers double buffering
}