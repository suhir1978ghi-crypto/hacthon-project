import 'package:flame/components.dart';

class TikiPositionManager {
  final SpriteComponent background;

  TikiPositionManager(this.background);

  final positions = [
    Vector2(0.51, 0.2268),
    Vector2(0.51, 0.3074),
    Vector2(0.51, 0.4019),
    Vector2(0.51, 0.4930),
    Vector2(0.51, 0.5801),
    Vector2(0.51, 0.6637),
    Vector2(0.51, 0.7522),
    Vector2(0.51, 0.8415),
    Vector2(0.51, 0.9352),
  ];
  Vector2 getPosition(int index) {
    final p = positions[index];
    final bgPos = background.absolutePosition;

    return Vector2(
      bgPos.x + background.size.x * p.x,
      bgPos.y + background.size.y * p.y,
    );
  }
}
