// ================== SHIP ==================
class Ship {
  ArrayList<PVector> cells = new ArrayList<PVector>();
  ArrayList<Boolean> hits = new ArrayList<Boolean>();

  Ship() {}

  void render() {
    for (int i = 0; i < cells.size(); i++) {
      PVector cell = cells.get(i);

      boolean isHit = hits.size() > i && hits.get(i);
      boolean hasParticle = false;

      // Vérifie si une particule est dans cette cellule
      for (Particule p : QuadrantRacine.getAllParticles()) {
        int gridX = int((p.x - 10)/cellSize);
        int gridY = int((p.y - 10)/cellSize);
        if (gridX == cell.x && gridY == cell.y) {
          hasParticle = true;
          break;
        }
      }

      // couleur
      if (isHit) fill(0,255,0,200);           // vert si touché
      else if (hasParticle) fill(255,140,0,220); // orange si particule
      else fill(0,0,255,150);                 // bleu sinon

      rect(cell.x*cellSize +10, cell.y*cellSize +10, cellSize, cellSize);

      // contour blanc pour séparation
      stroke(255);
      strokeWeight(2);
      noFill();
      rect(cell.x*cellSize +10, cell.y*cellSize +10, cellSize, cellSize);
      noStroke();
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
