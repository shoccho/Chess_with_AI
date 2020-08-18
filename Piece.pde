class Piece {
  PVector matrixPosition ;
  PVector pixelPosition ;
  Boolean taken;
  Boolean white ;
  char letter ;
  PImage pic;
  Boolean movingThisPiece ;
  int value;
  boolean firstTurn;
  Piece(float x, float y, boolean isWhite ) { //, char nletter, PImage npic){
    matrixPosition = new PVector(x, y);
    pixelPosition = new PVector(x*tileSize +tileSize/2, y*tileSize +tileSize/2);
    taken = false;
    white = isWhite;
    //letter = nletter;
    //pic= npic;
    movingThisPiece = false;
    value = 0;
  }
  void show() {
    imageMode(CENTER);
    if(taken)return;
    if (movingThisPiece) {
      image(pic, mouseX, mouseY, tileSize*1.3, tileSize*1.3);
    } else {
      image(pic, pixelPosition.x, pixelPosition.y, tileSize, tileSize);
    }
  }
  ArrayList<Board> generateNewBoards(Board currentBoard) {
    ArrayList<Board>boards = new ArrayList<Board>();
    ArrayList<PVector> moves  = generateMoves(currentBoard);
    for ( int i=0; i<moves.size(); i++) {
      boards.add(currentBoard.clone());
      boards.get(i).move(matrixPosition, moves.get(i));
    }
    return boards;
  }
  Boolean withinBounds(float x, float y) {
    if (x>=0 && y>=0 && x<8 && y<8) {
      return true;
    } else return false;
  }

  void move(int x, int y, Board board) {
    Piece attacking = board.getPieceAt(x, y);
    if (attacking != null) {
      attacking.taken = true;
    }
    matrixPosition = new PVector(x, y);
    pixelPosition = new PVector(x * tileSize + tileSize / 2, y *
      tileSize + tileSize / 2);
  }

  boolean attackingAllies(float x, float y, Board board) {
    Piece attacking = board.getPieceAt(x, y);
    if (attacking != null) {
      if (attacking.white == white) {
        //if they are of the same player
        return true;
      }
    }
    return false;
  }
  boolean canMove(float x, float y, Board b) {
    if (!withinBounds(x, y)) {
      return false;
    }
    return true;
  }

  boolean moveThroughPieces(float x, float  y, Board board) {
    float stepDirectionX = x - matrixPosition.x;
    if (stepDirectionX > 0) {
      stepDirectionX = 1;
    } else if (stepDirectionX < 0) {
      stepDirectionX = -1;
    }
    float stepDirectionY = y - matrixPosition.y;
    if (stepDirectionY > 0) {
      stepDirectionY = 1;
    } else if (stepDirectionY < 0) {
      stepDirectionY = -1;
    }
    PVector tempPos = new PVector(matrixPosition.x, matrixPosition.y);
    tempPos.x += stepDirectionX;
    tempPos.y += stepDirectionY;
    while (tempPos.x != x || tempPos.y != y) {

      if (board.getPieceAt(tempPos.x, tempPos.y) != null) {
        System.out.println("returning true");
        return true;
      }
      tempPos.x += stepDirectionX;
      tempPos.y += stepDirectionY;
    }
    System.out.println("returning true");
    return false;
  }
  ArrayList<PVector> generateMoves(Board board) { 
    return null ;
  }
  Piece clone(){
  return null;
  }
}

class King extends Piece {
  King(float nx, float ny, boolean nisWhite) {
    super(nx, ny, nisWhite);
    letter = 'K';
    if (nisWhite) {
      pic = images.get(0);
    } else {
      pic = images.get(6);
    }
    value = 99;
  }
  @ Override   Piece clone() {
    Piece clone = new King(matrixPosition.x, matrixPosition.y, white);
    clone.taken = taken;
    return clone;
  }
@ Override boolean canMove(float x, float y, Board board) {
    if (!withinBounds(x, y)) {
      return false;
    }
    if (attackingAllies(x, y, board)) {
      return false;
    }
    if (abs(x - matrixPosition.x) <= 1 && abs(y - matrixPosition.y) <=
      1) {
      return true;
    }
    return false;
  }
  @ Override ArrayList<PVector>  generateMoves(Board board) {

    ArrayList<PVector> moves   = new ArrayList<PVector>();
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        float x = matrixPosition.x + i;
        float y = matrixPosition.y + j;
        if (withinBounds(x, y)) {
          if (i != 0 || j != 0) {
            if (!attackingAllies(x, y, board)) {
              moves.add(new PVector(x, y));
            }
          }
        }
      }
    }
    return moves;
  }
}

class Queen extends Piece {
  Queen(float nx, float ny, boolean nisWhite) {
    super(nx, ny, nisWhite);
    letter = 'Q';
    if (nisWhite) {
      pic = images.get(1);
    } else {
      pic = images.get(7);
    }
    value = 9;
  }
  boolean canMove(float x, float y, Board board) {
    if (!withinBounds(x, y)) {
      return false;
    }
    if (attackingAllies(x, y, board)) {
      return false;
    }
    if (x == matrixPosition.x || y == matrixPosition.y) {
      if (moveThroughPieces(x, y, board)) {
        return false;
      }

      return true;
    }
    //diagonal
    if (abs(x - matrixPosition.x) == abs(y - matrixPosition.y)) {
      if (moveThroughPieces(x, y, board)) {
        return false;
      }

      return true;
    }
    return false;
  }
  @ Override  ArrayList<PVector>  generateMoves(Board board) {
    ArrayList<PVector> moves   = new ArrayList<PVector>();
    //generateHorizontal moves
    for (int i = 0; i < 8; i++) {
      float x = i;
      float y = matrixPosition.y;
      if (x != matrixPosition.x) {
        if (!attackingAllies(x, y, board)) {
          if (!moveThroughPieces(x, y, board)) {
            moves.add(new PVector(x, y));
          }
        }
      }
    }
    //generatevertical moves
    for (int i = 0; i < 8; i++) {
      float x = matrixPosition.x;
      float y = i;
      if (y != matrixPosition.y) {
        if (!attackingAllies(x, y, board)) {
          if (!moveThroughPieces(x, y, board)) {
            moves.add(new PVector(x, y));
          }
        }
      }
    }
    //diagonal
    for (int i = 0; i < 8; i++) {
      float x = i;
      float y = matrixPosition.y - (matrixPosition.x - i);
      if (x != matrixPosition.x) {
        if (withinBounds(x, y)) {
          if (!attackingAllies(x, y, board)) {
            if (!moveThroughPieces(x, y, board)) {
              moves.add(new PVector(x, y));
            }
          }
        }
      }
    }
    for (int i = 0; i < 8; i++) {
      float x = matrixPosition.x + (matrixPosition.y - i);
      float y = i;
      if (x != matrixPosition.x) {
        if (withinBounds(x, y)) {
          if (!attackingAllies(x, y, board)) {
            if (!moveThroughPieces(x, y, board)) {
              moves.add(new PVector(x, y));
            }
          }
        }
      }
    }
    return moves;
  }
  @ Override   Piece clone() {
    Piece clone = new Queen(matrixPosition.x, matrixPosition.y, white);
    clone.taken = taken;
    return clone;
  }
}


class Bishop extends Piece {
  Bishop(float nx, float ny, boolean nisWhite) {
    super(nx, ny, nisWhite);
    letter = 'B';
    if (nisWhite) {
      pic = images.get(2);
    } else {
      pic = images.get(8);
    }
    value = 3;
  }
  boolean canMove(float x, float y, Board board) {
    if (!withinBounds(x, y)) {
      return false;
    }
    if (attackingAllies(x, y, board)) {
      return false;
    }
    //diagonal
    if (abs(x - matrixPosition.x) == abs(y - matrixPosition.y)) {
      if (moveThroughPieces(x, y, board)) {
        return false;
      }

      return true;
    }
    return false;
  }
  @ Override   ArrayList<PVector>  generateMoves(Board board) {
    ArrayList<PVector> moves   = new ArrayList<PVector>();

    //diagonal
    for (int i = 0; i < 8; i++) {
      float x = i;
      float y = matrixPosition.y - (matrixPosition.x - i);
      if (x != matrixPosition.x) {
        if (withinBounds(x, y)) {
          if (!attackingAllies(x, y, board)) {
            if (!moveThroughPieces(x, y, board)) {
              moves.add(new PVector(x, y));
            }
          }
        }
      }
    }
    for (int i = 0; i < 8; i++) {
      float x = matrixPosition.x + (matrixPosition.y - i);
      float y = i;
      if (x != matrixPosition.x) {
        if (withinBounds(x, y)) {
          if (!attackingAllies(x, y, board)) {
            if (!moveThroughPieces(x, y, board)) {
              moves.add(new PVector(x, y));
            }
          }
        }
      }
    }
    return moves;
  }
  @ Override  Piece clone() {
    Piece clone = new Bishop(matrixPosition.x, matrixPosition.y, white);
    clone.taken = taken;
    return clone;
  }
}
class Rook extends Piece {
  Rook(float nx, float ny, boolean nisWhite) {
    super(nx, ny, nisWhite);
    letter = 'R';
    if (nisWhite) {
      pic = images.get(4);
    } else {
      pic = images.get(10);
    }
    value = 5;
  }
  boolean canMove(float x, float y, Board board) {
    if (!withinBounds(x, y)) {
      return false;
    }
    if (attackingAllies(x, y, board)) {
      return false;
    }
    if (x == matrixPosition.x || y == matrixPosition.y) {
      if (moveThroughPieces(x, y, board)) {
        return false;
      }

      return true;
    }

    return false;
  }
  @ Override   ArrayList<PVector>  generateMoves(Board board) {
    ArrayList<PVector> moves   = new ArrayList<PVector>();
    //generateHorizontal moves
    for (int i = 0; i < 8; i++) {
      float x = i;
      float y = matrixPosition.y;
      if (x != matrixPosition.x) {
        if (!attackingAllies(x, y, board)) {
          if (!moveThroughPieces(x, y, board)) {
            moves.add(new PVector(x, y));
          }
        }
      }
    }
    //generatevertical moves
    for (int i = 0; i < 8; i++) {
      float x = matrixPosition.x;
      float y = i;
      if (y != matrixPosition.y) {
        if (!attackingAllies(x, y, board)) {
          if (!moveThroughPieces(x, y, board)) {
            moves.add(new PVector(x, y));
          }
        }
      }
    }

    return moves;
  }
  @ Override   Piece clone() {
    Piece clone = new Rook(matrixPosition.x, matrixPosition.y, white);
    clone.taken = taken;
    return clone;
  }
}


class Knight extends Piece {
  Knight(float nx, float ny, boolean nisWhite) {
    super(nx, ny, nisWhite);
    letter = 'n';
    if (nisWhite) {
      pic = images.get(3);
    } else {
      pic = images.get(9);
    }
    value = 3;
  }
  boolean canMove(float x, float y, Board board) {
    if (!withinBounds(x, y)) {
      return false;
    }
    if (attackingAllies(x, y, board)) {
      return false;
    }
    if ((abs(x - matrixPosition.x) == 2 && abs(y - matrixPosition
      .y) == 1) || (abs(x - matrixPosition.x) == 1 && abs(y - matrixPosition
      .y) == 2)) {
      return true;
    }

    return false;
  }

  @ Override   ArrayList<PVector>  generateMoves(Board board) {
    ArrayList<PVector> moves   = new ArrayList<PVector>();
    for (int i = -2; i < 3; i += 4) {
      for (int j = -1; j < 2; j += 2) {

        float x = i + this.matrixPosition.x;
        float y = j + this.matrixPosition.y;
        if (!attackingAllies(x, y, board)) {
          if (withinBounds(x, y)) {
            moves.add(new PVector(x, y));
          }
        }
      }
    }
    for (int i = -1; i < 2; i += 2) {
      for (int j = -2; j < 3; j += 4) {

        float x = i + this.matrixPosition.x;
        float y = j + this.matrixPosition.y;

        if (withinBounds(x, y)) {
          if (!attackingAllies(x, y, board)) {
            moves.add(new PVector(x, y));
          }
        }
      }
    }
    return moves;
  }
  @ Override  Piece clone() {
    Piece clone = new Knight(matrixPosition.x, matrixPosition.y, white);
    clone.taken = taken;
    return clone;
  }
}

//pawn
class Pawn extends Piece {

  Pawn(float nx, float ny, boolean nisWhite) {
    super(nx, ny, nisWhite);
    letter = 'p';
    if (nisWhite) {
      pic = images.get(5);
    } else {
      pic = images.get(11);
    }
    value = 1;
    firstTurn =true;
  }
  @ Override  Piece clone() {
    Piece clone = new Pawn(matrixPosition.x, matrixPosition.y, white);
    clone.taken = taken;
    clone.firstTurn = this.firstTurn;
    return clone;
  }

  boolean canMove(float x, float y, Board board) {
    if (!withinBounds(x, y)) {
      return false;
    }
    if (attackingAllies(x, y, board)) {
      return false;
    }
    Boolean attacking = board.isPieceAt(x, y);
    if (attacking) {
      //if attacking a player
      if (abs(x - matrixPosition.x) == abs(y - matrixPosition.y) &&
        ((white && (y - matrixPosition.y) == -1) || (!white &&
        (y - matrixPosition.y) == 1))) {
        firstTurn = false;
        return true;
      }
      return false;
    }
    if (x != matrixPosition.x) {
      return false;
    }
    if ((white && y - matrixPosition.y == -1) || (!white &&
      y - matrixPosition.y == 1)) {
      firstTurn = false;
      return true;
    }
    if (firstTurn && ((white && y - matrixPosition.y == -2) ||
      (!white && y - matrixPosition.y == 2))) {
      if (moveThroughPieces(x, y, board)) {
        return false;
      }

      firstTurn = false;
      return true;
    }


    return false;
  }

  @ Override  ArrayList<PVector>  generateMoves(Board board) {
    ArrayList<PVector> moves   = new ArrayList<PVector>();
    for (int i = -1; i < 2; i += 2) {
      float x = matrixPosition.x + i;
      float y;
      if (white) {
        y = matrixPosition.y - 1;
      } else {
        y = matrixPosition.y + 1;
      }
      Piece attacking = board.getPieceAt(x, y);
      if (attacking !=null) {
        if (!attackingAllies(x, y, board)) {
          moves.add(new PVector(x, y));
        }
      }
    }

    float x = matrixPosition.x;
    float y;
    if (white) {
      y =matrixPosition.y - 1;
    } else {
      y = matrixPosition.y + 1;
    }
    if (!board.isPieceAt(x, y) && withinBounds(x, y)) {
      moves.add(new PVector(x, y));
    }

    if (this.firstTurn) {

      if (this.white) {
        y = this.matrixPosition.y - 2;
      } else {
        y = this.matrixPosition.y + 2;
      }
      if (!board.isPieceAt(x, y) && withinBounds(x, y)) {
        if (!moveThroughPieces(x, y, board)) {
          moves.add(new PVector(x, y));
        }
      }
    }
    return moves;
  }
  void move(float x, float y, Board board) {
    Piece attacking = board.getPieceAt(x, y);
    if (attacking != null) {
      attacking.taken = true;
    }
    matrixPosition = new PVector(x, y);
    pixelPosition = new PVector(x * tileSize + tileSize / 2, y *
      tileSize + tileSize / 2);
    firstTurn = false;
  }
}
