import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'Components/AudioManager.dart';
import 'Screen/HomeScreen.dart';
import 'Screen/TikiGameScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioManager().init();
  runApp(
    GameWidget(
      game: TikiGame(),
      overlayBuilderMap: {
        'home': (context, game) => HomeScreen(game: game as TikiGame),
      },
      initialActiveOverlays: const ['home'],
    ),
  );
}
