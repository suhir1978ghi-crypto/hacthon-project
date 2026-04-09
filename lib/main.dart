import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'Widgets/TikiBackground.dart';

void main() {
  runApp(GameWidget(game: TikiGame()));
}

enum ActionType { up1, up2, topple, toast }

class TikiGame extends FlameGame with TapCallbacks {
  SpriteComponent? background;
  late Sprite backgroundSprite;
  SpriteComponent? bgFull;
  List<ActionButton> buttons = [];
  final List<Tiki> stack = [];
  ActionType? selectedAction;

  int currentPlayer = 0;

  @override
  Future<void> onLoad() async {
    await add(TikiBackground());

    updateStackPositions();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    updateStackPositions();

    if (buttons.isNotEmpty) {
      _updateButtons();
    }
  }

  List<Component> createButtons() {
    buttons = [
      ActionButton("UP 1", Vector2.zero(), ActionType.up1, onAction),
      ActionButton("UP 2", Vector2.zero(), ActionType.up2, onAction),
      ActionButton("TOPPLE", Vector2.zero(), ActionType.topple, onAction),
      ActionButton("TOAST", Vector2.zero(), ActionType.toast, onAction),
    ];

    _updateButtons();

    return buttons;
  }

  void _updateButtons() {
    final y = size.y - 120;

    buttons[0].position = Vector2(50, y);
    buttons[1].position = Vector2(200, y);
    buttons[2].position = Vector2(350, y);
    buttons[3].position = Vector2(550, y);
  }

  void onAction(ActionType action) {
    selectedAction = action;
  }

  void onTikiTap(Tiki tiki) {
    if (selectedAction == null) return;
    if (tiki.player != currentPlayer) return;

    switch (selectedAction!) {
      case ActionType.up1:
        moveUp(tiki, 1);
        break;
      case ActionType.up2:
        moveUp(tiki, 2);
        break;
      case ActionType.topple:
        topple(tiki);
        break;
      case ActionType.toast:
        toast();
        break;
    }

    selectedAction = null;
    currentPlayer = (currentPlayer + 1) % 2;
  }

  void moveUp(Tiki tiki, int steps) {
    int index = stack.indexOf(tiki);
    int newIndex = index - steps;

    if (newIndex < 0) newIndex = 0;
    if (newIndex == index) return;

    stack.removeAt(index);
    stack.insert(newIndex, tiki);

    updateStackPositions();
  }

  void topple(Tiki tiki) {
    final index = stack.indexOf(tiki);
    if (index == stack.length - 1) return;

    stack.removeAt(index);
    stack.add(tiki);

    updateStackPositions();
  }

  void toast() {
    if (stack.isEmpty) return;

    final removed = stack.removeLast();
    removed.removeFromParent();

    updateStackPositions();
  }

  void updateStackPositions() {
    final centerX = size.x / 2;

    for (int i = 0; i < stack.length; i++) {
      final tiki = stack[i];
      tiki.index = i;
      tiki.updatePosition(centerX);
    }
  }
}

class Tiki extends PositionComponent with TapCallbacks {
  final int player;
  int index;
  final Function(Tiki) onTap;

  static const double sizeValue = 70;

  Tiki({required this.player, required this.index, required this.onTap})
    : super(size: Vector2.all(sizeValue));

  void updatePosition(double centerX) {
    position = Vector2(centerX - size.x / 2, 250 + index * 80);
  }

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

// ================= BUTTON =================

class ActionButton extends PositionComponent with TapCallbacks {
  final String text;
  final ActionType action;
  final Function(ActionType) onPressed;

  ActionButton(this.text, Vector2 pos, this.action, this.onPressed)
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
    onPressed(action);
  }
}
