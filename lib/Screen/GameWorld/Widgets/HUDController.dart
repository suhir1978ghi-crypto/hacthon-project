import '../Widgets/GameHUD.dart';

class HUDController {
  final GameHUD hud;

  HUDController(this.hud);

  void update({
    required int player,
    required List<int> scores,
    required String action,
  }) {
    hud.updateHUD(player: player, scoreList: scores, selectedAction: action);
  }
}
