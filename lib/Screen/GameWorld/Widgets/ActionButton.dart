import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ActionButton extends PositionComponent with TapCallbacks {
  final String text;
  final VoidCallback onPressed;
  bool isSelected = false;
  bool disabled = false;
  ActionButton(this.text, Vector2 pos, this.onPressed)
    : super(position: pos, size: Vector2(100, 50));

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = disabled
          ? Colors.grey
          : isSelected
          ? Colors.orange
          : Colors.black;

    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
      paint,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    );

    tp.layout();
    tp.paint(
      canvas,
      Offset(size.x / 2 - tp.width / 2, size.y / 2 - tp.height / 2),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (disabled) return;
    onPressed();
  }
}

enum ActionType { up1, up2, up3, topple, toast }
