import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Widgets/TikiBackground.dart';
import 'GameWorld/Components/PlayerCount.dart';
import 'GameWorld/GameWorld.dart';

class TikiGameScreen extends FlameGame with KeyboardEvents {
  TikiBackground? bg;
  GameWorld? gameWorld;

  bool started = false;

  @override
  Future<void> onLoad() async {
    bg = TikiBackground();
    await add(bg!);
    await bg!.loaded;
  }

  Future<void> startGame({PlayerCount players = PlayerCount.two}) async {
    if (started) return;

    started = true;

    gameWorld = GameWorld(bg!.background!, playerCount: players);

    await add(gameWorld!);
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
