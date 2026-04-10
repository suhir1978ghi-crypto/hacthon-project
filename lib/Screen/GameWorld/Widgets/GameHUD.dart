import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameHUD extends PositionComponent {
  int currentPlayer = 0;
  List<int> scores = [];

  final TextComponent turnText = TextComponent();
  late final TextComponent scoreText = TextComponent();

  @override
  Future<void> onLoad() async {
    turnText.position = Vector2(20, 20);
    scoreText.position = Vector2(20, 50);

    turnText.textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
    scoreText.textRenderer = TextPaint(
      style: const TextStyle(fontSize: 16, color: Colors.white),
    );
    addAll([turnText, scoreText]);
  }

  void updateHUD({required int player, required List<int> scoreList}) {
    currentPlayer = player;
    scores = scoreList;

    turnText.text = "Turn: P${player + 1}";
    scoreText.text =
        "Scores: ${scores.asMap().entries.map((e) => "P${e.key + 1}: ${e.value}").join(", ")}";
  }
}
