import '../Widgets/GameHUD.dart';

class HUDController {
  final GameHUD hud;

  HUDController(this.hud);

  void update({required int player, required List<int> scores}) {
    hud.updateHUD(player: player, scoreList: scores);
  }
}
