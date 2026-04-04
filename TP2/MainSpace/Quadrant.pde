class Quadrant
{
  PVector TopLeft;
  float Height;
  float Width;
  int MaxDepth = 6;
  int MaxParticles = 4;
  int CurrentDepth = 0;
  color quadrantColor;
  
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
    this.quadrantColor = color(random(50,255), random(50,255), random(50,255));
  }

  void render() 
  {
    //dessine le rectangle du quadrant
    noFill();
    stroke(255);
    strokeWeight(1);
    rect(TopLeft.x, TopLeft.y, Width, Height);
  
    if(HasChildren){
      //si subdivise, il faut dessiner les enfants
      for(Quadrant child : Children){
        child.render();
      }
    } else {
      //sinon dessigner les particules
      for (Particule p : Particules){
        p.render();
      }
    }
  }
    
  int GetParticles() {
  //compte combien de particules sont dans les bounds
    float x1 = TopLeft.x;
    float y1 = TopLeft.y;
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
  
void GenerateTree(){
  
  //stop si pronfondeur maxdepth
  if (CurrentDepth >= MaxDepth) {
    return;
  }

  //si deja subdivise, propager aux kids
  if(HasChildren){
    for (Quadrant child : Children) {
      child.GenerateTree();
    }
    return;
  }

  //si trop de particules, subdivide
  if(GetParticles() > MaxParticles){
    
    //calcul du centre
    float halfWidth = Width / 2.0;
    float halfHeight = Height / 2.0;

    float x1 = TopLeft.x;
    float y1 = TopLeft.y;
    float x2 = x1 + halfWidth;
    float y2 = y1 + halfHeight;

    HasChildren = true;

    //creation des 4 kids
    Children[0] = new Quadrant(new PVector(x1, y1), halfWidth, halfHeight, MaxParticles, MaxDepth, CurrentDepth + 1);
    Children[1] = new Quadrant(new PVector(x1, y2), halfWidth, halfHeight, MaxParticles, MaxDepth, CurrentDepth + 1);
    Children[2] = new Quadrant(new PVector(x2, y1), halfWidth, halfHeight, MaxParticles, MaxDepth, CurrentDepth + 1);
    Children[3] = new Quadrant(new PVector(x2, y2), halfWidth, halfHeight, MaxParticles, MaxDepth, CurrentDepth + 1);

    //redistribue les particules dans les enfants
    for (Particule p : Particules) {
      RedistributeParticlesOnGenerate(p);
    }

    //continue recursivement
    for (Quadrant child : Children) {
      child.GenerateTree();
    }
    
    //vide le parent
    Particules.clear();
  }
}

  int GetQuadrantIndex(float px, float py){
    float midX = TopLeft.x + Width / 2.0;
    float midY = TopLeft.y + Height / 2.0;
  
    if(px < midX){
      if(py < midY){
        return 0; // top left
      } else {
        return 1; // bottom left
      }
    } else {
      if(py < midY){
        return 2; // top right
      } else {
        return 3; // bottom right
      }
    }
  }
  
  void RedistributeParticlesOnGenerate(Particule p){
  
    if(!HasChildren){
      println("Error : Called RedistributeParticlesOnGenerate() on a Quadrnat with no children");
      return;
    }
  
    int index = GetQuadrantIndex(p.x, p.y);
  
    //ajoute dans le bon enfant
    Children[index].Particules.add(p);
    
    //change couleur 
    p.c = Children[index].quadrantColor;
  }
  
void Subdivide(){
  //crée les enfants + redistrubue directement
  
  float halfWidth = Width / 2.0;
  float halfHeight = Height / 2.0;

  float x1 = TopLeft.x;
  float y1 = TopLeft.y;
  float x2 = x1 + halfWidth;
  float y2 = y1 + halfHeight;

  HasChildren = true;

  Children[0] = new Quadrant(new PVector(x1, y1), halfWidth, halfHeight, MaxParticles, MaxDepth, CurrentDepth + 1);
  Children[1] = new Quadrant(new PVector(x1, y2), halfWidth, halfHeight, MaxParticles, MaxDepth, CurrentDepth + 1);
  Children[2] = new Quadrant(new PVector(x2, y1), halfWidth, halfHeight, MaxParticles, MaxDepth, CurrentDepth + 1);
  Children[3] = new Quadrant(new PVector(x2, y2), halfWidth, halfHeight, MaxParticles, MaxDepth, CurrentDepth + 1);

  
  for (Particule p : Particules){
    int index = GetQuadrantIndex(p.x, p.y);
    Children[index].Particules.add(p);
  }

Particules.clear();
}

void AddParticleOnClick(){
  
  if(!HasChildren){
    //ajoute dans ce noeud
    Particules.add(new Particule(mouseX, mouseY, quadrantColor));

    //si depasse capacité, subdivise
    if(Particules.size() > MaxParticles && CurrentDepth < MaxDepth){
      Subdivide();
    }
  }
  else {
    //sinon on drescend recursivmeent
    int index = GetQuadrantIndex(mouseX, mouseY);
    Children[index].AddParticleOnClick();
  }
}
}
