import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'Components/AudioManager.dart';
import 'Screen/GameWorld/Widgets/ActionButton.dart';
import 'Screen/GameWorld/Widgets/RoundResults.dart';
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
        'roundResult': (context, game) {
          final g = game as TikiGameScreen;

          if (g.gameWorld == null) return const SizedBox();

          return RoundResultOverlay(gameWorld: g.gameWorld!);
        },
      },
      initialActiveOverlays: const ['home'],
    ),
  );
}
