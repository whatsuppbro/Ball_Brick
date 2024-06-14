int paddleWidth = 90;
int paddleHeight = 20;
int paddleSpeed = 7;
int ballSize = 20;
int ballSpeedX = 2;
int ballSpeedY = 4;
int brickRows = 3;
int brickCols = 10;
int brickWidth = 69;
int brickHeight = 20;
int brickPadding = 10;
int currentScore = 0;
int[] highScores = new int[3];
int lives = 3;

PImage menuBackground;
PImage titleImage;
PImage gameBackground;
PImage paddleImage;
PImage ballImage;
PImage brickImage;
PFont pixeloidFont;

String gameState = "menu";
int difficulty = 1;

boolean win = false;
boolean gameOver = false;

PVector paddlePos;
PVector ballPos;
boolean[][] bricks;

color backgroundColor = color(30);
color textColor = color(255);
color buttonColor = color(173, 165, 255);
color shadowColor = color(50);

void drawShadow(float x, float y, float w, float h) {
  fill(shadowColor);
  rect(x + 5, y + 5, w, h);
}

//function setup
void setup() {
  size(800, 600);
  pixeloidFont = createFont("./PixeloidMono-VGj6x.ttf",16);
  textFont(pixeloidFont);
  menuBackground = loadImage("./background.png");
  titleImage = loadImage("./logo.png");
  gameBackground = loadImage("./background2.png");
  paddleImage = loadImage("paddle1.png");
  ballImage = loadImage("ball.png");
  brickImage = loadImage("brick.png");
  
  paddlePos = new PVector(width / 2 - paddleWidth / 2, height - paddleHeight - 20);
  ballPos = new PVector(width / 2, height / 2);
  bricks = new boolean[brickRows][brickCols];
  for (int i = 0; i < brickRows; i++) {
    for (int j = 0; j < brickCols; j++) {
      bricks[i][j] = true;
    }
  }
  resetGame();
}
//function Menu
void drawMenu() {
  image(menuBackground, 0, 0, width, height);
  float titleX = width / 2 - titleImage.width / 2;
  float titleY = height / 4 - titleImage.height / 2;
  image(titleImage, titleX, titleY);

  String[] difficulties = {"Easy", "Normal", "Hard"};
  float buttonWidth = 200;
  float buttonHeight = 50;

  for (int i = 0; i < difficulties.length; i++) {
    float buttonX = (width - buttonWidth) / 2;
    float buttonY = (height / 2) - buttonHeight + (i * (buttonHeight + 20));

    drawShadow(buttonX, buttonY, buttonWidth, buttonHeight);
    fill(buttonColor);
    rect(buttonX, buttonY, buttonWidth, buttonHeight);

    textSize(24);
    fill(textColor);
    textAlign(CENTER, CENTER);
    text(difficulties[i], width / 2, buttonY + buttonHeight / 2);

    if (mousePressed &&
      mouseX > buttonX && mouseX < buttonX + buttonWidth &&
      mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      difficulty = i + 1;
      resetGame();
      gameState = "play";
    }
  }
}

//function drawGame
void drawGame() {
  image(gameBackground, 0, 0, width, height);
  image(paddleImage, paddlePos.x, paddlePos.y, paddleWidth, paddleHeight);
  image(ballImage, ballPos.x, ballPos.y, ballSize, ballSize);
  textSize(15);
  fill(textColor);
  text("Score: " + currentScore, 50, height - 150); //Score
  text("High Score: " + highScores[difficulty - 1], 75, height - 120); //High Score
  text("Lives: " + lives, 50, height - 180);

  for (int i = 0; i < brickRows; i++) {
    for (int j = 0; j < brickCols; j++) {
      if (bricks[i][j]) {
        float brickX = j * (brickWidth + brickPadding) + brickPadding;
        float brickY = i * (brickHeight + brickPadding) + brickPadding;
        
        image(brickImage, brickX, brickY, brickWidth, brickHeight);
      }
    }
  }
  if (gameOver || win) {
    textSize(60);
    textAlign(CENTER, CENTER);
    fill(#FEF600);
    text(gameOver ? "Game Over!" : "You Win!", width / 2, height / 2);

    noStroke();
    float buttonWidth = 200;
    float buttonHeight = 50;
    float buttonX = (width - buttonWidth) / 2;
    float buttonY = (height / 2) + 50;
    drawShadow(buttonX, buttonY, buttonWidth, buttonHeight);
    fill(buttonColor);
    rect(buttonX, buttonY, buttonWidth, buttonHeight);
    textSize(20);
    fill(textColor);
    text("Restart", width / 2, buttonY + buttonHeight / 2);

// Add a button to go back to the difficulty selection screen
    buttonY += buttonHeight + 20;
    drawShadow(buttonX, buttonY, buttonWidth, buttonHeight);
    fill(buttonColor);
    rect(buttonX, buttonY, buttonWidth, buttonHeight);
    textSize(20);
    fill(textColor);
    text("Menu", width / 2, buttonY + buttonHeight / 2);

if (mousePressed) {
      if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
        gameState = "menu";
      } else if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY - buttonHeight - 20 && mouseY < buttonY) {
        resetGame();
      }
    }
}//End if over or win
}//End drawGame

//function Draw
void draw() {
  if (gameState.equals("menu")) {
    drawMenu();
  } else if (gameState.equals("play")) {
    updateGame();
    drawGame();
  }
}
//function updateGame
void updateGame() {
  if (!gameOver && !win) {
    if (keyPressed) {
      if (key == 'a' || key == 'A') {
        paddlePos.x -= paddleSpeed;
      }
      if (key == 'd' || key == 'D') {
        paddlePos.x += paddleSpeed;
      }
    }
    if (paddlePos.x < 0) {
      paddlePos.x = 0;
    }
    if (paddlePos.x + paddleWidth > width) {
      paddlePos.x = width - paddleWidth;
    }

    ballPos.x += ballSpeedX;
    ballPos.y += ballSpeedY;
    
    if (ballPos.x < 0 || ballPos.x + ballSize > width) {
  ballSpeedX *= -1;
}
if (ballPos.y < 0) {
  ballSpeedY *= -1;
}

if (ballPos.y + ballSize > paddlePos.y && ballPos.y + ballSize < paddlePos.y + paddleHeight &&
    ballPos.x + ballSize > paddlePos.x && ballPos.x < paddlePos.x + paddleWidth) {
  ballSpeedY *= -1;
}

if (ballPos.y + ballSize > height) {
  lives -= 1;
  if (lives <= 0) {
    gameOver = true;
  } else {
    resetBall();
  }
}


for (int i = 0; i < brickRows; i++) {
  for (int j = 0; j < brickCols; j++) {
    if (bricks[i][j]) {
      float brickX = j * (brickWidth + brickPadding) + brickPadding;
      float brickY = i * (brickHeight + brickPadding) + brickPadding;
      if (ballPos.x + ballSize > brickX && ballPos.x < brickX + brickWidth &&
          ballPos.y + ballSize > brickY && ballPos.y < brickY + brickHeight) {
        bricks[i][j] = false;
        ballSpeedY *= -1;
        currentScore += 1;
      }
    }
  }
}

if (ballPos.y + ballSize > height) {
  gameOver = true;
}
int remainingBricks = 0;
for (int i = 0; i < brickRows; i++) {
  for (int j = 0; j < brickCols; j++) {
    if (bricks[i][j]) {
      remainingBricks++;
    }
  }
}
if (remainingBricks == 0) {
  win = true;
}
}
}

void resetBall() {
  ballPos = new PVector(width / 2, height / 2);
  ballSpeedY *= -1;
}

//function resetGame
void resetGame() {
  paddlePos = new PVector(width / 2 - paddleWidth / 2, height - paddleHeight - 20);
  ballPos = new PVector(width / 2, height / 2);
  gameOver = false;
  lives = 3;
  win = false;
  if (currentScore > highScores[difficulty - 1]) {
  highScores[difficulty - 1] = currentScore;
  }
  currentScore = 0;

  switch (difficulty) {
    case 1:
      ballSpeedX = 5;
      ballSpeedY = 7;
      break;
    case 2:
      ballSpeedX = 8;
      ballSpeedY = 10;
      paddleSpeed = 10;
      lives = 2;
      break;
    case 3:
      ballSpeedX = 10;
      ballSpeedY = 12;
      paddleSpeed = 14;
      lives = 1;
      break;
  }

  for (int i = 0; i < brickRows; i++) {
    for (int j = 0; j < brickCols; j++) {
      bricks[i][j] = true;
    }
  }
}
