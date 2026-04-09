class RoundManager {
  int currentRound = 1;
  final int maxRounds;

  RoundManager(int playerCount) : maxRounds = playerCount == 3 ? 3 : 4;

  bool nextRound() {
    currentRound++;
    return currentRound <= maxRounds;
  }
}
