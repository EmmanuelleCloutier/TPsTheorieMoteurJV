class Ray {
  PVector pos;
  PVector dir;
  
  //constructeur du rayon
  Ray(float x, float y, float angle) {
    pos = new PVector(x, y); //position 
    dir = PVector.fromAngle(angle); //direction 
  }
  
  //change la position du rayon
  void setPos(float x, float y) {
    pos.set(x, y);
  }

//calcul l'intersection entre rayon et un murs
  PVector intersect(Wall w) {
    //coords du murs
    float x1 = w.x1;
    float y1 = w.y1;
    float x2 = w.x2;
    float y2 = w.y2;

    //coords du rayon
    float x3 = pos.x;
    float y3 = pos.y;
    float x4 = pos.x + dir.x;
    float y4 = pos.y + dir.y;

    //calcul dénomin pour verifier si les lignes sont parallele 
    float den = (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4);

    // pas d'intersection
    if (den == 0) return null;

    //position sur le murs
    float t = ((x1 - x3)*(y3 - y4) - (y1 - y3)*(x3 - x4)) / den;
    
    //position sur le rayon
    float u = -((x1 - x2)*(y1 - y3) - (y1 - y2)*(x1 - x3)) / den;

    //vérifie si l'intersection est valide
    if (t > 0 && t < 1 && u > 0) {
      //calcul le point d'intersection
      float px = x1 + t * (x2 - x1);
      float py = y1 + t * (y2 - y1);
      
      //return le point
      return new PVector(px, py);
    } 
    //si aucune intersection
    return null;
  }

  //lance le rayon et trouve le murs le plus proche
  void cast(ArrayList<Wall> walls) {
    PVector closest = null; //ppoint d'intersection le plus proche
    float recordValue = Float.MAX_VALUE; //distance minimale
    
    //vérifie tous les murs
    for (Wall w : walls) {
      //calcul intersection
      PVector pt = intersect(w);
      
      //si intersection existe
      if (pt != null) {
        //distance entre le rayon et le point
        float d = PVector.dist(pos, pt);
        
        //si le plus proche que le precedent
        if (d < recordValue) {
          recordValue = d;
          closest = pt;
        }
      }
    }
    
    //couleur jaune
    stroke(255, 255, 0);
    
    //si un point d'intersection a été trouvé
    if (closest != null) {
      line(pos.x, pos.y, closest.x, closest.y);
    }
  }
}
