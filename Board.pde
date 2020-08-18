class Board {
  ArrayList<Piece> whitePieces;
  ArrayList<Piece> blackPieces;
  float score;
  Board() {
    whitePieces = new ArrayList<Piece>();
    blackPieces = new ArrayList<Piece>();
    score =0;
    setupPieces();
  }

  void setupPieces() {
    whitePieces.add(new King(4, 7, true));
    whitePieces.add(new Queen(3, 7, true));
    whitePieces.add(new Bishop(2, 7, true));
    whitePieces.add(new Bishop(5, 7, true));
    whitePieces.add(new Knight(1, 7, true));
    whitePieces.add(new Knight(6, 7, true));
    whitePieces.add(new Rook(0, 7, true));
    whitePieces.add(new Rook(7, 7, true));

    whitePieces.add(new Pawn(0, 6, true));
    whitePieces.add(new Pawn(1, 6, true));
    whitePieces.add(new Pawn(2, 6, true));
    whitePieces.add(new Pawn(3, 6, true));
    whitePieces.add(new Pawn(4, 6, true));
    whitePieces.add(new Pawn(5, 6, true));
    whitePieces.add(new Pawn(6, 6, true));
    whitePieces.add(new Pawn(7, 6, true));

    blackPieces.add(new King(4, 0, false));
    blackPieces.add(new Queen(3, 0, false));
    blackPieces.add(new Bishop(2, 0, false));
    blackPieces.add(new Bishop(5, 0, false));
    blackPieces.add(new Knight(1, 0, false));
    blackPieces.add(new Knight(6, 0, false));
    blackPieces.add(new Rook(0, 0, false));
    blackPieces.add(new Rook(7, 0, false));

    blackPieces.add(new Pawn(0, 1, false));
    blackPieces.add(new Pawn(1, 1, false));
    blackPieces.add(new Pawn(2, 1, false));
    blackPieces.add(new Pawn(3, 1, false));
    blackPieces.add(new Pawn(4, 1, false));
    blackPieces.add(new Pawn(5, 1, false));
    blackPieces.add(new Pawn(6, 1, false));
    blackPieces.add(new Pawn(7, 1, false));
  }
  void  show() {
    for (Piece piece : whitePieces) {
      piece.show();
    }
    for (Piece piece : blackPieces) {
      piece.show();
    }
  }

  boolean isPieceAt(float x, float y) {
    //int x = int(xx);
    //int y = int(yy);
    for (int i = 0; i < whitePieces.size(); i++) {
      if (!whitePieces.get(i).taken && whitePieces.get(i).matrixPosition.x ==
        x && whitePieces.get(i).matrixPosition.y == y) {
        return true;
      }
    }
    for (int i = 0; i < blackPieces.size(); i++) {
      if (!blackPieces.get(i).taken && blackPieces.get(i).matrixPosition.x ==
        x && blackPieces.get(i).matrixPosition.y == y) {
        return true;
      }
    }

    return false;
  }

  Piece getPieceAt(float x, float y) {
    for (int i = 0; i < whitePieces.size(); i++) {
      if (!whitePieces.get(i).taken && whitePieces.get(i).matrixPosition.x ==
        x && whitePieces.get(i).matrixPosition.y == y) {
        return whitePieces.get(i);
      }
    }
    for (int i = 0; i < blackPieces.size(); i++) {
      if (!blackPieces.get(i).taken && blackPieces.get(i).matrixPosition.x ==
        x && blackPieces.get(i).matrixPosition.y == y) {
        return blackPieces.get(i);
      }
    }
    return null;
  }

  ArrayList<Board> generateNewBoardsWhitesTurn() {
    ArrayList<Board> boards = new ArrayList<Board>();
    for (int i = 0; i < whitePieces.size(); i++) {
      if (!whitePieces.get(i).taken) {
        ArrayList<Board> tempArr = this.whitePieces.get(i).generateNewBoards(this);
        for (int j = 0; j < tempArr.size(); j++) {
          boards.add(tempArr.get(j));
        }
      }
    }
    return boards;
  }
  ArrayList<Board> generateNewBoardsBlacksTurn() {
    ArrayList<Board> boards = new ArrayList<Board>();
    for (int i = 0; i < blackPieces.size(); i++) {
      if (!blackPieces.get(i).taken) {
        ArrayList<Board> tempArr = blackPieces.get(i).generateNewBoards(this);
        for (int j = 0; j < tempArr.size(); j++) {
          boards.add(tempArr.get(j));
        }
      }
    }
    return boards;
  }
  void setScore() {
    score =0;
    for (int i = 0; i < whitePieces.size(); i++) {
      if (!whitePieces.get(i).taken) {
        score -= whitePieces.get(i).value;
      } else {
        //print("something");
      }
    }
    for (int i = 0; i < blackPieces.size(); i++) {
      if (!blackPieces.get(i).taken) {
        score +=blackPieces.get(i).value;
      } else {
        //print("something");
      }
    }
  }

  void move(PVector from, PVector  to) {
    Piece pieceToMove = getPieceAt(from.x, from.y);
    if (pieceToMove == null) {
      //print("shit");
      return;
    }
    // if (pieceToMove.canMove(to.x, to.y, this)) {
    pieceToMove.move(int(to.x), int(to.y), this);
    // }
  }
  Board clone() {
    Board clone = new Board();
    for (int i=0; i<whitePieces.size(); i++) {
      clone.whitePieces.remove(i);
      clone.whitePieces.add(whitePieces.get(i).clone());
    }
    for (int i=0; i<blackPieces.size(); i++) {
      clone.blackPieces.remove(i);
      clone.blackPieces.add(blackPieces.get(i).clone());
    }

    return clone;
  }
  boolean isDone() {
    return whitePieces.get(0).taken || blackPieces.get(0).taken;
  }
  boolean isDead() {
    if (whiteAI && whitesMove) {
      return whitePieces.get(0).taken;
    }
    if (blackAI && !whitesMove) {
      return blackPieces.get(0).taken;
    }
    return false;
  }
  boolean hasWon() {
    if (whiteAI && whitesMove) {
      return blackPieces.get(0).taken;
    }
    if (blackAI && !whitesMove) {
      return whitePieces.get(0).taken;
    }
    return false;
  }
}
