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

int totalParticlesCreated = 0;   // nombre de particules créées
int totalQuadrantsCreated = 1;   // racine déjà créée
boolean gameFinished = false;  

void settings() {
  size(WindowWidth + 20, WindowHeight + 20);
}

void setup() {
  PVector QuadrantTopLeft = new PVector(10, 10);
  QuadrantRacine = new Quadrant(QuadrantTopLeft, WindowWidth, WindowHeight, MaxParticles, MaxDepth, 1);
  
  generateShips(); // maintenant bien défini
}

void draw() {
  background(0);
  
  // render quadtree et particules
  QuadrantRacine.render();

  // render bateaux
  for (Ship ship : ships) {
    ship.render();
  }
  
  // Vérifie si la partie est terminée
  if (!gameFinished && allShipsDiscovered()) {
    gameFinished = true; // stoppe les compteurs
  }
  
  // Barre noire en bas
  fill(0);
  noStroke();
  int barHeight = 40;
  rect(0, height - barHeight, width, barHeight);  // barre sur toute la largeur
  
  // Texte blanc en bas à gauche
  fill(255);
  textSize(16);
  textAlign(LEFT, TOP);
  int padding = 5;
  text("Particules créées: " + totalParticlesCreated, padding, height - barHeight + padding);
  text("Quadrants créés: " + totalQuadrantsCreated, padding, height - barHeight + padding + 20);

  // Message centré si tous les bateaux sont trouvés
  if (gameFinished) {
    textAlign(CENTER, TOP);
    fill(0, 255, 0); // vert pour le message
    text("Tous les bateaux sont trouvés !", width/2, height - barHeight + padding);
  }
}

void mouseClicked() {
  // ajoute la particule au bon quadrant feuille
  QuadrantRacine.AddParticleOnClick();
  // subdivise si nécessaire
  QuadrantRacine.GenerateTree();
}
