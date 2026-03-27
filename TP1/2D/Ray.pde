class Ray {
  PVector pos;
  PVector dir;
  
  Ray(float x, float y, float angle) {
    pos = new PVector(x, y);
    dir = PVector.fromAngle(angle);
  }
  
  void setPos(float x, float y) {
    pos.set(x, y);
  }

  PVector intersect(Wall w) {
    float x1 = w.x1;
    float y1 = w.y1;
    float x2 = w.x2;
    float y2 = w.y2;

    float x3 = pos.x;
    float y3 = pos.y;
    float x4 = pos.x + dir.x;
    float y4 = pos.y + dir.y;

    float den = (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4);

    if (den == 0) return null;

    float t = ((x1 - x3)*(y3 - y4) - (y1 - y3)*(x3 - x4)) / den;
    float u = -((x1 - x2)*(y1 - y3) - (y1 - y2)*(x1 - x3)) / den;

    if (t > 0 && t < 1 && u > 0) {
      float px = x1 + t * (x2 - x1);
      float py = y1 + t * (y2 - y1);
      return new PVector(px, py);
    } 
    return null;
  }

  void cast(ArrayList<Wall> walls) {
    PVector closest = null;
    float recordValue = Float.MAX_VALUE;
    
    for (Wall w : walls) {
      PVector pt = intersect(w);
      
      if (pt != null) {
        float d = PVector.dist(pos, pt);
        if (d < recordValue) {
          recordValue = d;
          closest = pt;
        }
      }
    }
    
    stroke(255, 255, 0);
    
    if (closest != null) {
      line(pos.x, pos.y, closest.x, closest.y);
    }
  }
}
