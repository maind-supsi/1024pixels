
int size = 1;

void setup() {
  size(300, 300);
  background(0);
}


void draw() {

  noStroke();
  fill(255);
  if (mousePressed) {
    rect(mouseX, mouseY, size, size);
  }
}

void keyPressed() {
    if (key == 's') {     
      String file = System.currentTimeMillis() + ".png";    
      println("Saving file: " + file);
      save("out/" + file);
    } else if (key == 'r') {
      background(0);
    } else if (keyCode == UP) {
      size = size + 1;
    } else if (keyCode == DOWN) {
      size = max(size - 1, 1);
    }
}
