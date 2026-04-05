class Quadrant {
  // Position du coin en haut à gauche du quadrant
  PVector TopLeft;

  // Dimensions du quadrant
  float Width, Height;

  // Paramètres du quadtree
  int MaxDepth, MaxParticles, CurrentDepth;

  // Couleur visuelle du quadrant (debug)
  color quadrantColor; 

  // Indique si le quadrant est subdivisé
  boolean HasChildren = false;

  // Les 4 sous-quadrants (haut-gauche, bas-gauche, haut-droite, bas-droite)
  Quadrant[] Children = new Quadrant[4];

  // Liste des particules contenues dans ce quadrant (si pas subdivisé)
  ArrayList<Particule> Particules = new ArrayList<Particule>();

  // Constructeur : initialise un quadrant avec sa position et ses paramètres
  Quadrant(PVector TopLeft, float Width, float Height, int MaxParticles, int MaxDepth, int CurrentDepth) {
    this.TopLeft = TopLeft;
    this.Width = Width;
    this.Height = Height;
    this.MaxParticles = MaxParticles;
    this.MaxDepth = MaxDepth;
    this.CurrentDepth = CurrentDepth;

    // Couleur aléatoire pour visualiser les zones
    this.quadrantColor = color(random(50,255), random(50,255), random(50,255));
  }

  // Compte combien de particules sont dans ce quadrant
  int GetParticles() {
    int count = 0;

    // Vérifie chaque particule
    for (Particule p : Particules) {

      // Vérifie si elle est bien dans les limites du quadrant
      if (p.x >= TopLeft.x && p.x < TopLeft.x + Width &&
          p.y >= TopLeft.y && p.y < TopLeft.y + Height) {
        count++; 
      }
    }
    return count;
  }

  // Dessine le quadrant + ses particules
  void render() {
    // Dessine le rectangle du quadrant
    stroke(255, 50);
    noFill();
    rect(TopLeft.x, TopLeft.y, Width, Height);

    // Dessine récursivement les enfants si subdivisé
    if (HasChildren)
      for (Quadrant child : Children)
        child.render();

    // Dessine les particules contenues dans ce noeud
    noStroke();
    for (Particule p : Particules) {
      fill(p.c);
      ellipse(p.x, p.y, p.diameter, p.diameter);
    }
  }

  // Génère le quadtree automatiquement selon le nombre de particules
  void GenerateTree() {

    // Stop si profondeur max atteinte
    if (CurrentDepth >= MaxDepth) return;

    // Si déjà subdivisé, continue récursivement
    if (HasChildren) {
      for (Quadrant child : Children)
        child.GenerateTree();
      return;
    }

    // Si trop de particules, subdivision
    if (GetParticles() > MaxParticles) {

      float halfW = Width/2;
      float halfH = Height/2;

      HasChildren = true;

      // Création des 4 sous-quadrants
      Children[0] = new Quadrant(new PVector(TopLeft.x, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
      Children[1] = new Quadrant(new PVector(TopLeft.x, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
      Children[2] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);
      Children[3] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1);

      // Redistribue les particules dans les enfants
      for (Particule p : Particules)
        RedistributeParticlesOnGenerate(p);

      // Continue la génération récursive
      for (Quadrant child : Children)
        child.GenerateTree();

      // Vide la liste locale (elles sont maintenant dans les enfants)
      Particules.clear(); 
    }
  }

  // Retourne dans quel quadrant enfant un point appartient
  int GetQuadrantIndex(float px, float py) {
    float midX = TopLeft.x + Width/2;
    float midY = TopLeft.y + Height/2;

    if (px < midX)
      return (py < midY ? 0 : 1); // gauche
    else
      return (py < midY ? 2 : 3); // droite
  }

  // Place une particule dans le bon enfant après subdivision
  void RedistributeParticlesOnGenerate(Particule p) {
    if (!HasChildren) return;

    int idx = GetQuadrantIndex(p.x, p.y);

    Children[idx].Particules.add(p);

    // Change couleur pour debug visuel
    p.c = Children[idx].quadrantColor;
  }

  // Subdivision immédiate (utilisée lors d'un ajout)
  void Subdivide() {

    float halfW = Width/2;
    float halfH = Height/2;

    HasChildren = true;

    // Création des enfants
    Children[0] = new Quadrant(new PVector(TopLeft.x, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1); totalQuadrantsCreated++;
    Children[1] = new Quadrant(new PVector(TopLeft.x, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1); totalQuadrantsCreated++;
    Children[2] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1); totalQuadrantsCreated++;
    Children[3] = new Quadrant(new PVector(TopLeft.x + halfW, TopLeft.y + halfH), halfW, halfH, MaxParticles, MaxDepth, CurrentDepth+1); totalQuadrantsCreated++;

    // Déplace les particules vers les enfants
    for (Particule p : Particules) {
      int idx = GetQuadrantIndex(p.x, p.y);
      p.c = Children[idx].quadrantColor;
      Children[idx].Particules.add(p);
    }

    Particules.clear();
  }

  // Recherche toutes les particules dans un des quadtrees
  ArrayList<Particule> queryRange(float x, float y, float w, float h) {

    ArrayList<Particule> found = new ArrayList<Particule>();

    // Si ce quadrant ne touche pas la zone → inutile de chercher
    if (TopLeft.x > x + w || TopLeft.x + Width < x ||
        TopLeft.y > y + h || TopLeft.y + Height < y) {
      return found;
    }

    // Vérifie les particules locales
    for (Particule p : Particules) {
      if (p.x >= x && p.x <= x + w &&
          p.y >= y && p.y <= y + h) {
        found.add(p);
      }
    }

    // Recherche récursive dans les enfants
    if (HasChildren) {
      for (Quadrant child : Children) {
        found.addAll(child.queryRange(x, y, w, h));
      }
    }

    return found;
  }

  // Ajoute une particule à la position du clic
  void AddParticleOnClick() {

    // Si pas subdivisé, on ajoute ici
    if (!HasChildren) {

      Particules.add(new Particule(mouseX, mouseY, quadrantColor, 10));
      totalParticlesCreated++;

      // Si trop de particules, subdivision
      if (Particules.size()>MaxParticles && CurrentDepth<MaxDepth)
        Subdivide();

    } else {
      // Sinon on descend dans le bon enfant
      Children[GetQuadrantIndex(mouseX, mouseY)].AddParticleOnClick();
    }
  }
}

void generateShips() {

  int[] sizes = {5,4,3,3,2}; // tailles des bateaux

  int maxGridX = WindowWidth / cellSize;
  int maxGridY = usableHeight / cellSize; 

  // pour chaque bateau
  for (int s : sizes) {

    boolean placed = false;

    // boucle jusqu'à placement valide
    while (!placed) {

      Ship ship = new Ship();

      boolean horizontal = random(1) > 0.5;

      int startX = int(random(maxGridX));
      int startY = int(random(maxGridY));

      // empêche le bateau de sortir de la grille
      if (horizontal) {
        if (startX + s > maxGridX) {
          startX = maxGridX - s;
        }
      } else {
        if (startY + s > maxGridY) {
          startY = maxGridY - s;
        }
      }

      boolean valid = true;

      // création des cellules du bateau
      for (int i = 0; i < s; i++) {

        int x = startX + (horizontal ? i : 0);
        int y = startY + (horizontal ? 0 : i);

        // hors grille 
        if (x >= maxGridX || y >= maxGridY) {
          valid = false;
        }

        // collision avec autres bateaux
        for (Ship other : ships) {
          for (PVector p : other.cells) {
            if (p.x == x && p.y == y) {
              valid = false;
            }
          }
        }

        ship.cells.add(new PVector(x, y));
      }

      // si placement valide
      if (valid) {
        ships.add(ship);
        placed = true;
      }
    }
  }
}

boolean allShipsDiscovered() {
  for (Ship ship : ships) {
    if (!ship.isFullyDiscovered()) return false;
  }
  return true;
}
