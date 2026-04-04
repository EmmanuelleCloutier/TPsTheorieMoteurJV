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

void render() {
    // === Draw quadrant border ===
    stroke(255, 50); // lignes semi-transparentes
    noFill();
    rect(TopLeft.x, TopLeft.y, Width, Height);

    // === Draw ships inside this quadrant BEFORE children ===
    for (Ship ship : ships) {
      boolean sunk = ship.isSunkByParticles(Particules);
      for (PVector cell : ship.cells) {
        float cellX = cell.x * cellSize + 10;
        float cellY = cell.y * cellSize + 10;
        if (cellX >= TopLeft.x && cellX < TopLeft.x + Width &&
            cellY >= TopLeft.y && cellY < TopLeft.y + Height) {
          if (sunk) fill(0, 255, 0, 200);
          else fill(0, 0, 255, 150);
          noStroke();
          rect(cellX, cellY, cellSize, cellSize);
        }
      }
    }

    // === Render children recursively ===
    if (HasChildren) {
      for (Quadrant child : Children) {
        child.render();
      }
    }

    // === Draw particles ON TOP of everything ===
    noStroke();
    for (Particule p : Particules) {
      fill(p.c);
      ellipse(p.x, p.y, p.diameter, p.diameter);
    }
}
  void GenerateTree() {
    if (CurrentDepth >= MaxDepth) return;

    if (HasChildren) {
      for (Quadrant child : Children) child.GenerateTree();
      return;
    }

    if (GetParticles() > MaxParticles) {
      float halfW = Width / 2;
      float halfH = Height / 2;
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
    float midX = TopLeft.x + Width / 2;
    float midY = TopLeft.y + Height / 2;
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
    float halfW = Width / 2;
    float halfH = Height / 2;
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
    int gridX = int((px - 10) / cellSize);
    int gridY = int((py - 10) / cellSize);
    for (Ship ship : ships) {
      for (PVector cell : ship.cells) {
        if (cell.x == gridX && cell.y == gridY) return true;
      }
    }
    return false;
  }

  void AddParticleOnClick() {
    if (!HasChildren) {
      boolean hit = checkShipHit(mouseX, mouseY);
      if (hit && CurrentDepth >= 4) {
        Particules.add(new Particule(mouseX, mouseY, color(255,0,0), 10));
      } else {
        Particules.add(new Particule(mouseX, mouseY, quadrantColor, 10));
      }
      if (Particules.size() > MaxParticles && CurrentDepth < MaxDepth) Subdivide();
    } else {
      int idx = GetQuadrantIndex(mouseX, mouseY);
      Children[idx].AddParticleOnClick();
    }
  }
}
