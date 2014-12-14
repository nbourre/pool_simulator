class Table {
  
  
  Rectangle surface;  
  color surfaceColor;
  Table(Rectangle r) {
    surface = new Rectangle(r.x, r.y, r.width, r.height);
    surfaceColor = color (76, 130, 17);
  }
  
  void display() {
    fill(surfaceColor);
    stroke(0);
    rect (surface.x, surface.y, surface.width, surface.height);
  }
  
}
