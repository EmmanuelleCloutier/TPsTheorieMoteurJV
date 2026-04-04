//taille de la zone du quadtree
int WindowWidth = 800;
int WindowHeight = 600;

//parametre du quadtree
int MaxParticles = 4;
int MaxDepth = 6;

//racine 
Quadrant QuadrantRacine;

void settings()
{
    size(WindowWidth + 20, WindowHeight + 20);
    
}

void setup()
{
  //position du coin en haut gauche
  PVector QuadrantTopLeft = new PVector(0 + 10, 0 + 10);
  //creation du quadtree racine
  QuadrantRacine = new Quadrant(QuadrantTopLeft, WindowWidth, WindowHeight, MaxParticles, MaxDepth, 1);
  
}

void draw(){
  background(0); 
  
  //dessine tout le quadtree recursif
  QuadrantRacine.render();
}

void mouseClicked() {
  println("\n********************OnClicked********************");

  // Ajoute la particule au bon quadrant feuille
  QuadrantRacine.AddParticleOnClick();
  println("********************AddParticleOnClick() OVER********************");
  
  // Vérifie si la racine ou ses enfants doivent se subdiviser
  QuadrantRacine.GenerateTree();
  println("********************GenerateTree() OVER********************");
}
