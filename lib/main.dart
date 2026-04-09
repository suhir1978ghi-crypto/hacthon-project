import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'Components/AudioManager.dart';
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
      },
      initialActiveOverlays: const ['home'],
    ),
  );
}
