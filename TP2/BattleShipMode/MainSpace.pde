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
}

void mouseClicked() {
  // ajoute la particule au bon quadrant feuille
  QuadrantRacine.AddParticleOnClick();
  // subdivise si nécessaire
  QuadrantRacine.GenerateTree();
}
