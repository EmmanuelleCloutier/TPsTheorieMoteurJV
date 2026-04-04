class Particule
{
  float x, y;
  float diameter = 10;
  color c;

  Particule(float x, float y, color c)
  {
    this.x = x;
    this.y = y;
    this.c = c;
  }

  void render()
  {
    fill(c);
    noStroke();
    circle(x, y, diameter);
  }
}
