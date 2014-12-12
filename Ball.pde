class Ball extends Circle {
  int numero;
  
  Ball (float x, float y, float diametre) {
    super(x, y, diametre);
  }
  
  Ball (PVector position, float diametre) {
    super (position, diametre);
  }
}
