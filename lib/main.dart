import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../Components/PositionManager.dart';
import 'Screen/HomeScreen.dart';
import 'Widgets/TikiBackground.dart';

void main() {
  runApp(
    GameWidget(
      game: TikiGame(),
      overlayBuilderMap: {
        'home': (context, game) => HomeScreen(game: game as TikiGame),
      },
      initialActiveOverlays: const ['home'],
    ),
  );
}

class TikiGame extends FlameGame with TapCallbacks {
  PositionManager? positionManager;
  late Tiki testTiki;

  int currentTile = 0;
  void startPlayerSetup() {
    overlays.remove('home');
    //overlays.add('playerSetup');
  }

  @override
  Future<void> onLoad() async {
    final bg = TikiBackground();
    await add(bg);
    await bg.loaded;

    positionManager = PositionManager(bg.background!);

    testTiki = Tiki(player: 0, index: 0, onTap: (_) {});
    add(testTiki);

    positionManager!.moveToTile(testTiki, 0);

    add(
      ActionButton("NEXT", Vector2(50, size.y - 120), () {
        currentTile++;

        if (currentTile >= positionManager!.tiles.length) {
          currentTile = 0;
        }

        positionManager?.moveToTile(testTiki, currentTile);
      }),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    positionManager?.setToTile(testTiki, currentTile);
  }
}

// ================= TIKI =================

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
