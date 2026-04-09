import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../Screen/TikiGameScreen.dart';

class PositionManager {
  final SpriteComponent background;

  PositionManager(this.background);

  final List<Vector2> tiles = [
    Vector2(0.1488, 0.8643),
    Vector2(0.2468, 0.8126),
    Vector2(0.1404, 0.7715),
    Vector2(0.1539, 0.7172),
    Vector2(0.1184, 0.6401),
    Vector2(0.1691, 0.5823),
    Vector2(0.1218, 0.5245),
    Vector2(0.1353, 0.4737),
    Vector2(0.0948, 0.4212),
    Vector2(0.1370, 0.3485),
    Vector2(0.1066, 0.3082),
    Vector2(0.0948, 0.2417),
    Vector2(0.1201, 0.1848),
    Vector2(0.0965, 0.1226),
    Vector2(0.0999, 0.0350),
    Vector2(0.2535, 0.0718),
    Vector2(0.3244, 0.0342),
    Vector2(0.6857, 0.0368),
    Vector2(0.7617, 0.0683),
    Vector2(0.8765, 0.0350),
    Vector2(0.9001, 0.1165),
    Vector2(0.8157, 0.1778),
    Vector2(0.9119, 0.2259),
    Vector2(0.8596, 0.2925),
    Vector2(0.9221, 0.3511),
    Vector2(0.8849, 0.4098),
    Vector2(0.8377, 0.4694),
    Vector2(0.8697, 0.5254),
    Vector2(0.9086, 0.5919),
    Vector2(0.8292, 0.6305),
    Vector2(0.8680, 0.6996),
    Vector2(0.8461, 0.7452),
    Vector2(0.8242, 0.8144),
    Vector2(0.8444, 0.8765),
    Vector2(0.8410, 0.9431),
  ];

  Vector2 getTilePosition(int index) {
    final tile = tiles[index];

    return Vector2(
      background.position.x + tile.x * background.size.x,
      background.position.y + tile.y * background.size.y,
    );
  }

  void setToTile(Tiki tiki, int tileIndex) {
    final pos = getTilePosition(tileIndex);

    tiki.children.whereType<MoveEffect>().toList().forEach(
      (e) => e.removeFromParent(),
    );

    tiki.position = Vector2(pos.x - tiki.size.x / 2, pos.y - tiki.size.y / 2);
  }

  void moveToTile(Tiki tiki, int tileIndex) {
    final pos = getTilePosition(tileIndex);

    tiki.add(
      MoveEffect.to(
        Vector2(pos.x - tiki.size.x / 2, pos.y - tiki.size.y / 2),
        EffectController(duration: 0.3, curve: Curves.easeOut),
      ),
    );
  }
}
