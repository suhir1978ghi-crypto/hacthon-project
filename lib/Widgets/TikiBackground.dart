import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TikiBackground extends Component with HasGameRef {
  SpriteComponent? background;
  SpriteComponent? bgFull;
  late Sprite backgroundSprite;

  @override
  Future<void> onLoad() async {
    backgroundSprite = await gameRef.loadSprite('board.png');

    bgFull = SpriteComponent(
      sprite: backgroundSprite,
      position: Vector2.zero(),
    );

    bgFull!.paint = Paint()
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
    bgFull?.size = gameRef.size;
    bgFull?.position = Vector2.zero();
  }

  void _resizeBackground() {
    final image = backgroundSprite.image;

    final screen = gameRef.size;
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
      (screen.x - width) / 2,
      (screen.y - height) / 2,
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _resizeAll();
  }
}
