//listes qui contient murs et une autre pour rayons
ArrayList<Wall> walls;
ArrayList<Ray> rays;

void setup() {
  //pour définir la fenêtre
  size(800, 600);
  
  //Initialisation des listes
  walls = new ArrayList<Wall>();
  rays = new ArrayList<Ray>();
  
  //boucle pour crée 5 murs randoms
  for (int i = 0; i < 5; i++) {
    walls.add(new Wall(random(width), random(height), random(width), random(height)));
    
  }
  
  //ajout des murs au bord de l'écran
  walls.add(new Wall(0,0,width,0));
  walls.add(new Wall(0,0,0,height));
  walls.add(new Wall(0,height,width,height));
  walls.add(new Wall(width,0,width,height));
  
  //boucle pour crée des rayons genre toutes 
  for (int i = 0; i < 360; i += 2) {
    //rayon qui par du centre, avec un angle different
    rays.add(new Ray(width/2, height/2, radians(i)));
  }
}

void draw() {
  //background couleur noir
  background(0);
  
  //affiche les murs
  for (Wall w : walls) {
    w.show();
  }
  
  //ray casting
  for (Ray r : rays) {
    r.setPos(mouseX, mouseY);
    r.cast(walls);
  }
}
