class Quadrant
{
  PVector TopLeft;
  float Height;
  float Width;
  int MaxDepth = 10;
  int MaxParticles = 4;
  int CurrentDepth = 0;
  
  boolean HasChildren = false;
  Quadrant[] Children = new Quadrant[4];
  ArrayList<Particule> Particules = new ArrayList<Particule>();

  Quadrant(PVector TopLeft, float Width, float Height, int MaxParticles, int MaxDepth, int CurrentDepth)
  {
    this.TopLeft = TopLeft;
    this.Height = Height;
    this.Width = Width;
    this.MaxParticles = MaxParticles;
    this.MaxDepth = MaxDepth;
    this.CurrentDepth = CurrentDepth;
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
    
    // Render Particles
    for (Particule p : Particules)
    {
      p.render();
    }
  }
  
  int GetParticles() {
  
    // Top Left
    float x1 = TopLeft.x;
    float y1 = TopLeft.y;
    // Bottom Roght
    float x2 = x1 + Width;
    float y2 = y1 + Height;
     
    int NbParticules = 0;
    for (Particule p : Particules) {
      if (p.x >= x1 && p.x <= x2 && p.y >= y1 && p.y <= y2) {
        NbParticules++;
      }
    }
    println("Nombre Particules = " + NbParticules);
    return NbParticules;
  }
  
  void GenerateTree(int Depth){
    float halfWidth = Width / 2.0;
    float halfHeight = Height / 2.0;
    
    // TODO: DEBUG
    /*
    if(Depth > MaxDepth){
      return;
    }*/
    
    // Seul les feuilles ont besoins de créer des enfants
    if(HasChildren){
      for (Quadrant child : Children) {
        child.GenerateTree(Depth++);
      }
      return;
    }
    
    // Si les feuilles ont besoin de diviser
    if(GetParticles() > MaxParticles){
      float x1 = TopLeft.x;
      float y1 = TopLeft.y;
      float x2 = TopLeft.x + halfWidth;
      float y2 = TopLeft.y + halfHeight;
      
      HasChildren = true;
      Children[0] = new Quadrant(new PVector(x1, y1), halfWidth, halfHeight, MaxParticles, MaxDepth, Depth);
      Children[1] = new Quadrant(new PVector(x1, y2), halfWidth, halfHeight, MaxParticles, MaxDepth, Depth);
      Children[2] = new Quadrant(new PVector(x2, y1), halfWidth, halfHeight, MaxParticles, MaxDepth, Depth);
      Children[3] = new Quadrant(new PVector(x2, y2), halfWidth, halfHeight, MaxParticles, MaxDepth, Depth);
      
      for (Particule p : Particules) {
        RedistributeParticlesOnGenerate(p);
      }
      
      for (Quadrant child : Children) {
        child.render();
        child.GenerateTree(Depth++);
      }
      
      Particules.clear();
    }
  }
  
  void RedistributeParticlesOnGenerate(Particule p){
  
    if(!HasChildren){
      println("Error : Called RedistributeParticlesOnGenerate() on a Quadrnat with no children");
     return;
    }
    else { // descend dans le quadrant correct
      float halfWidth = Width / 2.0;
      float halfHeight = Height / 2.0;
  
      int index; // quel enfant
      
      if(p.x <= TopLeft.x + halfWidth){
        if(p.y <= TopLeft.y + halfHeight){
          index = 0; // quadrant 1
        } else {
          index = 1; // quadrant 2
        }
      } else {
        if(p.y <= TopLeft.y + halfHeight){
          index = 2; // quadrant 3
        } else {
          index = 3; // quadrant 4
        }
      }
      println("Quadrant :" + (index + 1));
      Children[index].Particules.add(p);
    }
  }
  
  /*
  1 | 3
  -----
  2 | 4
  */
  void AddParticleOnClick(){
    GetParticles();
  
    if(!HasChildren){
      Particules.add(new Particule(mouseX, mouseY));
      render();
    }
    else { // descend dans le quadrant correct
      float halfWidth = Width / 2.0;
      float halfHeight = Height / 2.0;
  
      int index; // quel enfant
      
      if(mouseX <= TopLeft.x + halfWidth){
        if(mouseY <= TopLeft.y + halfHeight){
          index = 0; // quadrant 1
        } else {
          index = 1; // quadrant 2
        }
      } else {
        if(mouseY <= TopLeft.y + halfHeight){
          index = 2; // quadrant 3
        } else {
          index = 3; // quadrant 4
        }
      }
  
      Children[index].AddParticleOnClick();
    }
  }
}
