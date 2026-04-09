import 'package:flame/components.dart';

import '../TikiGameScreen.dart';
import 'Components/PlayerCount.dart';
import 'Components/PositionManager.dart';
import 'Components/ScoreManager.dart';
import 'Components/TikiStackManager.dart';
import 'Controllers/ActionManager.dart';
import 'Controllers/RoundManager.dart';
import 'Controllers/TurnManager.dart';
import 'Widgets/ActionButton.dart';
import 'Widgets/ButtonController.dart';
import 'Widgets/GameHUD.dart';
import 'Widgets/HUDController.dart';
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
  late final ButtonController buttonController;
  late final HUDController hudController;

  late final GameHUD hud;

  ActionType selectedAction = ActionType.up1;

  final List<PlayerPiece> pieces = [];
  final List<int> tileIndices = [];

  GameWorld(this.background, {required this.playerCount});

  @override
  Future<void> onLoad() async {
    final players = playerCount.value;

    positionManager = PositionManager(background);
    scoreManager = ScoreManager(players);

    turnManager = TurnManager(players);
    actionManager = ActionManager(players);
    roundManager = RoundManager(players);

    hud = GameHUD();
    hudController = HUDController(hud);
    add(hud);

    buttonController = ButtonController(game);

    tileIndices.addAll(List.generate(players, (_) => 0));

    for (int i = 0; i < players; i++) {
      final piece = PlayerPiece(playerId: i, index: i, onTap: (_) {});
      pieces.add(piece);
      add(piece);
      positionManager.moveToTile(piece, 0);
    }

    stackManager = TikiStackManager(
      game: game,
      parent: this,
      onTap: _onTikiTap,
    );

    stackManager.initLayout(background);
    await stackManager.initStack();

    buttonController.createButtons(this, _onActionSelected);

    _updateUI();
  }

  void _onActionSelected(ActionType action) {
    if (!actionManager.isAvailable(turnManager.currentPlayer, action)) return;

    selectedAction = action;
    _updateUI();
  }

  void _onTikiTap(int index) {
    final player = turnManager.currentPlayer;

    if (!actionManager.canPlay(player)) return;
    if (!actionManager.isAvailable(player, selectedAction)) return;

    stackManager.performAction(selectedAction, index);

    actionManager.markUsed(player, selectedAction);

    if (stackManager.isRoundOver() || actionManager.allPlayersFinished()) {
      _endRound();
      return;
    }

    turnManager.nextTurn();
    _updateUI();
  }

  Future<void> _endRound() async {
    final players = playerCount.value;

    for (int i = 0; i < players; i++) {
      final gained = scoreManager.calculateScore(i, stackManager.tikiStack);
      scoreManager.addScore(i, gained);
      _movePlayerForward(i, gained);
    }

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

  void _updateUI() {
    final player = turnManager.currentPlayer;

    buttonController.updateState(
      actionManager.usedActions[player],
      selectedAction,
    );

    hudController.update(
      player: player,
      scores: scoreManager.scores,
      action: selectedAction.name,
    );
  }

  void _endGame() {
    final winner = scoreManager.scores.indexOf(
      scoreManager.scores.reduce((a, b) => a > b ? a : b),
    );

    add(
      TextComponent(
        text: "Winner: P${winner + 1}",
        position: game.size / 2,
        anchor: Anchor.center,
        priority: 200,
      ),
    );
  }

  void _movePlayerForward(int player, int steps) {
    tileIndices[player] += steps;

    if (tileIndices[player] >= positionManager.tiles.length) {
      tileIndices[player] %= positionManager.tiles.length;
    }

    positionManager.moveToTile(pieces[player], tileIndices[player]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    for (int i = 0; i < pieces.length; i++) {
      positionManager.setToTile(pieces[i], tileIndices[i]);
    }

    buttonController.updateLayout();

    Future.microtask(() => stackManager.layout());
  }
}
