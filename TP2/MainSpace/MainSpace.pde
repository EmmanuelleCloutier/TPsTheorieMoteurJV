int WindowWidth = 800;
int WindowHeight = 600;
int MaxParticles = 4;
Quadrant QuadrantRacine;

void settings()
{
    size(WindowWidth + 20, WindowHeight + 20);
    
}

void setup()
{
  PVector QuadrantTopLeft = new PVector(0 + 10, 0 + 10);
  QuadrantRacine = new Quadrant(QuadrantTopLeft, WindowWidth, WindowHeight, MaxParticles, 10);
  QuadrantRacine.render();
}

void draw(){}

void mouseClicked() {
  println("");
  println("********************OnClicked********************");

  // Ajoute la particule au bon quadrant feuille
  QuadrantRacine.AddParticleOnClick();
  println("********************AddParticleOnClick() OVER********************");
  
  // Vérifie si la racine ou ses enfants doivent se subdiviser
  QuadrantRacine.GenerateTree(0);
  println("********************GenerateTree() OVER********************");
}
