import '../Widgets/ActionButton.dart';

class ActionManager {
  final int playerCount;

  late List<List<ActionType>> hands;

  ActionManager(this.playerCount) {
    reset();
  }

  void reset() {
    hands = List.generate(playerCount, (_) => _generateHand());
  }

  List<ActionType> _generateHand() {
    return [
      ActionType.up1,
      ActionType.up1,
      ActionType.up2,
      ActionType.up3,
      ActionType.topple,
      ActionType.toast,
      ActionType.toast,
    ];
  }

  bool canPlay(int player) {
    return hands[player].isNotEmpty;
  }

  bool isAvailable(int player, ActionType action) {
    return hands[player].contains(action);
  }

  void markUsed(int player, ActionType action) {
    hands[player].remove(action);
  }

  bool allPlayersFinished() {
    for (final hand in hands) {
      if (hand.isNotEmpty) return false;
    }
    return true;
  }
}
