// ================== SHIP ==================
class Ship {
  ArrayList<PVector> cells = new ArrayList<PVector>();
  ArrayList<Boolean> hits = new ArrayList<Boolean>();

  Ship() {}

void render() {
  for (int i = 0; i < cells.size(); i++) {
    PVector cell = cells.get(i);
    
    // couleur selon hit ou pas
    if (hits.size() > i && hits.get(i)) {
      fill(0, 255, 0, 200); // vert si touché
    } else {
      fill(0, 0, 255, 150); // bleu sinon
    }

    // dessiner le rectangle rempli
    rect(cell.x * cellSize + 10, cell.y * cellSize + 10, cellSize, cellSize);
    
    // ajouter le contour blanc pour séparation
    stroke(255);       // blanc
    strokeWeight(2);   // épaisseur de la ligne
    noFill();          // juste le contour
    rect(cell.x * cellSize + 10, cell.y * cellSize + 10, cellSize, cellSize);
    
    noStroke();        // reset pour la prochaine cellule
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
