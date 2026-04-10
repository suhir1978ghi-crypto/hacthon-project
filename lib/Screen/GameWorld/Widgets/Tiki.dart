import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

enum TikiSymbol { sun, moon, leaf }

class Tiki extends SpriteComponent with TapCallbacks {
  final int index;
  final TikiSymbol symbol;
  final String asset;
  final VoidCallback onTap;

  Tiki({
    required this.index,
    required this.symbol,
    required this.asset,
    required this.onTap,
  }) : super(size: Vector2.all(80), anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(asset); // ✅ safe
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
