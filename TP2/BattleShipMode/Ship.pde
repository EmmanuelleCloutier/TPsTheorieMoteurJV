class Ship {
  ArrayList<PVector> cells = new ArrayList<PVector>();
  ArrayList<Boolean> hits = new ArrayList<Boolean>();

  Ship() {} //constructeur vide pour initialiser un bateau 

void render() {
  ArrayList<Particule> allParticles = QuadrantRacine.getAllParticles(); //récupère toutes les particules de l'arbre
  boolean allCellsHaveParticles = true; //indique si toutes les cellules du bateau sont découvertes
  
  //vérifie si toutes les cellules du bateau sont couverte par des particules 
  for (int i = 0; i < cells.size(); i++) {
    PVector cell = cells.get(i);
    boolean hasParticle = false; //falg pour savoir si cete cellule est touchée
    
    //parcours toutes les particules
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

  //dessine chaque cellule du bateau selon son état
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

    //dessine la cellule selon sont état
    if (allCellsHaveParticles) { //si tout le bateau est découvert = vert
      fill(0,255,0,200);    
      stroke(255);
      strokeWeight(2);
      rect(cell.x*cellSize +10, cell.y*cellSize +10, cellSize, cellSize);
    } 
    else if (hasParticle) { //si seulement cette cellule est touchée = orange
      fill(255,140,0,220);   
      stroke(255);
      strokeWeight(2);
      rect(cell.x*cellSize +10, cell.y*cellSize +10, cellSize, cellSize);
    }
     //sinon rien n'est dessiné
  }
}

  //fonction pour enregistrer un coup sur le bateau 
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
