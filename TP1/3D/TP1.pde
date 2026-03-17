// ============================================================
//  WOLFENSTEIN-STYLE 3D RAYCASTER  —  Processing 3+
//  Controls: WASD to move, mouse to look
// ============================================================

//ArrayList<Wall> walls;
float[][] walls;
ArrayList<Ray> rays;

// ---------- CONSTANTS ----------
final int   NUM_RAYS   = 100;       // one per screen column
final float View        = PI / 3.0;  // 60 degrees
final float MOVE_SPEED = 3.0;
final float ROT_SPEED  = 0.05;
final float SCALE      = 90000;     // wall projection constant
final int   MINIMAP_S  = 5;         // minimap pixel per world pixel

// ---------- PLAYER ----------
float px = 400;    // position
float py = 300;
float pa = 0;      // angle (radians, 0 = facing right)


void setup() {
  size(800, 600);
  noSmooth(); // Désactive l'antialiasing (bien carré et plus performant)
  
  walls = new float[][] {
    // Border walls
    {1,   1,   799, 1  },
    {1,   1,   1,   599},
    {1,   599, 799, 599},
    {799, 1,   799, 599},
    // Interior walls
    {200, 100, 200, 400},
    {300, 400, 600, 400},
    {500, 100, 500, 300},
    {150, 250, 350, 250},
    {600, 150, 700, 350},
  };
}

// ---------- DRAW ----------
void draw() {
  background(0);
  
  handleInput();
  draw3D();
  drawMinimap();

  // HUD
  fill(200);
  noStroke();
  textSize(12);
  text("WASD: move  |  FPS: " + int(frameRate), 8, height - 8);
}

// ---------- INPUT ----------
void handleInput() {
  // Rotation
  if (keyPressed && key == 'a') pa -= ROT_SPEED;
  if (keyPressed && key == 'd') pa += ROT_SPEED;

  // Movement
  float dx = 0, dy = 0;
  if (keyPressed && key == 'w') { dx = cos(pa) * MOVE_SPEED; dy = sin(pa) * MOVE_SPEED; }
  if (keyPressed && key == 's') { dx = -cos(pa) * MOVE_SPEED; dy = -sin(pa) * MOVE_SPEED; }

  float nx = px + dx;
  float ny = py + dy;

  // Boundary check
  if (nx > 10 && nx < width - 10) px = nx;
  if (ny > 10 && ny < height - 10) py = ny;
}

// ---------- RAY-WALL INTERSECTION ----------
// Returns distance t along ray to wall segment, or -1 if no hit.
// Ray: (px,py) + t*(cos a, sin a)
// Wall: (x1,y1) -> (x2,y2) parameterized by s in [0,1]
float castRay(float angle) {
  float rdx = cos(angle);
  float rdy = sin(angle);
  float minDist = Float.MAX_VALUE;

  for (float[] w : walls) {
    float wx = w[2] - w[0];
    float wy = w[3] - w[1];

    float denom = rdx * wy - rdy * wx;
    if (abs(denom) < 1e-6) continue;  // parallel

    float t = ((w[0] - px) * wy - (w[1] - py) * wx) / denom;
    float s = ((w[0] - px) * rdy - (w[1] - py) * rdx) / denom;

    if (t > 0.001 && s >= 0.0 && s <= 1.0) {
      if (t < minDist) minDist = t;
    }
  }

  return (minDist == Float.MAX_VALUE) ? -1 : minDist;
}

// ---------- 3D RENDER ----------
void draw3D() {
  float colW = (float) width / NUM_RAYS;

  for (int i = 0; i < NUM_RAYS; i++) {
    float rayAngle = pa - View / 2.0 + View * ((float) i / NUM_RAYS);

    float rawDist = castRay(rayAngle);
    if (rawDist < 0) continue;

    // Fish-eye correction — flatten the spherical distance into planar
    float dist = rawDist * cos(rayAngle - pa);
    if (dist <= 0) continue;

    // Wall stripe height
    float wallH = SCALE / dist;
    wallH = constrain(wallH, 1, height);

    float top    = height / 2.0 - wallH / 2.0;
    float bottom = height / 2.0 + wallH / 2.0;

    // --- Ceiling ---
    noStroke();
    fill(30, 30, 60);
    rect(i * colW, 0, colW + 1, top);

    // --- Floor ---
    fill(50, 40, 30);
    rect(i * colW, bottom, colW + 1, height - bottom);

    // --- Wall: shaded by distance ---
    float bright = map(dist, 0, 600, 255, 20);
    bright = constrain(bright, 20, 255);

    // Alternate warm/cool tones for side vs front walls (based on ray angle vs cardinal)
    float angleMod = abs(cos(rayAngle * 2));
    fill(bright * 0.85, bright * 0.5 * angleMod + bright * 0.1, 0);
    rect(i * colW, top, colW + 1, wallH);
  }
}

// ---------- MINIMAP ----------
void drawMinimap() {
  int mw = width  / MINIMAP_S;
  int mh = height / MINIMAP_S;
  int ox = 8;
  int oy = 8;
  float mx = ox + px / MINIMAP_S;
  float my = oy + py / MINIMAP_S;

  // Background
  noStroke();
  fill(0, 0, 0, 160);
  rect(ox - 2, oy - 2, mw + 4, mh + 4);

  // Walls
  stroke(255);
  strokeWeight(1);
  for (float[] w : walls) {
    line(ox + w[0]/MINIMAP_S, oy + w[1]/MINIMAP_S,
         ox + w[2]/MINIMAP_S, oy + w[3]/MINIMAP_S);
  }
  
  // Field of view
  cast3D(ox, oy);
  
  // Player dot
  noStroke();
  fill(255, 255, 0);
  circle(mx, my, 5);

  strokeWeight(1);
}

void cast3D(int offsetX, int offsetY) {
    
    // Cone
    stroke(255, 255, 0, 60);
    float mx = offsetX + px / MINIMAP_S;
    float my = offsetY + py / MINIMAP_S;
    float coneLen = 30;
    line(mx, my, mx + cos(pa - View/2) * coneLen, my + sin(pa - View/2) * coneLen);
    line(mx, my, mx + cos(pa + View/2) * coneLen, my + sin(pa + View/2) * coneLen);
    
    // Rays
    stroke(255, 100, 100, 150);strokeWeight(0.5);
    for (int i = 0; i < NUM_RAYS; i++) {
      float rayAngle = pa - View/2 + View * ((float)i / NUM_RAYS);
      float rawDist = castRay(rayAngle);
      
      if (rawDist < 0) continue;
      
      float hitX = px + cos(rayAngle) * rawDist;
      float hitY = py + sin(rayAngle) * rawDist;
      line(mx, my, offsetX + hitX/MINIMAP_S, offsetY + hitY/MINIMAP_S);
    }
  }
