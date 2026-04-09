import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../main.dart';

class HomeScreen extends StatelessWidget {
  final TikiGame game;

  const HomeScreen({super.key, required this.game});

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
              _animatedTitle(),

              const SizedBox(height: 60),

              _glassButton(text: "PLAY", onTap: () => game.startPlayerSetup()),

              const SizedBox(height: 20),

              _glassButton(text: "EXIT", onTap: () => exit(0)),
            ],
          ),
        ),
      ],
    );
  }

  // ================= TITLE =================

  Widget _animatedTitle() {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "Tiki Topple",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
                ..color = Colors.orangeAccent,
            ),
          ),

          const Text(
            "Tiki Topple",
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
