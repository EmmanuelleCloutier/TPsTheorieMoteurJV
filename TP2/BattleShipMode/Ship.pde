// ================== SHIP ==================
class Ship {
  ArrayList<PVector> cells = new ArrayList<PVector>();
  ArrayList<Boolean> hits = new ArrayList<Boolean>();

  Ship() {}

void render() {
  ArrayList<Particule> allParticles = QuadrantRacine.getAllParticles();
  boolean allCellsHaveParticles = true;
  
  // Vérifie si tout le bateau est découvert
  for (int i = 0; i < cells.size(); i++) {
    PVector cell = cells.get(i);
    boolean hasParticle = false;
    for (Particule p : allParticles) {
      int gridX = int((p.x - 10)/cellSize);
      int gridY = int((p.y - 10)/cellSize);
      if (gridX == cell.x && gridY == cell.y) {
        hasParticle = true;
        break;
      }
    }
    if (!hasParticle) allCellsHaveParticles = false;
  }

  // Dessine chaque cellule selon son état
  for (int i = 0; i < cells.size(); i++) {
    PVector cell = cells.get(i);
    //boolean isHit = hits.size() > i && hits.get(i);

    boolean hasParticle = false;
    for (Particule p : allParticles) {
      int gridX = int((p.x - 10)/cellSize);
      int gridY = int((p.y - 10)/cellSize);
      if (gridX == cell.x && gridY == cell.y) {
        hasParticle = true;
        break;
      }
    }

    // couleur et contour seulement si touché ou découvert
    if (allCellsHaveParticles) {
      fill(0,255,0,200);     // vert si bateau entier découvert
      stroke(255);
      strokeWeight(2);
      rect(cell.x*cellSize +10, cell.y*cellSize +10, cellSize, cellSize);
    } 
    else if (hasParticle) {
      fill(255,140,0,220);    // orange si touché
      stroke(255);
      strokeWeight(2);
      rect(cell.x*cellSize +10, cell.y*cellSize +10, cellSize, cellSize);
    }
    // sinon : rien n'est dessiné (pas de contour, pas de couleur)
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
}
