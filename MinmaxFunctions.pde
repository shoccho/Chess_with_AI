int maxDepth =3;

float minFun(Board board , int depth){
  if(depth>=maxDepth){
    board.setScore();
    return board.score;
  }
  ArrayList<Board> boards = board.generateNewBoardsWhitesTurn();
  Board lowestBoard ;
  float lowestScore =10000;
  for (Board b : boards){
    if(b.isDead()){
      float score = maxFun(b, depth+1);
      if(score<lowestScore){
        lowestBoard =b;
        lowestScore = score;
      }
      
    }
  }
  return lowestScore;
}

float maxFun(Board board , int depth){
  if(depth>=maxDepth){
    board.setScore();
    return board.score;
  }
  ArrayList<Board> boards = board.generateNewBoardsBlacksTurn();
  Board topBoard ;
  float topScore =-10000;
  for (Board b : boards){
    if(b.isDead()){
      float score = minFun(b, depth+1);
      if(score>topScore){
        topBoard = b;
        topScore = score;
      }
      
    }
  }
  if(depth ==0){
  return 0;
  }
  return topScore;
}

float  maxFunAB(Board board, float alpha,float  beta, float depth) {
  if (depth >= maxDepth) {
    board.setScore();
    return board.score;
  }

  if (board.isDead()) {
    if (whiteAI && whitesMove) {
      return 200;
    }
    if (blackAI && !whitesMove) {
      return -200;
    }
  }

  if (board.hasWon()) {
    if (whiteAI && whitesMove) {
      return -200;
    }
    if (blackAI && !whitesMove) {
      return 200;
    }
  }

  ArrayList<Board> boards = board.generateNewBoardsBlacksTurn();
  if (depth == 0) {
    //////print(boards);
  }
  int topBoardNo = 0;
  float topScore = -300;
  for (int i = 0; i < boards.size(); i++) {

    float score = minFunAB(boards.get(i), alpha, beta, depth + 1);
    if (score > topScore) {
      topBoardNo = i;
      topScore = score;
    } else {
      if (depth == 0 && score == topScore) {
        if (random(1) < 0.3) {
          topBoardNo = i;
        }
      }
    }
    if (score > beta) {
      return topScore;
    }
    if (score > alpha) {
      alpha = score;
    }

  }

  if (depth == 0) {
    ////print(topScore);
    //return boards.get(topBoardNo);
  }
  return topScore;
}

float minFunAB(Board board,float alpha,float beta,float depth) {
  if (depth >= maxDepth) {
    board.setScore();
    return board.score;
  }


  if (board.isDead()) {
    if (whiteAI && whitesMove) {
      return 200;
    }
    if (blackAI && !whitesMove) {
      return -200;
    }
  }

  if (board.hasWon()) {

    if (whiteAI && whitesMove) {
      return -200;
    }
    if (blackAI && !whitesMove) {
      return 200;
    }
  }

 ArrayList< Board> boards = board.generateNewBoardsWhitesTurn();
  int lowestBoardNo = 0;
  float lowestScore = 300;
  for (int i = 0; i < boards.size(); i++) {

    float score = maxFunAB(boards.get(i), alpha, beta, depth + 1);
    if (depth == 0) {
      //print(score, i, boards[i]);
    }
    if (score < lowestScore) {
      lowestBoardNo = i;
      lowestScore = score;
    } else {
      if (depth == 0 && score == lowestScore) {
        //print("same as so i do what i want", i);
        if (random(1) < 0.3) {
          lowestBoardNo = i;
        }
      }
    }
    if (score < alpha) {
      return lowestScore;
    }
    if (score < beta) {
      beta = score;
    }

  }

  if (depth == 0) {
    ////print(lowestScore);
    ////print("eituku kaj kore");
    //return boards[lowestBoardNo];
  }
  
  ////print(lowestScore);
  return lowestScore;
}


Board mainminFunAB(Board board,float alpha,float beta,int depth) {
  if (depth >= maxDepth) {
    board.setScore();
   return null;
  }


  if (board.isDead()) {
    if (whiteAI && whitesMove) {
      return null;
    }
    if (blackAI && !whitesMove) {
      return null;
    }
  }

  if (board.hasWon()) {

    if (whiteAI && whitesMove) {
      return null;
    }
    if (blackAI && !whitesMove) {
      return null;
    }
  }

 ArrayList< Board> boards = board.generateNewBoardsWhitesTurn();
  int lowestBoardNo = 0;
  float lowestScore = 300;
  for (int i = 0; i < boards.size(); i++) {

    float score = maxFunAB(boards.get(i), alpha, beta, depth + 1);
    if (depth == 0) {
      //print(score, i, boards[i]);
    }
    if (score < lowestScore) {
      lowestBoardNo = i;
      lowestScore = score;
    } else {
      if (depth == 0 && score == lowestScore) {
        
        if (random(1) < 0.3) {
          lowestBoardNo = i;
        }
      }
    }
    if (score < alpha) {
      //return lowestScore;
    }
    if (score < beta) {
      beta = score;
    }

  }

  //if (depth == 0) {
    ////print(lowestScore);
    ////print("eituku kaj kore");
    return boards.get(lowestBoardNo);
  
  ////print("ohNo");
  ////print(lowestScore);
  //return lowestScore;
}

Board  mainmaxFunAB(Board board, float alpha,float  beta, float depth) {
  if (depth >= maxDepth) {
    board.setScore();
    return null;
  }

  if (board.isDead()) {
    if (whiteAI && whitesMove) {
      return null;
    }
    if (blackAI && !whitesMove) {
      return null;
    }
  }

  if (board.hasWon()) {
    if (whiteAI && whitesMove) {
      //return -200;
      return null;
    }
    if (blackAI && !whitesMove) {
      
      return null;
    }
  }

  ArrayList<Board> boards = board.generateNewBoardsBlacksTurn();
  if (depth == 0) {
    //////print(boards);
  }
  int topBoardNo = 0;
  float topScore = -300;
  for (int i = 0; i < boards.size(); i++) {

    float score = minFunAB(boards.get(i), alpha, beta, depth + 1);
    if (score > topScore) {
      topBoardNo = i;
      topScore = score;
    } else {
      if (depth == 0 && score == topScore) {
        if (random(1) < 0.3) {
          topBoardNo = i;
        }
      }
    }
    if (score > beta) {
      //return topScore;
    }
    if (score > alpha) {
      alpha = score;
    }

  }

  //if (depth == 0) {
    ////print(topScore);
    return boards.get(topBoardNo);
  //}
  //return topScore;
}
