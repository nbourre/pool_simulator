

class Circle {
  private float diametre;
  PVector position;
  PVector velocity;
  float radius;
  float mass = 1;
  
  color couleur = color (127);
  
  Circle (float x, float y, float diametre) {
    this.diametre = diametre;
    
    position = new PVector (x, y);
    velocity = new PVector (0, 0);
    radius = diametre / 2;
  }
  
  Circle (PVector position, float diametre) {
    this.position = position;
    this.diametre = diametre;
    
    velocity = new PVector (0, 0);
    radius = diametre / 2;
  }
  
  void setDiametre (float diametre) {
    this.diametre = diametre;
    this.radius = diametre / 2;
  }
  
  float getDiametre () {
    return diametre;
  }
  
  void update() {
    position.add(velocity);
  }
  
  void display() {
    fill (couleur);
    ellipse (position.x, position.y, diametre, diametre);
  }
  
  boolean checkRectangleCollision (Circle circle) {
    float x = position.x - radius;
    float y = position.y - radius;
    
    float otherX = circle.position.x - circle.radius;
    float otherY = circle.position.y - circle.radius;
    
    return
      x < otherX + circle.getDiametre() &&
      x + diametre > otherX &&
      y < otherY + circle.getDiametre() &&
      y + diametre > otherY;
  }
  
  // Resultats :
  // Gauche : 1, Haut : 2, Droit : 3, Bas : 4, Aucun : 0
  
  int checkRectangleCollision (Rectangle r) {
    float x = position.x - radius;
    float y = position.y - radius;
    
    int result = 0;
    
    if (x < r.x)
      result = 1;
    else if (x + diametre > r.x + r.width)
      result = 3;
    else if (y < r.y)
      result = 2;
    else if (y + diametre > r.y + r.height)
      result = 4;

    return result;
  }
  
  // Keep velocity temporary
  PVector tempVel = null;
  
  
  PVector checkCircleCollision (Circle autre) {
    PVector result = null;
    
    if (checkRectangleCollision(autre)) {
      PVector vDistance = PVector.sub (autre.position, this.position);
      
      float magnitude = vDistance.mag();
      
      if (magnitude < this.radius + autre.radius) {
        
        float collisionPointX =
            ((this.position.x * autre.radius) + (autre.position.x * this.radius))
            / (this.radius + autre.radius);
        
        float collisionPointY =
            ((this.position.y * autre.radius) + (autre.position.y * this.radius))
            / (this.radius + autre.radius);
        
        result = new PVector (collisionPointX, collisionPointY);                        
        
        tempVel = new PVector();
        
        // Formule
        // (b1.vitesse.x * (b1.mass - b2.mass) + (2 * b2.mass * b2.vitesse.x))
        // / (b1.mass + b2.mass)
        tempVel.x =
          (this.velocity.x * (this.mass - autre.mass) + (2 * autre.mass * autre.velocity.x))
          / (this.mass + autre.mass);
        tempVel.y =
          (this.velocity.y * (this.mass - autre.mass) + (2 * autre.mass * autre.velocity.y))
          / (this.mass + autre.mass);
      }      
    }
    
    return result;
  }
  
  void updateCollision() {
    
    if (tempVel != null) {
      this.velocity.x = tempVel.x;
      this.velocity.y = tempVel.y;
      
      tempVel = null;
    }
  }
  
}
