class Ball extends Anim {


  void loop(PGraphics target) {
    float x = sin(frameCount * 0.1) * 10 + MATRIX_WIDTH * 0.5;
    float y = cos(frameCount * 0.3) * 10 + MATRIX_HEIGHT * 0.5;
    
    //target.clear();
    target.fill(255);
    target.background(200, 0, 180);
    target.ellipse(x, y, 9, 9);
  }
}
