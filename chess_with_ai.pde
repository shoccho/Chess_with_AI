Board board;
Boolean moving =false;
int tileSize = 75;
Piece movingPiece;
Boolean whitesMove = true;
int moveCounter = 10;
ArrayList<PImage> images ;
Boolean whiteAI = false;
Boolean blackAI = true;

//depthPara;
//depthPlus;
//depthMinus;
int tempMaxDepth;
void setup() {
  size(600, 600);
  images=new ArrayList<PImage>(); 
  for (int i = 1; i < 10; i++) {
    images.add(loadImage("assets/2000px-Chess_Pieces_Sprite_0" + i + ".png"));
  }
  for (int i = 10; i < 13; i++) {
    images.add(loadImage("assets/2000px-Chess_Pieces_Sprite_" + i + ".png"));
  }
  board = new Board();
}

void draw() {
  background(100);
  showGrid();
  board.show();
}

void showGrid() {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if ((i + j) % 2 == 1) {
        fill(0);
      } else {
        fill(240);
      }
      noStroke();
      rect(i * tileSize, j * tileSize, tileSize, tileSize);
    }
  }
}



void mousePressed() {
  int x = floor(mouseX / tileSize);
  int y = floor(mouseY / tileSize);
  if (!board.isDone()) {
    if (!moving) {
      movingPiece = board.getPieceAt(x, y);
      if (movingPiece != null && movingPiece.white == whitesMove) {

        movingPiece.movingThisPiece = true;
      } else {
        return;
      }
    } else {
      if (movingPiece.canMove(x, y)) {
        movingPiece.move(x, y, board);
        movingPiece.movingThisPiece = false;
        whitesMove = !whitesMove;
      } else {
        movingPiece.movingThisPiece = false;
      }
    }
    moving = !moving;
  }
}
