class MiniFont extends Anim{

  PFont font;

  MiniFont() {
    font = createFont("MiniFont/PxPlus_HP_100LX_6x8.ttf", 8);
  }

  void loop(PGraphics target) {

    target.textFont(font);
    target.background(0);
    target.fill(200, 100, 0);
    target.textAlign(LEFT, TOP);
    for (int j=0; j<4; j++) {
      for (int i=0; i<5; i++) {
        int idx = 33 + (i + floor(sin(j * 0.1 + frameCount * 0.005) * 80) + 80);
        idx = idx % 95;
        target.text(char(idx), i * 6, j * 8);
      }
    }
  }
}
