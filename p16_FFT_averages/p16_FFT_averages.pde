import processing.sound.*;

AudioIn input;
FFT fft;
Area bass, high;

int bands = 512;

public void setup() {
  size(640, 360);
  background(255);

  input = new AudioIn(this, 0);
  input.start();

  fft = new FFT(this, bands);
  fft.input(input);

  bass = new Area(25, 34);
  high = new Area(39, 48);
}

public void draw() {

  fft.analyze();

  float scale = 2000.0;

  float b = bass.getAverage(fft.spectrum);
  float h = high.getAverage(fft.spectrum);
  float threshold = 0.01;


  if (b > threshold) {
    background(255, 128, 0);
  } else if (h > threshold) {
    background(0, 128, 255);
  } else {
    background(220);
  }

  fill(0);
  noStroke();
  for (int i = 0; i < bands; i++) {
    float val = fft.spectrum[i];
    int x = i;
    int y = height;
    float v = - val * scale;
    rect(x, y, 1, v);
  }

  bass.draw(color(255, 0, 0), scale);
  high.draw(color(0, 200, 0), scale);
}

// A simple class to store two values (low, high) and to calculate 
// an average bewteen them.
class Area {

  int low;
  int high;

  float average;

  Area(int low, int high) {
    this.low = low;
    this.high = high;
  }

  // Get the average between the "low" and the "high" bar
  float getAverage(float[] values) {
    average = 0;
    for (int i=low; i<high; i++) {
      average += values[i];
    }
    average = average / (high - low);
    return average;
  }
  
  // Visualize the area
  void draw(color col, float scale) {
    float h = height - scale * average;
    
    stroke(col);
    line(low, 100, low, height);
    line(high, 100, high, height);
    line(low, h, high, h);
  }
}
