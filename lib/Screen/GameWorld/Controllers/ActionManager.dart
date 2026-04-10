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

  bool isAvailable(int player, ActionType action) {
    return hands[player].contains(action);
  }

  bool canPlay(int player) {
    return hands[player].isNotEmpty;
  }

  bool useCard(int player, ActionType action) {
    final hand = hands[player];

    final index = hand.indexOf(action);
    if (index == -1) return false;

    hand.removeAt(index);

    return !hand.contains(action);
  }

  int count(int player, ActionType action) {
    return hands[player].where((a) => a == action).length;
  }

  bool allPlayersFinished() {
    return hands.every((hand) => hand.isEmpty);
  }
}
