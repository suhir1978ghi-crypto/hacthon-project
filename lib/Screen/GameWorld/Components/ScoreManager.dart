import '../Widgets/Tiki.dart';

class ScoreManager {
  final int playerCount;

  final List<int> scores = [];
  final List<List<int>> targets = [];

  ScoreManager(this.playerCount) {
    scores.addAll(List.filled(playerCount, 0));
    resetTargets();
  }

  void resetTargets() {
    targets.clear();
    for (int i = 0; i < playerCount; i++) {
      targets.add(_generateTargets());
    }
  }

  // 🔥 pick 3 UNIQUE tikis (not symbols)
  List<int> _generateTargets() {
    final ids = List.generate(9, (i) => i)..shuffle();
    return ids.take(3).toList();
  }

  // 🔥 scoring based on exact tiki
  int calculateScore(int player, List<Tiki> stack) {
    final t = targets[player];
    int score = 0;

    if (stack.length > 0 && stack[0].id == t[0]) {
      score += 9;
    }

    if (stack.length > 1 && stack[1].id == t[1]) {
      score += 5;
    }

    if (stack.length > 2 && stack[2].id == t[2]) {
      score += 2;
    }

    return score;
  }

  void addScore(int player, int value) {
    scores[player] += value;
  }

  List<int> getPlayerTargets(int player) {
    return targets[player];
  }
}
