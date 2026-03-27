class Particule
{
  float x, y;
  float diameter = 10;

  Particule(float x, float y)
  {
    this.x = x;
    this.y = y;
  }

  void render()
  {
    fill(150, 0, 255);
    noStroke();
    circle(x, y, diameter);
  }
}
