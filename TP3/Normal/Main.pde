float anchorX, anchorY;     // ancrage fixe en haut
float posX, posY;        // position de la boule
float velX = 0;
float velY = 0;

float restLength = 220;     // longueur naturelle du ressort
float k = 0.03;             // raideur du ressort
float damping = 0.98;       // amortissement (s'arrête plus ou moins vite)
float gravity = 0.4;        // gravité

float ballRadius = 20;
float anchorWidth = 30;

boolean draggingBall = false;

void setup() {
  size(650, 550);
  
  anchorX = width/2;
  anchorY = 50;

  posX = anchorX;
  posY = anchorY + restLength;
}

void draw() {
  background(220);

  if (!draggingBall) {
    updatePhysics();
  } else {
    // pendant le drag, la boule suit la souris
    posX = mouseX;
    posY = mouseY;

    // on annule la vitesse pendant qu'on tient la boule
    velX = 0;
    velY = 0;
  }
  
  drawAnchor();
  drawSpring(anchorX, anchorY + 5, posX, posY, 18, 18);
  drawBall();
}

void updatePhysics() {
  float dx = posX - anchorX;
  float dy = posY - anchorY;
  
  float currentLength = sqrt(dx*dx + dy*dy);
  
  if (currentLength > 0) {
    float stretch = currentLength - restLength;

    float dirX = dx / currentLength;
    float dirY = dy / currentLength;

    float forceX = -k * stretch * dirX;
    float forceY = -k * stretch * dirY;

    velX += forceX;
    velY += forceY;
  }
  
  velY += gravity;

  velX *= damping;
  velY *= damping;

  posX += velX;
  posY += velY;
}

void drawAnchor() {
  stroke(80);
  strokeWeight(6);
  line(anchorX - anchorWidth/2, anchorY, anchorX + anchorWidth/2, anchorY);
}

void drawBall() {
  fill(180);
  stroke(50);
  strokeWeight(1);
  ellipse(posX, posY, ballRadius*2, ballRadius*2);
}

void drawSpring(float x1, float y1, float x2, float y2, float amp, int zigzags) {
  stroke(0);
  strokeWeight(2);
  noFill();

  //Direction du ressort
  float dx = x2 - x1;
  float dy = y2 - y1;
  float len = sqrt(dx*dx + dy*dy);

  if (len == 0) return;

  //Normalisation
  float ux = dx / len;
  float uy = dy / len;

  //Vecteur perpendiculaire au ressort pour les mouvements à gauche et droite 
  float px = -uy;
  float py = ux;

  beginShape();
  vertex(x1, y1);

  for (int i = 1; i < zigzags; i++) {
    float t = i / float(zigzags);
    float baseX = lerp(x1, x2, t);
    float baseY = lerp(y1, y2, t);

    float side = (i % 2 == 0) ? -amp : amp; //-amp = gauche | amp = droite

    //Décalage
    float zx = baseX + px * side;
    float zy = baseY + py * side;

    vertex(zx, zy);
  }

  vertex(x2, y2); //dernière ligne avant la boule 
  endShape();
}

void mousePressed() {
  float d = dist(mouseX, mouseY, posX, posY);

  if (d < ballRadius) {
    draggingBall = true;
  }
}

void mouseReleased() {
  draggingBall = false;
}
