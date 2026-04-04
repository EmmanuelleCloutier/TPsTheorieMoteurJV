void generateShips() {
  int[] sizes = {5,4,3,3,2};
  for (int s : sizes) {
    boolean placed = false;
    while (!placed) {
      Ship ship = new Ship();
      boolean horizontal = random(1) > 0.5;
      int startX = int(random(WindowWidth / cellSize));
      int startY = int(random(WindowHeight / cellSize));
      boolean valid = true;
      for (int i = 0; i < s; i++) {
        int x = startX + (horizontal ? i : 0);
        int y = startY + (horizontal ? 0 : i);
        if (x >= WindowWidth / cellSize || y >= WindowHeight / cellSize) valid = false;
        for (Ship other : ships) for (PVector p : other.cells) if (p.x==x && p.y==y) valid=false;
        ship.cells.add(new PVector(x,y));
      }
      if (valid) {
        ships.add(ship);
        placed = true;
      }
    }
  }
}
