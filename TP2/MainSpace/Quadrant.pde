class Quadrant
{
  PVector TopLeft = new PVector(0, 0);
  float Height;
  float Width;

  Quadrant(PVector TopLeft, float Width, float Height)
  {
    this.TopLeft = TopLeft;
    this.Height = Height;
    this.Width = Width;
  }

  void render()
  {
    // Couleur
  fill(0, 0, 0);
  
  // Bordures
  stroke(255);
  strokeWeight(2);
  
  // Quandrant
  rect(TopLeft.x, TopLeft.y, Width, Height);
  }
}
