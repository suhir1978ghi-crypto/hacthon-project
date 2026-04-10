import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../TikiGameScreen.dart';
import 'Components/PlayerCount.dart';
import 'Components/PositionManager.dart';
import 'Components/ScoreManager.dart';
import 'Components/TikiStackManager.dart';
import 'Controllers/ActionManager.dart';
import 'Controllers/RoundManager.dart';
import 'Controllers/TurnManager.dart';
import 'Widgets/ActionButton.dart';
import 'Widgets/PlayerPiece.dart';

class GameWorld extends Component with HasGameReference<TikiGameScreen> {
  final SpriteComponent background;
  final PlayerCount playerCount;

  late final PositionManager positionManager;
  late final ScoreManager scoreManager;
  late final TikiStackManager stackManager;

  late final TurnManager turnManager;
  late final ActionManager actionManager;
  late final RoundManager roundManager;

  ActionType selectedAction = ActionType.up1;

  final List<PlayerPiece> pieces = [];
  final List<int> tileIndices = [];

  bool isRoundWaiting = false;

  GameWorld(this.background, {required this.playerCount});

  @override
  Future<void> onLoad() async {
    final players = playerCount.value;

    // Managers
    positionManager = PositionManager(background);
    scoreManager = ScoreManager(players);
    turnManager = TurnManager(players);
    actionManager = ActionManager(players);
    roundManager = RoundManager(players);

    // HUD
    game.overlays.add('hud');
    game.overlays.add('targetCard');
    // Players
    tileIndices.addAll(List.generate(players, (_) => 0));

    for (int i = 0; i < players; i++) {
      final piece = PlayerPiece(playerId: i, index: i, onTap: (_) {});
      pieces.add(piece);
      add(piece);

      positionManager.moveToTile(piece, 0, pieces, tileIndices);
    }

    // Stack
    stackManager = TikiStackManager(
      game: game,
      parent: this,
      onTap: _onTikiTap,
    );

    stackManager.initLayout(background);
    await stackManager.initStack();

    // UI overlay
    game.overlays.add('actionBar');

    _updateUI();
  }

  // ================= ACTION =================

  void selectAction(ActionType action) {
    final player = turnManager.currentPlayer;

    if (!actionManager.isAvailable(player, action)) return;

    selectedAction = action;

    _updateUI();
  }
  // ================= GAMEPLAY =================

  Future<void> _onTikiTap(int index) async {
    if (isRoundWaiting) return;

    final player = turnManager.currentPlayer;

    if (!actionManager.canPlay(player) ||
        !actionManager.isAvailable(player, selectedAction)) {
      debugPrint("Invalid move");
      return;
    }

    // 🔥 perform ONCE
    stackManager.performAction(selectedAction, index);

    final removedCompletely = actionManager.useCard(player, selectedAction);

    if (stackManager.isRoundOver() || actionManager.allPlayersFinished()) {
      _endRound();
      return;
    }

    if (removedCompletely) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    turnManager.nextTurn();
    _updateUI();
  }
  // ================= ROUND =================

  Future<void> _endRound() async {
    final players = playerCount.value;

    for (int i = 0; i < players; i++) {
      final gained = scoreManager.calculateScore(i, stackManager.tikiStack);

      scoreManager.addScore(i, gained);
      _movePlayerForward(i, gained);
    }

    isRoundWaiting = true;
    game.overlays.add('roundResult');

    _updateUI();
  }

  Future<void> continueAfterRound() async {
    isRoundWaiting = false;
    game.overlays.remove('roundResult');

    if (!roundManager.nextRound()) {
      _endGame();
      return;
    }

    await stackManager.reset();
    scoreManager.resetTargets();
    actionManager.reset();
    turnManager.reset();

    _updateUI();
  }

  // ================= UI =================

  void _updateUI() {
    final player = turnManager.currentPlayer;

    _updateActivePiece();
    _highlightValidTikis();

    // 🔥 FORCE OVERLAY REFRESH
    game.overlays.remove('actionBar');
    game.overlays.add('actionBar');
  }

  void _highlightValidTikis() {
    for (final tiki in stackManager.tikiStack) {
      // remove previous highlight
      tiki.children.whereType<ScaleEffect>().forEach(
        (e) => e.removeFromParent(),
      );

      if (isRoundWaiting) continue;

      // simple highlight (safe)
      tiki.add(
        ScaleEffect.to(
          Vector2.all(1.1),
          EffectController(duration: 0.4, alternate: true, infinite: true),
        ),
      );
    }
  }

  void _updateActivePiece() {
    final current = turnManager.currentPlayer;

    for (int i = 0; i < pieces.length; i++) {
      final piece = pieces[i];

      piece.children.whereType<ScaleEffect>().forEach(
        (e) => e.removeFromParent(),
      );

      if (i == current) {
        piece.add(
          ScaleEffect.to(
            Vector2.all(1.3),
            EffectController(duration: 0.25, curve: Curves.easeOutBack),
          ),
        );

        piece.priority = 200;
      } else {
        piece.add(
          ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.2)),
        );

        piece.priority = 100;
      }
    }
  }

  // ================= GAME END =================

  void _endGame() {
    final winner = scoreManager.scores.indexOf(
      scoreManager.scores.reduce((a, b) => a > b ? a : b),
    );

    add(
      TextComponent(
        text: "🏆 Winner: P${winner + 1}",
        position: game.size / 2,
        anchor: Anchor.center,
        priority: 200,
      ),
    );

    game.overlays.remove('actionBar');
  }

  // ================= MOVEMENT =================

  void _movePlayerForward(int player, int steps) {
    tileIndices[player] += steps;

    if (tileIndices[player] >= positionManager.tiles.length) {
      tileIndices[player] %= positionManager.tiles.length;
    }

    positionManager.moveToTile(
      pieces[player],
      tileIndices[player],
      pieces,
      tileIndices,
    );
  }

  // ================= RESIZE =================

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    for (int i = 0; i < pieces.length; i++) {
      positionManager.setToTile(pieces[i], tileIndices[i], pieces, tileIndices);
    }

    Future.microtask(() => stackManager.layout());
  }
}
