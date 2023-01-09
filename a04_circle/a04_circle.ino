// SmartLED Shield for Teensy 4 (V5)
#include <MatrixHardware_Teensy4_ShieldV5.h>
#include <SmartMatrix.h>

#define COLOR_DEPTH 24
const uint16_t WIDTH = 32;
const uint16_t HEIGHT = 32;
const uint8_t kRefreshDepth = 24;
const uint8_t kDmaBufferRows = 4;
const uint8_t kPanelType = SM_PANELTYPE_HUB75_16ROW_MOD8SCAN;
const uint32_t kMatrixOptions = (SM_HUB75_OPTIONS_NONE);
const uint8_t kBackgroundLayerOptions = (SM_HUB75_OPTIONS_MATRIXCALC_LOWPRIORITY);

SMARTMATRIX_ALLOCATE_BUFFERS(matrix, WIDTH, HEIGHT, kRefreshDepth, kDmaBufferRows, kPanelType, kMatrixOptions);
SMARTMATRIX_ALLOCATE_BACKGROUND_LAYER(bg, WIDTH, HEIGHT, COLOR_DEPTH, kBackgroundLayerOptions);

// ----------------------------------------------------------------------

void setup() {
  matrix.addLayer(&bg);
  matrix.begin();
  matrix.setBrightness(255);
  bg.enableColorCorrection(true);
}

uint frame = 0;

void loop() {

  bg.fillScreen({ 0, 0, 0 });  // Clear to a color {r,g,b}
  
  float f = sin(frame * 0.001) * 3;
  for (int j = 0; j < HEIGHT; j++) {
    for (int i = 0; i < WIDTH; i++) {
      float d = sqrt(pow(15 - i, 2) + pow(15 - j, 2));
      float r = (sin(d * f + frame * 0.04) * 0.5 + 0.5) * 255;
      drawPixel(i, j, { r, 0, 0 });
    }
  }

  bg.swapBuffers(true);  // The library offers double buffering
  frame++;
}

// ----------------------------------------------------------------------

void drawPixel(int x, int y, const rgb24& color) {
  static uint8_t y_map[] = {
    0, 1, 2, 3, 4, 5, 6, 7,          // first 8 rows are ok
    16, 17, 18, 19, 20, 21, 22, 23,  // swap these rows
    8, 9, 10, 11, 12, 13, 14, 15,    // ... with these
    24, 25, 26, 27, 28, 29, 30, 31   // last 8 rows are ok
  };
  bg.drawPixel(x, y_map[y], color);
}
