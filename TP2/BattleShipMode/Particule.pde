class Particule {
  float x, y;
  color c;
  float diameter;
  Particule(float x, float y, color c) {
    this.x = x;
    this.y = y;
    this.c = c;
    this.diameter = 10;
  }
  Particule(float x, float y, color c, float diameter) {
    this.x = x;
    this.y = y;
    this.c = c;
    this.diameter = diameter;
  }
}
