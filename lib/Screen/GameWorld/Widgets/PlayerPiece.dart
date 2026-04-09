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
    await super.onLoad();
    sprite = await Sprite.load(spritePaths[playerId]);
  }

  @override
  void render(Canvas canvas) {
    final glowPaint = Paint()
      ..color = glowColors[playerId].withValues(alpha: 0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x * 0.7, glowPaint);

    super.render(canvas);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap(this);

    final tooltip = PlayerTooltip(
      "Player ${playerId + 1}",
      position.clone() + Vector2(size.x / 2, 0),
    );

    parent?.add(tooltip);
  }
}

class PlayerTooltip extends TextComponent {
  double lifetime = 1.2;

  PlayerTooltip(String text, Vector2 position)
    : super(
        text: text,
        position: position,
        anchor: Anchor.center,
        priority: 100,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 8, color: Colors.black)],
          ),
        ),
      );

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= 20 * dt;
    lifetime -= dt;
    if (lifetime <= 0) {
      removeFromParent();
    }
  }
}
