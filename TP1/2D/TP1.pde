ArrayList<Wall> walls;
ArrayList<Ray> rays;

void setup() {
  size(800, 600);
  
  walls = new ArrayList<Wall>();
  rays = new ArrayList<Ray>();
  
  for (int i = 0; i < 5; i++) {
    walls.add(new Wall(random(width), random(height), random(width), random(height)));
    
  }
  
  walls.add(new Wall(0,0,width,0));
  walls.add(new Wall(0,0,0,height));
  walls.add(new Wall(0,height,width,height));
  walls.add(new Wall(width,0,width,height));
  
  for (int i = 0; i < 360; i += 2) {
    rays.add(new Ray(width/2, height/2, radians(i)));
  }
}

void draw() {
  background(0);
  
  for (Wall w : walls) {
    w.show();
  }
  
  for (Ray r : rays) {
    r.setPos(mouseX, mouseY);
    r.cast(walls);
  }
}
