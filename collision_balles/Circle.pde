

class Circle {
  private float diametre;
  PVector position;
  PVector velocity;
  PVector acceleration = new PVector (0, 0);
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
    
    // On arrete les deplacements imperceptible
    velocity.x = Math.abs (velocity.x) < 0.001 ? 0 : velocity.x;
    velocity.y = Math.abs(velocity.y) < 0.001 ? 0 : velocity.y;
  }
  
  void display() {
    fill (couleur);
    ellipse (position.x, position.y, diametre, diametre);
  }
  
  // Axis-aligned bounding box collision check... AABBCC ;)
  boolean AABBCC (Circle circle) {
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
    
    if (AABBCC(autre)) {
      PVector vDistance = PVector.sub (autre.position, this.position);
      
      float magnitude = vDistance.mag();
      
      float sumRadius = this.radius + autre.radius;
      
      if (magnitude < sumRadius) {
        
        // si la magnitude est plus petite que la somme des rayons, alors les cercles
        // s'intersecte. On recule le cercle pour empecher de rester poigner dans l'autre
        float deltaPct = (sumRadius - magnitude) / magnitude;
        this.position.x = this.position.x - this.velocity.x * deltaPct;
        this.position.y = this.position.y - this.velocity.y * deltaPct;
        
        float collisionPointX =
            ((this.position.x * autre.radius) + (autre.position.x * this.radius))
            / (this.radius + autre.radius);
        
        float collisionPointY =
            ((this.position.y * autre.radius) + (autre.position.y * this.radius))
            / (this.radius + autre.radius);
        
        result = new PVector (collisionPointX, collisionPointY);
        
        PVector un = result.get();
        un.sub (this.position);
        un.normalize();
        
        PVector ut = new PVector (-un.y, un.x);
        
        float v1n = PVector.dot(un, this.velocity);
        float v1t = PVector.dot(ut, this.velocity);
        float v2n = PVector.dot(un, autre.velocity);
        float v2t = PVector.dot(ut, autre.velocity);

        // Formule
        // (b1.vitesse.x * (b1.mass - b2.mass) + (2 * b2.mass * b2.vitesse.x))
        // / (b1.mass + b2.mass)        
        v1n = (v1n * (this.mass - autre.mass) + 2 * autre.mass * v2n) / (this.mass + autre.mass);
        
        un.mult (v1n);
        ut.mult (v1t);
        
        un.add (ut);
        
        tempVel = un.get();        

//        tempVel.x =
//          (this.velocity.x * (this.mass - autre.mass) + (2 * autre.mass * autre.velocity.x))
//          / (this.mass + autre.mass);
//        tempVel.y =
//          (this.velocity.y * (this.mass - autre.mass) + (2 * autre.mass * autre.velocity.y))
//          / (this.mass + autre.mass);
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
