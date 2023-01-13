class SDF extends Anim {


  float smoothUnion( float d1, float d2, float k ) {
    float h = constrain(0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0 );
    return lerp( d2, d1, h ) - k * h * (1.0 - h);
  }


  void loop(PGraphics target) {
    target.loadPixels();

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



        target.pixels[i + j * MATRIX_WIDTH] = color(r * 255, g * 255, b * 255);
      }
    }
    target.updatePixels();
  }
}
