// ================== QUADRANT ==================
class Quadrant {
  PVector TopLeft;
  float Width, Height;
  int MaxDepth, MaxParticles, CurrentDepth;
  color quadrantColor;
  boolean HasChildren = false;
  Quadrant[] Children = new Quadrant[4];
  ArrayList<Particule> Particules = new ArrayList<Particule>();

  Quadrant(PVector TopLeft, float Width, float Height, int MaxParticles, int MaxDepth, int CurrentDepth) {
    this.TopLeft = TopLeft;
    this.Width = Width;
    this.Height = Height;
    this.MaxParticles = MaxParticles;
    this.MaxDepth = MaxDepth;
    this.CurrentDepth = CurrentDepth;
    this.quadrantColor = color(random(50,255), random(50,255), random(50,255));
  }

  int GetParticles() {
    int count = 0;
    for (Particule p : Particules) {
      if (p.x >= TopLeft.x && p.x < TopLeft.x + Width &&
          p.y >= TopLeft.y && p.y < TopLeft.y + Height) {
        count++;
      }
    }
    return count;
  }

  ArrayList<Particule> getAllParticles() {
    ArrayList<Particule> all = new ArrayList<Particule>();
    all.addAll(Particules);
    if (HasChildren) for (Quadrant child : Children) all.addAll(child.getAllParticles());
    return all;
  }

  void render() {
    stroke(255, 50);
    noFill();
    rect(TopLeft.x, TopLeft.y, Width, Height);

    for (Ship ship : ships) {
      for (int i = 0; i < ship.cells.size(); i++) {
        PVector cell = ship.cells.get(i);
        float cellX = cell.x * cellSize + 10;
        float cellY = cell.y * cellSize + 10;
        if (cellX >= TopLeft.x && cellX < TopLeft.x + Width &&
            cellY >= TopLeft.y && cellY < TopLeft.y + Height) {
          if (i < ship.hits.size() && ship.hits.get(i)) fill(255,140,0,220);
          else fill(0,0,255,150);
          noStroke();
          rect(cellX, cellY, cellSize, cellSize);
        }
      }
    }

    if (HasChildren) for (Quadrant child : Children) child.render();

    noStroke();
    for (Particule p : Particules) {
      fill(p.c);
      ellipse(p.x, p.y, p.diameter, p.diameter);
    }
  }

  void GenerateTree() {
    if (CurrentDepth >= MaxDepth) return;
    if (HasChildren) { for (Quadrant child : Children) child.GenerateTree(); return; }
    if (GetParticles() > MaxParticles) {
      float halfW = Width/2, halfH = Height/2;
      HasChildren = true;
      Children[0] = new Quadrant(new PVector(TopLeft.x, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
      Children[1] = new Quadrant(new PVector(TopLeft.x, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
      Children[2] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
      Children[3] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
      for (Particule p : Particules) RedistributeParticlesOnGenerate(p);
      for (Quadrant child : Children) child.GenerateTree();
      Particules.clear();
    }
  }

  int GetQuadrantIndex(float px, float py) {
    float midX = TopLeft.x + Width/2;
    float midY = TopLeft.y + Height/2;
    if (px < midX) return (py < midY ? 0 : 1);
    else return (py < midY ? 2 : 3);
  }

  void RedistributeParticlesOnGenerate(Particule p) {
    if (!HasChildren) return;
    int idx = GetQuadrantIndex(p.x, p.y);
    Children[idx].Particules.add(p);
    p.c = Children[idx].quadrantColor;
  }

  void Subdivide() {
    float halfW = Width/2, halfH = Height/2;
    HasChildren = true;
    Children[0] = new Quadrant(new PVector(TopLeft.x, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
    Children[1] = new Quadrant(new PVector(TopLeft.x, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
    Children[2] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
    Children[3] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);

    for (Particule p : Particules) {
      int idx = GetQuadrantIndex(p.x, p.y);
      p.c = Children[idx].quadrantColor;
      Children[idx].Particules.add(p);
    }
    Particules.clear();
  }

  boolean checkShipHit(float px, float py) {
    int gridX = int((px-10)/cellSize);
    int gridY = int((py-10)/cellSize);
    for (Ship ship : ships) for (PVector cell : ship.cells)
      if (cell.x==gridX && cell.y==gridY) return true;
    return false;
  }

  void AddParticleOnClick() {
    if (!HasChildren) {
      boolean hit = checkShipHit(mouseX, mouseY);
      if (hit && CurrentDepth>=4) for (Ship ship : ships) ship.checkHit(mouseX,mouseY);
      Particules.add(new Particule(mouseX, mouseY, hit ? color(255,0,0) : quadrantColor, 10));
      if (Particules.size()>MaxParticles && CurrentDepth<MaxDepth) Subdivide();
    } else Children[GetQuadrantIndex(mouseX, mouseY)].AddParticleOnClick();
  }
}

// ================== GENERATE SHIPS ==================
void generateShips() {
  int[] sizes = {5,4,3,3,2};
  for (int s : sizes) {
    boolean placed = false;
    while (!placed) {
      Ship ship = new Ship();
      boolean horizontal = random(1) > 0.5;
      int startX = int(random(WindowWidth/cellSize));
      int startY = int(random(WindowHeight/cellSize));
      boolean valid = true;
      for (int i=0;i<s;i++){
        int x = startX + (horizontal?i:0);
        int y = startY + (horizontal?0:i);
        if (x>=WindowWidth/cellSize || y>=WindowHeight/cellSize) valid=false;
        for (Ship other : ships) for (PVector p : other.cells) if (p.x==x && p.y==y) valid=false;
        ship.cells.add(new PVector(x,y));
      }
      if (valid) { ships.add(ship); placed=true; }
    }
  }
}
