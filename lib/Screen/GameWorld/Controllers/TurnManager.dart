class TurnManager {
  int currentPlayer = 0;
  final int playerCount;

  TurnManager(this.playerCount);

  void nextTurn() {
    currentPlayer = (currentPlayer + 1) % playerCount;
  }

  void reset() {
    currentPlayer = 0;
  }
}
