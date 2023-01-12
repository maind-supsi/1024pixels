void setup() {

  size(800, 600);
}


void draw() {

  background(220);

  noStroke();


  translate(width/2, height/2);
  
  float t = frameCount * 0.01;


  for (int j=0; j<10; j++) {
   
    pushMatrix();
    rotate(TAU/10 * j);
    for (int i=0; i<16; i++) {
      fill(0);
      rect(0, -10, 50, 20);
      fill(255);
      ellipse(0, 0, 20, 20);

      translate(50, 0);
      float a = (noise(i * 0.1, j * 0.1, t) - 0.5) * 2.0;
      rotate(a);
      scale(0.9);
    }
    
    popMatrix();
  }
}
