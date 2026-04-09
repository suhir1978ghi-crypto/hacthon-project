import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class PlayerPiece extends SpriteComponent with TapCallbacks {
  final int playerId;
  int index;
  final Function(PlayerPiece) onTap;

  static const double baseSize = 64;

  PlayerPiece({
    required this.playerId,
    required this.index,
    required this.onTap,
  }) : super(size: Vector2.all(baseSize), anchor: Anchor.topLeft);

  static final glowColors = [
    const Color(0xFFFF7A2F),
    const Color(0xFF2E7D32),
    const Color(0xFF2C6E91),
    const Color(0xFFD94F70),
  ];

  static const spritePaths = [
    'pieces/fire.png',
    'pieces/tiki.png',
    'pieces/stone.png',
    'pieces/shell.png',
  ];

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(spritePaths[playerId]);
  }

  @override
  void render(Canvas canvas) {
    final t = DateTime.now().millisecondsSinceEpoch / 400;
    final pulse = 0.6 + 0.2 * sin(t);

    final glowPaint = Paint()
      ..color = glowColors[playerId].withOpacity(pulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x * 0.75, glowPaint);

    super.render(canvas);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap(this);
  }
}
