import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../Widgets/ActionButton.dart';

class ButtonController {
  final FlameGame game;
  final List<ActionButton> buttons = [];

  ButtonController(this.game);

  void createButtons(Component parent, Function(ActionType) onSelect) {
    final actions = ActionType.values;

    for (int i = 0; i < actions.length; i++) {
      final btn = ActionButton(actions[i].name, Vector2.zero(), () {
        onSelect(actions[i]);
      });

      buttons.add(btn);
      parent.add(btn);
    }

    updateLayout();
  }

  void updateLayout() {
    for (int i = 0; i < buttons.length; i++) {
      buttons[i].position = Vector2(20 + i * 110, game.size.y - 80);
    }
  }

  void updateState(Set<ActionType> used, ActionType selected) {
    for (int i = 0; i < buttons.length; i++) {
      final action = ActionType.values[i];

      buttons[i].disabled = used.contains(action);
      buttons[i].isSelected = action == selected;
    }
  }
}
