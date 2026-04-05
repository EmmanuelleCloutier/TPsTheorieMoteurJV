class Ship {
  // Liste des cellules du bateau (grid)
  ArrayList<PVector> cells = new ArrayList<PVector>();

  Ship() {}

  // Vérifie si une cellule contient une particule (tir)
  boolean hasParticleOnCell(PVector cell) {

    // Convertit cellule → coordonnées écran
    float px = cell.x * cellSize + 10;
    float py = cell.y * cellSize + 10;

    // Requête dans le quadtree (zone de la cellule)
    ArrayList<Particule> particles =
      QuadrantRacine.queryRange(px, py, cellSize, cellSize);

    // Si au moins une particule → touché
    return particles.size() > 0;
  }

  // Vérifie si toutes les cellules du bateau sont touchées
  boolean isFullyDiscovered() {
    for (PVector cell : cells) {
      if (!hasParticleOnCell(cell)) return false;
    }
    return true;
  }

  void render() {

    // Vérifie si le bateau entier est découvert
    boolean allDiscovered = isFullyDiscovered();

    for (PVector cell : cells) {

      boolean hasParticle = hasParticleOnCell(cell);

      if (allDiscovered) {
        // Bateau entièrement trouvé
        fill(0,255,0,200);
        stroke(255);
        strokeWeight(2);
        rect(cell.x*cellSize +10, cell.y*cellSize +10, cellSize, cellSize);
      }
      else if (hasParticle) {
        // Cellule touchée seulement
        fill(255,140,0,220);
        stroke(255);
        strokeWeight(2);
        rect(cell.x*cellSize +10, cell.y*cellSize +10, cellSize, cellSize);
      }
      // Sinon rien 
    }
  }
}
