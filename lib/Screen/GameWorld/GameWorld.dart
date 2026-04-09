import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../TikiGameScreen.dart';
import 'Components/PlayerCount.dart';
import 'Components/PositionManager.dart';
import 'Widgets/PlayerPiece.dart';

class GameWorld extends Component with HasGameReference<TikiGameScreen> {
  final SpriteComponent background;
  final PlayerCount playerCount;
  PositionManager? positionManager;

  final List<PlayerPiece> pieces = [];
  final List<int> tileIndices = [];

  GameWorld(this.background, {required this.playerCount});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    positionManager = PositionManager(background);

    tileIndices.addAll(List.generate(playerCount.value, (_) => 0));

    for (int i = 0; i < playerCount.value; i++) {
      final piece = PlayerPiece(playerId: i, index: i, onTap: (_) {});

      pieces.add(piece);
      add(piece);

      positionManager!.moveToTile(piece, 0);
    }

    for (int i = 0; i < playerCount.value; i++) {
      add(
        ActionButton(
          "P${i + 1}",
          Vector2(50 + (i * 120), game.size.y - 120),
          () => _movePlayer(i),
        ),
      );
    }
  }

  void _movePlayer(int i) {
    tileIndices[i]++;

    if (tileIndices[i] >= positionManager!.tiles.length) {
      tileIndices[i] = 0;
    }

    positionManager!.moveToTile(pieces[i], tileIndices[i]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    const baseHeight = 800.0;
    double scaleFactor = (size.y / baseHeight).clamp(0.6, 1.0);

    for (int i = 0; i < pieces.length; i++) {
      pieces[i].scale = Vector2.all(scaleFactor);
      positionManager?.setToTile(pieces[i], tileIndices[i]);
    }
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
