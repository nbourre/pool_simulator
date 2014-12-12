import java.awt.Rectangle;

Ball[] balls;


Rectangle view;

int numberOfBalls = 16;
int ballDiametre = 25;
int whiteBall = 15;

void setup () {
  size (640, 480);
  
  view = new Rectangle (0, 0, width, height);
  
  balls = new Ball[numberOfBalls];
  
  initialiseBalles (new PVector (width / 2, height / 3));

}

void draw () {
  update();
  display();
}

void update () {
  updateBalls();
}

void display () {
  background (255);
  
  displayBalls();
}

void updateBalls() {
  // On déplace les balles en premier
  for (int i = 0; i < numberOfBalls; i++) {
    balls[i].update();
  }
  
  // On calcule les collisions par la suite
  for (int i = 0; i < numberOfBalls; i++) {
    
    for (int j = 0; j < numberOfBalls; j++) {
      if (j != i)
        balls[i].checkCircleCollision(balls[j]);
    }
    // Collision avec le rectangle de l'écran
    int typeCollision = balls[i].checkRectangleCollision(view);
    
    switch (typeCollision) {
      case 1:
        balls[i].velocity.x = -balls[i].velocity.x;
        break;
      case 2:
        balls[i].velocity.y = -balls[i].velocity.y;
        break;
      case 3:
        balls[i].velocity.x = -balls[i].velocity.x;
        break;
      case 4:
        balls[i].velocity.y = -balls[i].velocity.y;
        break;
    }
    
    if (typeCollision > 0)
      balls[i].couleur = color(255, 0, 0);
    else
      balls[i].couleur = color(127);
  }
  
  // On met à jour lorsqu'il y a eu collision
  for (int i = 0; i < numberOfBalls; i++) {
    balls[i].updateCollision();
  }
}

// Displays all the balls;
void displayBalls() {
  for (int i = 0; i < numberOfBalls; i++) {
    balls[i].display();
  }
}

// Initialise le triangle de jeu qui pointe vers le bas;
// Initialise la blance qui est la dernière balle
void initialiseBalles(PVector sommet) {
  int espacement = 2;
  int nbRangees = 5;
  
  float angle = 30 * PI / 180; // Triangle équilatérale
  
  // Déplacement entre chaque rangée
  PVector rowOffset = new PVector ( (ballDiametre + espacement) * sin(angle), (ballDiametre + espacement) * cos (angle));
  
  float offsetHorizontal = rowOffset.x * 2; // Espace entre chaque balle
  int index = 0;
  
  int startIndex = 0;
  for (int j = 0; j < nbRangees; j++) {
    if (index > numberOfBalls) break;
    startIndex = index;
    balls[index++] = new Ball(sommet.x - (j * rowOffset.x), sommet.y - (j * rowOffset.y), ballDiametre);
    
    for (int i = 0; i < j; i++) {
      if (index > numberOfBalls) break;
      balls[index++] = new Ball (balls[startIndex].position.x + ((i + 1) * offsetHorizontal), balls[startIndex].position.y, ballDiametre);
    }
  }
  
  // cueBall
  balls[whiteBall] = new Ball (sommet.x, sommet.y + height / 3, ballDiametre);
  balls[whiteBall].velocity = new PVector (0, -5);
}
