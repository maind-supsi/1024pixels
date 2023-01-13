class Ball extends Anim {


  void loop() {
    float x = sin(frameCount * 0.1) * 10 + MATRIX_WIDTH * 0.5;
    float y = cos(frameCount * 0.3) * 10 + MATRIX_HEIGHT * 0.5;
    led.fill(255);
    led.background(200, 0, 180);
    led.ellipse(x, y, 9, 9);
  }
}
