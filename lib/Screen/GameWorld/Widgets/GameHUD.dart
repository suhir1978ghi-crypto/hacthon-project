import 'package:flame/components.dart';

class GameHUD extends PositionComponent {
  int currentPlayer = 0;
  List<int> scores = [];
  String action = "";

  final TextComponent turnText = TextComponent();
  final TextComponent scoreText = TextComponent();
  final TextComponent actionText = TextComponent();

  @override
  Future<void> onLoad() async {
    turnText.position = Vector2(20, 20);
    scoreText.position = Vector2(20, 50);
    actionText.position = Vector2(20, 80);

    addAll([turnText, scoreText, actionText]);
  }

  void updateHUD({
    required int player,
    required List<int> scoreList,
    required String selectedAction,
  }) {
    currentPlayer = player;
    scores = scoreList;
    action = selectedAction;

    turnText.text = "Turn: P${player + 1}";
    scoreText.text = "Scores: ${scores.join(" | ")}";
    actionText.text = "Action: $action";
  }
}
