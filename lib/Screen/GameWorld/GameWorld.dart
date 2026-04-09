import 'package:flame/components.dart';

import '../../Components/PositionManager.dart';
import '../TikiGameScreen.dart';

class GameWorld extends Component with HasGameRef<TikiGameScreen> {
  final PositionManager positionManager;

  late Tiki testTiki;
  int currentTile = 0;

  GameWorld(this.positionManager);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    testTiki = Tiki(player: 0, index: 0, onTap: (_) {});
    add(testTiki);

    positionManager.moveToTile(testTiki, 0);

    add(
      ActionButton(
        "NEXT",
        Vector2(50, gameRef.size.y - 120), // ✅ FIXED
        () {
          currentTile++;

          if (currentTile >= positionManager.tiles.length) {
            currentTile = 0;
          }

          positionManager.moveToTile(testTiki, currentTile);
        },
      ),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    positionManager.setToTile(testTiki, currentTile);
  }
}
