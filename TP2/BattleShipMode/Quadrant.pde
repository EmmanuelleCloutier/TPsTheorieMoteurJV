class Quadrant {
  PVector TopLeft;
  float Width, Height;
  int MaxDepth, MaxParticles, CurrentDepth;
  color quadrantColor; 
  boolean HasChildren = false;
  Quadrant[] Children = new Quadrant[4];
  ArrayList<Particule> Particules = new ArrayList<Particule>();

  //constructeur pour initialiser le quadrant
  Quadrant(PVector TopLeft, float Width, float Height, int MaxParticles, int MaxDepth, int CurrentDepth) {
    this.TopLeft = TopLeft;
    this.Width = Width;
    this.Height = Height;
    this.MaxParticles = MaxParticles;
    this.MaxDepth = MaxDepth;
    this.CurrentDepth = CurrentDepth;
    this.quadrantColor = color(random(50,255), random(50,255), random(50,255));
  }

  //return le nombre de particules dans ce quadrant
  int GetParticles() {
    int count = 0; //compteur de particules
    for (Particule p : Particules) { //parcours de chaque particule
    //vérifie si la particules est a l'intérieur du quadrant
      if (p.x >= TopLeft.x && p.x < TopLeft.x + Width &&
          p.y >= TopLeft.y && p.y < TopLeft.y + Height) {
        count++; 
      }
    }
    return count;
  }

//retourne toutes les particules de ce quadrant et de ses enfants
  ArrayList<Particule> getAllParticles() {
    ArrayList<Particule> all = new ArrayList<Particule>(); //nouvelle liste
    all.addAll(Particules);
    if (HasChildren) for (Quadrant child : Children) all.addAll(child.getAllParticles());
    return all;
  }


  void render() {
    stroke(255, 50);
    noFill();
    rect(TopLeft.x, TopLeft.y, Width, Height);

    if (HasChildren) for (Quadrant child : Children) child.render(); //appel récursif sur les enfants 

    noStroke();
    for (Particule p : Particules) {
      fill(p.c);
      ellipse(p.x, p.y, p.diameter, p.diameter);
    }
  }

  //subdivision du quadrant en enfants si nécessaire
  void GenerateTree() {
    if (CurrentDepth >= MaxDepth) return; //stop si profondeur max atteinte
    if (HasChildren) { for (Quadrant child : Children) child.GenerateTree(); return; }
    if (GetParticles() > MaxParticles) {
      float halfW = Width/2, halfH = Height/2;
      HasChildren = true;
      
      //création des 4 kids
      Children[0] = new Quadrant(new PVector(TopLeft.x, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
      Children[1] = new Quadrant(new PVector(TopLeft.x, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
      Children[2] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
      Children[3] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
      for (Particule p : Particules) RedistributeParticlesOnGenerate(p); //redistribue les particules dans les enfants
      for (Quadrant child : Children) child.GenerateTree(); //appel récursif pour générer l'arbre
      Particules.clear(); 
    }
  }

  //retourne l'indice de l'enfant correspondant à un point (px, py)
  int GetQuadrantIndex(float px, float py) {
    float midX = TopLeft.x + Width/2;
    float midY = TopLeft.y + Height/2;
    if (px < midX) return (py < midY ? 0 : 1);
    else return (py < midY ? 2 : 3);
  }

  //redistribue une particule dans l'enfant approrié après subdivision
  void RedistributeParticlesOnGenerate(Particule p) {
    if (!HasChildren) return;
    int idx = GetQuadrantIndex(p.x, p.y);
    Children[idx].Particules.add(p);
    p.c = Children[idx].quadrantColor;
  }

  //subdivision manuelle du quadrant
  void Subdivide() {
    float halfW = Width/2, halfH = Height/2;
    HasChildren = true;
    Children[0] = new Quadrant(new PVector(TopLeft.x, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1); totalQuadrantsCreated++;
    Children[1] = new Quadrant(new PVector(TopLeft.x, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1); totalQuadrantsCreated++;
    Children[2] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1); totalQuadrantsCreated++;
    Children[3] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1); totalQuadrantsCreated++;

    for (Particule p : Particules) {
      int idx = GetQuadrantIndex(p.x, p.y);
      p.c = Children[idx].quadrantColor;
      Children[idx].Particules.add(p);
    }
    Particules.clear();
  }

  //vérifie si un click touche une cellule d'un bateau
  boolean checkShipHit(float px, float py) {
    int gridX = int((px-10)/cellSize);
    int gridY = int((py-10)/cellSize);
    for (Ship ship : ships) for (PVector cell : ship.cells)
      if (cell.x==gridX && cell.y==gridY) return true;
    return false;
  }

  //ajoute une particule lors d'un clic
  void AddParticleOnClick() {
    if (!HasChildren) {
      boolean hit = checkShipHit(mouseX, mouseY);
      if (hit && CurrentDepth>=4) for (Ship ship : ships) ship.checkHit(mouseX,mouseY);
      Particules.add(new Particule(mouseX, mouseY, hit ? color(255,0,0) : quadrantColor, 10));
      totalParticlesCreated++; // incrémente le compteur
      if (Particules.size()>MaxParticles && CurrentDepth<MaxDepth) Subdivide();
    } else Children[GetQuadrantIndex(mouseX, mouseY)].AddParticleOnClick();
  }
}

//génère les bateaux sur la grille
void generateShips() {
  int[] sizes = {5,4,3,3,2}; //taille des bateaux à placer
  
  //pour chaque bateau
  for (int s : sizes) { 
    boolean placed = false; //indice si le bateau a été placé correctement
    while (!placed) { //boucle jusqu'à emplacement valide
      Ship ship = new Ship(); //crée un nouveau bateau 
      boolean horizontal = random(1) > 0.5; //orientation aléatoire
      int startX = int(random(WindowWidth/cellSize));
      int startY = int(random(WindowHeight/cellSize));
      boolean valid = true; //marque si le placement est valide
      
      //pour chaque bateau
      for (int i=0;i<s;i++){
        int x = startX + (horizontal?i:0);
        int y = startY + (horizontal?0:i);
        
        //vérifie si dans la grille
        if (x>=WindowWidth/cellSize || y>=WindowHeight/cellSize) valid=false;
        
        //vérifie collision avec autres bateaux
        for (Ship other : ships) for (PVector p : other.cells) if (p.x==x && p.y==y) valid=false;
        ship.cells.add(new PVector(x,y)); //ajoute la cellule au bateau
      }
      //si placement est valide, ajoute le bateau à la liste globale et indique que le placement est done
      if (valid) { ships.add(ship); placed=true; }
    }
  }
  
}

//vérifie si tous les bateaux ont été complètement découverts
boolean allShipsDiscovered() {
  
  //pour chaque bateau
  for (Ship ship : ships) { 
    boolean allCellsCovered = true; //suppose que toutes les cellules sont couvertes
    
    //pour chaque cellule du bateau 
    for (PVector cell : ship.cells) {
      boolean hasParticle = false; //vérifie s'il y a une particule sur la cellule
      
      //parcours tuotes les particules
      for (Particule p : QuadrantRacine.getAllParticles()) {
        int gridX = int((p.x-10)/cellSize);
        int gridY = int((p.y-10)/cellSize);
        if (gridX == cell.x && gridY == cell.y) hasParticle = true; //si particule sur la cellule
      }
      if (!hasParticle) allCellsCovered = false; //si une cellule n'a pas de particule, le bateau n'a pas été découvert
    }
    if (!allCellsCovered) return false; //si un bateau n'est pas découvert
  }
  return true; //tous les bateaux sont découverts 
}
