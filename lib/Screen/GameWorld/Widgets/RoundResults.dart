import 'package:flutter/material.dart';

import '../GameWorld.dart';

class RoundResultOverlay extends StatelessWidget {
  final GameWorld gameWorld;

  const RoundResultOverlay({super.key, required this.gameWorld});

  @override
  Widget build(BuildContext context) {
    final scores = gameWorld.scoreManager.scores;

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Round Over",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 🔥 Scores
            ...List.generate(scores.length, (i) {
              return Text(
                "Player ${i + 1}: ${scores[i]}",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              );
            }),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                gameWorld.continueAfterRound();
              },
              child: const Text("Next Round"),
            ),
          ],
        ),
      ),
    );
  }
}
