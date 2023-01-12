void setup() {

  size(600, 600);
}


void draw() {

  background(220);
  
  pushMatrix();

  translate(100, 200);
  rotate(0.6);
  rect(0, 0, 100, 40);

  translate(120, 0);
  rect(0, 0, 100, 40);
  
  translate(120, 0);
  rotate(-0.6);
  
  rect(0, 0, 100, 40);
  
  popMatrix();
}
