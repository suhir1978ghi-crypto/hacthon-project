import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';

import '../Widgets/ActionButton.dart';
import '../Widgets/Tiki.dart';
import 'TikiPositionManager.dart';

class TikiStackManager {
  final FlameGame game;
  final Component parent;
  final Function(int) onTap;

  final List<Tiki> tikiStack = [];

  late TikiPositionManager layoutHelper;

  TikiStackManager({
    required this.game,
    required this.parent,
    required this.onTap,
  });

  void initLayout(SpriteComponent bg) {
    layoutHelper = TikiPositionManager(bg);
  }

  Future<void> initStack() async {
    tikiStack.clear();

    for (int i = 0; i < 9; i++) {
      final tiki = Tiki(id: i, onTap: () {})..size = Vector2.all(50);

      tiki.onTap = () {
        final index = tikiStack.indexOf(tiki);
        if (index != -1) {
          onTap(index);
        }
      };

      tikiStack.add(tiki);
      parent.add(tiki);
    }

    layout(animated: false);
  }

  void layout({bool animated = true}) {
    for (int i = 0; i < tikiStack.length; i++) {
      final tiki = tikiStack[i];
      final target = layoutHelper.getPosition(i) - tiki.size / 2;

      if (!animated) {
        tiki.position = target;
        continue;
      }

      final effects = tiki.children.whereType<MoveEffect>().toList();
      for (final e in effects) {
        e.removeFromParent();
      }

      tiki.add(
        MoveEffect.to(
          target,
          EffectController(duration: 0.35, curve: Curves.easeOutBack),
        ),
      );
    }
  }

  void performAction(ActionType action, int index) {
    if (index < 0 || index >= tikiStack.length) return;

    switch (action) {
      case ActionType.up1:
        _move(index, 1);
        break;
      case ActionType.up2:
        _move(index, 2);
        break;
      case ActionType.up3:
        _move(index, 3);
        break;
      case ActionType.topple:
        _topple(index);
        break;
      case ActionType.toast:
        _toast();
        break;
    }

    layout();
  }

  void _move(int index, int steps) {
    if (index <= 0) return;

    final newIndex = (index - steps).clamp(0, tikiStack.length - 1);
    final tiki = tikiStack.removeAt(index);
    tikiStack.insert(newIndex, tiki);
  }

  void _topple(int index) {
    final tiki = tikiStack.removeAt(index);
    tikiStack.add(tiki);
  }

  void _toast() {
    if (tikiStack.isEmpty) return;
    final tiki = tikiStack.removeLast();
    tiki.removeFromParent();
  }

  bool isRoundOver() => tikiStack.length <= 3;

  Future<void> reset() async {
    for (final t in tikiStack) {
      t.removeFromParent();
    }
    await initStack();
  }
}
