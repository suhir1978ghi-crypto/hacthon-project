import 'dart:io';

import 'package:flutter/material.dart';

import '../../Components/AudioManager.dart';
import '../../Widgets/GlassButton.dart';
import '../HomeScreen/Widgets/MuteButton.dart';
import '../TikiGameScreen.dart';

class PauseScreen extends StatefulWidget {
  final TikiGameScreen game;

  const PauseScreen({super.key, required this.game});

  @override
  State<PauseScreen> createState() => _PauseScreenState();
}

class _PauseScreenState extends State<PauseScreen> {
  final audio = AudioManager();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black.withValues(alpha: 0.6)),

        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "PAUSED",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(height: 40),

              GlassButton(
                text: "RESUME",
                onTap: () {
                  widget.game.resumeGame();
                },
              ),

              const SizedBox(height: 20),

              GlassButton(
                text: "HOME",
                onTap: () {
                  widget.game.goToHome();
                },
              ),

              const SizedBox(height: 20),

              GlassButton(text: "EXIT", onTap: () => exit(0)),
            ],
          ),
        ),

        Positioned(
          top: 40,
          right: 20,
          child: MuteButton(
            isMuted: audio.isMuted,
            onTap: () {
              setState(() {
                audio.toggleMute();
              });
            },
          ),
        ),
      ],
    );
  }
}
