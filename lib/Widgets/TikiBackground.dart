import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class TikiBackground extends PositionComponent {
  SpriteComponent? background;
  SpriteComponent? bgFull;
  Sprite? backgroundSprite;

  FlameGame get game => findGame() as FlameGame;

  @override
  Future<void> onLoad() async {
    size = game.size;

    backgroundSprite = await game.loadSprite('board.png');

    bgFull = SpriteComponent(sprite: backgroundSprite);

    bgFull!.paint = Paint()
      ..filterQuality = FilterQuality.none
      ..imageFilter = ImageFilter.blur(sigmaX: 20, sigmaY: 20)
      ..colorFilter = ColorFilter.mode(
        Colors.black.withAlpha((255.0 * 0.4).round()),
        BlendMode.darken,
      );

    add(bgFull!);

    background = SpriteComponent(sprite: backgroundSprite);
    add(background!);

    _resizeAll();
  }

  void _resizeAll() {
    _resizeBgFull();
    _resizeBackground();
  }

  void _resizeBgFull() {
    bgFull?.size = game.size;
    bgFull?.position = Vector2.zero();
  }

  void _resizeBackground() {
    final image = backgroundSprite?.image;
    if (image == null) return;

    const reservedHeight = 120.0; // 🔥 space for cards

    final screen = Vector2(game.size.x, game.size.y - reservedHeight);

    final screenRatio = screen.x / screen.y;
    final imageRatio = image.width / image.height;

    double width, height;

    if (screenRatio > imageRatio) {
      height = screen.y;
      width = height * imageRatio;
    } else {
      width = screen.x;
      height = width / imageRatio;
    }

    background?.size = Vector2(width, height);

    background?.position = Vector2(
      (game.size.x - width) / 2,
      (screen.y - height) / 2, // 🔥 center inside usable area
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _resizeAll();
  }
}
