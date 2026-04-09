import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Components/PositionManager.dart';
import '../Widgets/TikiBackground.dart';
import 'GameWorld/GameWorld.dart';

class TikiGameScreen extends FlameGame with KeyboardEvents {
  PositionManager? positionManager;
  GameWorld? gameWorld;

  bool started = false;

  @override
  Future<void> onLoad() async {
    final bg = TikiBackground();
    await add(bg);
    await bg.loaded;

    positionManager = PositionManager(bg.background!);
  }

  Future<void> startGame() async {
    if (started || positionManager == null) return;

    started = true;

    gameWorld = GameWorld(positionManager!);
    await add(gameWorld!);

    await Future.delayed(Duration.zero);
  }

  Future<void> resetGame() async {
    if (gameWorld != null) {
      gameWorld!.removeFromParent();
      gameWorld = null;
    }

    started = false;
  }

  void pauseGame() {
    if (!started) return;

    overlays.add('pause');
    pauseEngine();
  }

  void resumeGame() {
    overlays.remove('pause');
    resumeEngine();
  }

  Future<void> goToHome() async {
    await resetGame();

    overlays.remove('pause');
    overlays.add('home');

    resumeEngine();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!started) return KeyEventResult.ignored;

    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      if (overlays.isActive('pause')) {
        resumeGame();
      } else {
        pauseGame();
      }

      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}

class Tiki extends PositionComponent with TapCallbacks {
  final int player;
  int index;
  final Function(Tiki) onTap;

  static const double sizeValue = 60;

  Tiki({required this.player, required this.index, required this.onTap})
    : super(size: Vector2.all(sizeValue));

  @override
  void render(Canvas canvas) {
    final colors = [Colors.red, Colors.blue];
    final paint = Paint()..color = colors[player];

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(12),
      ),
      paint,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap(this);
  }
}

class ActionButton extends PositionComponent with TapCallbacks {
  final String text;
  final VoidCallback onPressed;

  ActionButton(this.text, Vector2 pos, this.onPressed)
    : super(position: pos, size: Vector2(120, 60));

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.black;
    canvas.drawRect(size.toRect(), paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.x / 2 - textPainter.width / 2,
        size.y / 2 - textPainter.height / 2,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed();
  }
}
