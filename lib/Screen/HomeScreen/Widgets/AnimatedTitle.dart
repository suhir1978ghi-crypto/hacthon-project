import 'package:flutter/material.dart';

class AnimatedTitle extends StatefulWidget {
  const AnimatedTitle({super.key});

  @override
  State<AnimatedTitle> createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<AnimatedTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnim;
  late Animation<double> glowAnim;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scaleAnim = Tween<double>(
      begin: 0.96,
      end: 1.04,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    glowAnim = Tween<double>(
      begin: 6,
      end: 16,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Transform.scale(
          scale: scaleAnim.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 🔥 Glow layer
              Text(
                "Tiki Topple",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..maskFilter = MaskFilter.blur(
                      BlurStyle.normal,
                      glowAnim.value,
                    )
                    ..color = Colors.orangeAccent,
                ),
              ),

              // ✨ Main text
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
      },
    );
  }
}
