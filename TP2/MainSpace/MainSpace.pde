int WindowWidth = 800;
int WindowHeight = 600;
ArrayList<Quadrant> Quadrants = new ArrayList<Quadrant>();
ArrayList<Particule> Particules = new ArrayList<Particule>();

void settings()
{
    size(WindowWidth + 20, WindowHeight + 20);
    
}

void setup()
{
  //background(0);
    PVector QuadrantTopLeft = new PVector(0 + 10, 0 + 10);
    Quadrants.add(new Quadrant(QuadrantTopLeft, WindowWidth, WindowHeight));
}

void draw(){
  background(0);
  
  // Render Quadrants
  for (Quadrant q : Quadrants)
  {
    q.render();
  }
  
  // Render Particules
  for (Particule p : Particules)
  {
    p.render();
  }
}

void mouseClicked() {
  Particules.add(new Particule(mouseX, mouseY));
  //AddParticule(mouseX, mouseY);
  
  for (Quadrant q : Quadrants)
  {
    println(getParticlesInArea(q));
  }
}

int getParticlesInArea(Quadrant CurrentQuadrant) {
  
  // Top Left
  float x1 = CurrentQuadrant.TopLeft.x;
  float y1 = CurrentQuadrant.TopLeft.y;
  // Bottom Roght
  float x2 = x1 + CurrentQuadrant.Width;
  float y2 = y1 + CurrentQuadrant.Height;
  
  println("Point1(" + x1 + ", " + y1 + "). Point2(" + x2 + ", " + y2 + ").");
   
  int NbParticules = 0;
  for (Particule p : Particules) {
    if (p.x >= x1 && p.x <= x2 && p.y >= y1 && p.y <= y2) {
      NbParticules++;
    }
  }
  return NbParticules;
}
