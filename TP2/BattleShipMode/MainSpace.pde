// ================== MAIN SPACE ==================
int WindowWidth = 800;
int WindowHeight = 600;

// paramètre du quadtree
int MaxParticles = 4;
int MaxDepth = 6;

// taille des cellules pour les bateaux
int cellSize = 40;

// liste globale des bateaux
ArrayList<Ship> ships = new ArrayList<Ship>();

Quadrant QuadrantRacine;

void settings() {
  size(WindowWidth + 20, WindowHeight + 20);
}

void setup() {
  PVector QuadrantTopLeft = new PVector(10, 10);
  QuadrantRacine = new Quadrant(QuadrantTopLeft, WindowWidth, WindowHeight, MaxParticles, MaxDepth, 1);
  
  generateShips();
}

void draw() {
  background(0);
  
  // render quadtree et particules
  QuadrantRacine.render();

  // render bateaux
  for (Ship ship : ships) {
    ship.render();
  }
}

void mouseClicked() {
  // ajoute la particule au bon quadrant feuille
  QuadrantRacine.AddParticleOnClick();
  // subdivise si nécessaire
  QuadrantRacine.GenerateTree();
}

// ================== SHIP ==================
class Ship {
  ArrayList<PVector> cells = new ArrayList<PVector>();
  ArrayList<Boolean> hits = new ArrayList<Boolean>();

  Ship() {}

  void render() {
    noStroke();
    for (int i = 0; i < cells.size(); i++) {
      PVector cell = cells.get(i);
      if (hits.size() > i && hits.get(i)) {
        fill(0, 255, 0, 200); // vert si touché
      } else {
        fill(0, 0, 255, 150); // bleu sinon
      }
      rect(cell.x * cellSize + 10, cell.y * cellSize + 10, cellSize, cellSize);
    }
  }

  void checkHit(float px, float py) {
    int gridX = int((px - 10) / cellSize);
    int gridY = int((py - 10) / cellSize);
    for (int i = 0; i < cells.size(); i++) {
      PVector cell = cells.get(i);
      if (cell.x == gridX && cell.y == gridY) {
        if (hits.size() <= i) hits.add(true);
        else hits.set(i, true);
      }
    }
  }

  boolean isSunkByParticles(ArrayList<Particule> particules) {
    for (PVector cell : cells) {
      boolean covered = false;
      for (Particule p : particules) {
        int gridX = int((p.x - 10) / cellSize);
        int gridY = int((p.y - 10) / cellSize);
        if (gridX == cell.x && gridY == cell.y) {
          covered = true;
          break;
        }
      }
      if (!covered) return false;
    }
    return true;
  }
}
