import 'package:flutter/material.dart';

import '../GameWorld.dart';

class ActionBarOverlay extends StatefulWidget {
  final GameWorld gameWorld;

  const ActionBarOverlay({super.key, required this.gameWorld});

  @override
  State<ActionBarOverlay> createState() => _ActionBarOverlayState();
}

class _ActionBarOverlayState extends State<ActionBarOverlay> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = ActionType.values.indexOf(widget.gameWorld.selectedAction);
  }

  void _select(ActionType action) {
    widget.gameWorld.selectAction(action);

    setState(() {
      currentIndex = ActionType.values.indexOf(action);
    });
  }

  String getAsset(ActionType action) {
    switch (action) {
      case ActionType.up1:
        return 'assets/images/cards/1.png';
      case ActionType.up2:
        return 'assets/images/cards/2.png';
      case ActionType.up3:
        return 'assets/images/cards/3.png';
      case ActionType.topple:
        return 'assets/images/cards/up.png';
      case ActionType.toast:
        return 'assets/images/cards/toast.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.gameWorld.turnManager.currentPlayer;
    final hand = widget.gameWorld.actionManager.hands[player];
    final selected = widget.gameWorld.selectedAction;

    if (widget.gameWorld.isRoundWaiting) {
      return const SizedBox();
    }

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) return;

            if (details.primaryVelocity! < 0) {
              currentIndex = (currentIndex + 1) % ActionType.values.length;
            } else {
              currentIndex =
                  (currentIndex - 1 + ActionType.values.length) %
                  ActionType.values.length;
            }

            final action = ActionType.values[currentIndex];
            if (hand.contains(action)) {
              _select(action);
            }

            setState(() {});
          },

          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(18),
            ),

            // 🔥 Animated hand update
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: ActionType.values.asMap().entries.map((entry) {
                  final i = entry.key;
                  final action = entry.value;

                  final count = hand.where((a) => a == action).length;

                  return AnimatedSlide(
                    duration: Duration(milliseconds: 300 + i * 50),
                    offset: Offset(0, count > 0 ? 0 : 1),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: count > 0 ? 1 : 0,
                      child: _GameCard(
                        key: ValueKey("${player}_${action.name}"),
                        asset: getAsset(action),
                        count: count,
                        disabled: count == 0,
                        isSelected: selected == action,
                        onTap: () => _select(action),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatefulWidget {
  final String asset;
  final int count;
  final bool disabled;
  final bool isSelected;
  final VoidCallback onTap;

  const _GameCard({
    super.key,
    required this.asset,
    required this.count,
    required this.disabled,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
  bool hovering = false;
  bool removing = false;
  int? previousCount;

  @override
  void initState() {
    super.initState();
    previousCount = widget.count;
  }

  @override
  void didUpdateWidget(covariant _GameCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔥 reset if count comes back
    if (widget.count > 0) {
      removing = false;
    }

    // detect removal
    if (oldWidget.count > 0 && widget.count == 0) {
      setState(() => removing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: MouseRegion(
        onEnter: (_) => setState(() => hovering = true),
        onExit: (_) => setState(() => hovering = false),
        child: GestureDetector(
          onTap: widget.disabled ? null : widget.onTap,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeIn,
            offset: removing ? const Offset(0, 1.5) : Offset.zero,

            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: removing
                  ? 0
                  : widget.disabled
                  ? 0.4
                  : 1,

              child: AnimatedScale(
                scale: widget.isSelected
                    ? 1.2
                    : hovering
                    ? 1.1
                    : 1.0,
                duration: const Duration(milliseconds: 150),

                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 🎴 CARD IMAGE
                    Image.asset(
                      widget.asset,
                      width: 70,
                      height: 100,
                      fit: BoxFit.cover,
                    ),

                    if (widget.isSelected)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orangeAccent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                    // 🔢 COUNT BADGE
                    if (widget.count > 0)
                      Positioned(
                        right: -10,
                        top: -10,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            key: ValueKey(widget.count),
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "${widget.count}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ActionType {
  up1,
  up2,
  up3,
  topple,
  toast;

  String get name {
    switch (this) {
      case ActionType.up1:
        return "Up 1";
      case ActionType.up2:
        return "Up 2";
      case ActionType.up3:
        return "Up 3";
      case ActionType.topple:
        return "Topple";
      case ActionType.toast:
        return "Toast";
    }
  }
}
