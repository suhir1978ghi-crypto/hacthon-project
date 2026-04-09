import 'dart:io';

import 'package:flutter/material.dart';

import '../../Components/AudioManager.dart';
import '../../Widgets/GlassButton.dart';
import '../TikiGameScreen.dart';
import 'Widgets/AnimatedTitle.dart';
import 'Widgets/MuteButton.dart';

class HomeScreen extends StatefulWidget {
  final TikiGameScreen game;

  const HomeScreen({super.key, required this.game});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final audio = AudioManager();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xCC000000), Color(0x33000000)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),

        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AnimatedTitle(),

              const SizedBox(height: 60),

              GlassButton(
                text: "PLAY",
                onTap: () async {
                  if (!widget.game.started) {
                    await widget.game.startGame();
                  }
                  await Future.delayed(const Duration(milliseconds: 150));
                  widget.game.overlays.remove('home');
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
