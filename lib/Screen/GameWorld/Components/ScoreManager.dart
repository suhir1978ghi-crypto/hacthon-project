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

    for (int i = 0; i < stack.length; i++) {
      final index = stack[i].index;

      if (index == t[0] && i == 0) score += 9;
      if (index == t[1] && i <= 1) score += 4;
      if (index == t[2] && i <= 2) score += 2;
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
