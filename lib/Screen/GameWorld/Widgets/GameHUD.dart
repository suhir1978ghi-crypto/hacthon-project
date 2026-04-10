import 'package:flutter/material.dart';

import '../GameWorld.dart';

class GameHUDOverlay extends StatefulWidget {
  final GameWorld gameWorld;

  const GameHUDOverlay({super.key, required this.gameWorld});

  @override
  State<GameHUDOverlay> createState() => _GameHUDOverlayState();
}

class _GameHUDOverlayState extends State<GameHUDOverlay> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _loop());
  }

  void _loop() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final scores = widget.gameWorld.scoreManager.scores;
    final player = widget.gameWorld.turnManager.currentPlayer;

    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _glassCard(
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.orange),
                const SizedBox(width: 6),
                Text(
                  "P${player + 1}'s Turn",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          _glassCard(
            child: Row(
              children: List.generate(scores.length, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Text(
                        "P${i + 1}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          "${scores[i]}",
                          key: ValueKey(scores[i]),
                          style: TextStyle(
                            color: i == player ? Colors.orange : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: child,
    );
  }
}
