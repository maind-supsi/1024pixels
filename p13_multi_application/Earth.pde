class Earth extends Anim {



  PImage[] sprite;

  Earth() {
    PImage earthSprite = loadImage("Earth/earth.png");
    sprite = new PImage[16 * 16];
    for (int i=0; i<sprite.length; i++) {
      int x = i % 16 * 32;
      int y = i / 16 * 32;
      sprite[i] = earthSprite.get(x, y, 32, 32);
    }
  }

  void loop() {
    led.background(0);
    led.image(sprite[frameCount * 2 % sprite.length], 0, 0);
  }
}
