import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Tiki extends PositionComponent with TapCallbacks, HasPaint {
  final int id;
  VoidCallback onTap;

  Tiki({required this.id, required this.onTap}) {
    anchor = Anchor.topLeft;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.primaries[id % Colors.primaries.length];

    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
      paint,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
