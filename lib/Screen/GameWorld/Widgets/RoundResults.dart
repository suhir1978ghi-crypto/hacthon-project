import 'package:flutter/material.dart';

import '../GameWorld.dart';

class RoundResultOverlay extends StatelessWidget {
  final GameWorld gameWorld;

  const RoundResultOverlay({super.key, required this.gameWorld});

  @override
  Widget build(BuildContext context) {
    final scores = gameWorld.scoreManager.scores;

    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: AnimatedScale(
          scale: 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          child: AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Round Over",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ...List.generate(scores.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "Player ${i + 1}: ${scores[i]}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      gameWorld.continueAfterRound();
                    },
                    child: const Text("Next Round"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
