import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'Components/AudioManager.dart';
import 'Screen/GameWorld/Widgets/ActionButton.dart';
import 'Screen/GameWorld/Widgets/GameHUD.dart';
import 'Screen/GameWorld/Widgets/RoundResults.dart';
import 'Screen/GameWorld/Widgets/TargetCard.dart';
import 'Screen/HomeScreen/HomeScreen.dart';
import 'Screen/PauseScreen/PauseScreen.dart';
import 'Screen/PlayerSelectScreen/PlayerSelectScreen.dart';
import 'Screen/TikiGameScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioManager().init();
  runApp(
    GameWidget(
      game: TikiGameScreen(),
      overlayBuilderMap: {
        'home': (context, game) => HomeScreen(game: game as TikiGameScreen),
        'playerSelect': (context, game) =>
            PlayerSelectScreen(game: game as TikiGameScreen),
        'pause': (context, game) => PauseScreen(game: game as TikiGameScreen),
        'actionBar': (context, game) {
          final g = game as TikiGameScreen;

          if (g.gameWorld == null) {
            return const SizedBox();
          }

          return ActionBarOverlay(gameWorld: g.gameWorld!);
        },
        'hud': (context, game) {
          final g = game as TikiGameScreen;
          if (g.gameWorld == null) return const SizedBox();
          return GameHUDOverlay(gameWorld: g.gameWorld!);
        },
        'roundResult': (context, game) {
          final g = game as TikiGameScreen;

          if (g.gameWorld == null) return const SizedBox();

          return RoundResultOverlay(gameWorld: g.gameWorld!);
        },
        'targetCard': (context, game) {
          final g = game as TikiGameScreen;
          if (g.gameWorld == null) return const SizedBox();

          final gw = g.gameWorld!;

          return Stack(
            children: [
              Positioned(
                top: 82,
                right: 20,
                child: TargetCard(
                  targets: gw.scoreManager.getPlayerTargets(
                    gw.turnManager.currentPlayer,
                  ),
                ),
              ),
            ],
          );
        },
      },
      initialActiveOverlays: const ['home'],
    ),
  );
}
