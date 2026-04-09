import 'package:flutter/material.dart';

import '../../Widgets/GlassButton.dart';
import '../GameWorld/Components/PlayerCount.dart';
import '../TikiGameScreen.dart';
import 'Widget/PlayerTile.dart';

class PlayerSelectScreen extends StatefulWidget {
  final TikiGameScreen game;

  const PlayerSelectScreen({super.key, required this.game});

  @override
  State<PlayerSelectScreen> createState() => _PlayerSelectScreenState();
}

class _PlayerSelectScreenState extends State<PlayerSelectScreen> {
  int selectedPlayers = 2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black.withValues(alpha: 0.7)),

        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "SELECT PLAYERS",
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final count = index + 2;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: PlayerTile(
                      count: count,
                      isSelected: selectedPlayers == count,
                      onTap: () {
                        setState(() => selectedPlayers = count);
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              GlassButton(
                text: "START",
                onTap: () async {
                  if (!widget.game.started) {
                    await widget.game.startGame(
                      players: PlayerCount.values[selectedPlayers - 2],
                    );
                  }
                  widget.game.overlays.remove('playerSelect');
                },
              ),

              const SizedBox(height: 20),

              GlassButton(
                text: "BACK",
                onTap: () {
                  widget.game.overlays.remove('playerSelect');
                  widget.game.overlays.add('home');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
