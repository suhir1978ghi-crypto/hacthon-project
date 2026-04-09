import '../Widgets/ActionButton.dart';

class ActionManager {
  final int playerCount;
  late List<Set<ActionType>> usedActions;

  ActionManager(this.playerCount) {
    reset();
  }

  void reset() {
    usedActions = List.generate(playerCount, (_) => <ActionType>{});
  }

  bool canPlay(int player) {
    return usedActions[player].length < ActionType.values.length;
  }

  bool isAvailable(int player, ActionType action) {
    return !usedActions[player].contains(action);
  }

  void markUsed(int player, ActionType action) {
    usedActions[player].add(action);
  }

  bool allPlayersFinished() {
    for (final a in usedActions) {
      if (a.length < ActionType.values.length) return false;
    }
    return true;
  }
}
