import 'package:flutter/material.dart';

import '../GameWorld.dart';

class RoundResultOverlay extends StatelessWidget {
  final GameWorld gameWorld;

  const RoundResultOverlay({super.key, required this.gameWorld});

  static final assets = [
    'images/tikis/NUI.png',
    'images/tikis/WIKIWIKI.png',
    'images/tikis/NANI.png',
    'images/tikis/KAPU.png',
    'images/tikis/HUhHU.png',
    'images/tikis/EEPO.png',
    'images/tikis/AKAMAI.png',
    'images/tikis/HOOKIPA.png',
    'images/tikis/lOKAHI.png',
  ];

  @override
  Widget build(BuildContext context) {
    final scores = gameWorld.scoreManager.scores;
    final stack = gameWorld.stackManager.tikiStack;

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black54)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "ROUND OVER",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              ...List.generate(scores.length, (player) {
                final targets = gameWorld.scoreManager.getPlayerTargets(player);

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // 🔥 HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Player ${player + 1}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${scores[player]} pts",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // 🎯 TARGETS
                      _rowLabel("Targets"),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          return _tikiCard(
                            'assets/${assets[targets[i]]}',
                            [9, 5, 2][i],
                            isTarget: true,
                          );
                        }),
                      ),

                      const SizedBox(height: 10),

                      // 🏆 RESULT
                      _rowLabel("Result"),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          if (i >= stack.length) {
                            return const SizedBox(width: 60);
                          }

                          final tiki = stack[i];

                          final isCorrect =
                              (i == 0 && tiki.id == targets[0]) ||
                              (i == 1 && tiki.id == targets[1]) ||
                              (i == 2 && tiki.id == targets[2]);

                          return _tikiCard(
                            'assets/images/${tiki.asset}',
                            null,
                            highlight: isCorrect,
                          );
                        }),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              // 🔥 BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  gameWorld.continueAfterRound();
                },
                child: const Text(
                  "Next Round",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
        letterSpacing: 1,
      ),
    );
  }

  Widget _tikiCard(
    String asset,
    int? score, {
    bool highlight = false,
    bool isTarget = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: highlight
                    ? Colors.greenAccent
                    : isTarget
                    ? Colors.white24
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: highlight
                  ? [const BoxShadow(color: Colors.greenAccent, blurRadius: 10)]
                  : [],
            ),
            child: Image.asset(asset, width: 48),
          ),

          if (score != null) ...[
            const SizedBox(height: 4),
            Text(
              "$score",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
