int WindowWidth = 800;
int WindowHeight = 600;

//barre en bas de l'écran pour afficher les stats
int barHeight = 40;  
int usableHeight = WindowHeight - barHeight;  //hauteur dispo pour le quadtree racine

//paramètres du quadtree
int MaxParticles = 4;
int MaxDepth = 6;

//taille des cellules pour les bateaux
int cellSize = 60;

//liste globale des bateaux
ArrayList<Ship> ships = new ArrayList<Ship>();

Quadrant QuadrantRacine;

int totalParticlesCreated = 0;   
int totalQuadrantsCreated = 1;   
boolean gameFinished = false;  

void settings() {
  size(WindowWidth + 20, WindowHeight + 20); //taille de la fenêtre avec marges
}

void setup() {
  PVector QuadrantTopLeft = new PVector(10, 10); //coin supérieur gauche
  QuadrantRacine = new Quadrant(QuadrantTopLeft, WindowWidth, usableHeight, MaxParticles, MaxDepth, 1);
  generateShips(); //génère les bateaux dans la grille
}

void draw() {
  background(0);
  
  //dessine le quadtree et ses particules
  QuadrantRacine.render();

  //dessine tous les bateaux
  for (Ship ship : ships) {
    ship.render();
  }
  
  //vérifie si tous les bateaux sont découverts
  if (!gameFinished && allShipsDiscovered()) {
    gameFinished = true; //stop battleship
  }
  
  //barre noire en bas pour les stats
  fill(0);
  noStroke();
  rect(0, usableHeight + 10, width, barHeight);  
  
  //text blanc pour les stats
  fill(255);
  textSize(16);
  textAlign(LEFT, TOP);
  int padding = 5;
  text("Particules créées: " + totalParticlesCreated, padding, usableHeight + 10 + padding);
  text("Quadrants créés: " + totalQuadrantsCreated, padding, usableHeight + 10 + padding + 20);
  
  //message si tous les bateaux sont trouvés
  if (gameFinished) {
    textAlign(CENTER, TOP);
    fill(0, 255, 0); // vert pour le message
    text("Tous les bateaux sont trouvés !", width/2, usableHeight + 10 + padding);
  }
}

void mouseClicked() {
  QuadrantRacine.AddParticleOnClick(); //ajoute une particule au quadrant correspondant
  QuadrantRacine.GenerateTree(); //subidive si nécessaire
}
