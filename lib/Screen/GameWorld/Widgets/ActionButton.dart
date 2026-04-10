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
              color: Colors.black..withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: ActionType.values.map((action) {
                final count = hand.where((a) => a == action).length;

                final disabled = count == 0;
                final isSelected = selected == action;

                return _ActionButton(
                  action: action,
                  count: count,
                  disabled: disabled,
                  isSelected: isSelected,
                  onTap: () => _select(action),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final ActionType action;
  final int count;
  final bool disabled;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActionButton({
    required this.action,
    required this.count,
    required this.disabled,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: MouseRegion(
        onEnter: (_) => setState(() => hovering = true),
        onExit: (_) => setState(() => hovering = false),
        child: GestureDetector(
          onTap: widget.disabled ? null : widget.onTap,
          child: AnimatedScale(
            scale: hovering ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.disabled
                    ? Colors.grey.shade800
                    : widget.isSelected
                    ? Colors.orange
                    : Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isSelected
                      ? Colors.orangeAccent
                      : Colors.white24,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Text(
                    widget.action.name.toUpperCase(),
                    style: TextStyle(
                      color: widget.disabled ? Colors.white38 : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),

                  Positioned(
                    right: -18,
                    top: -18,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: widget.count == 0
                          ? const SizedBox()
                          : Container(
                              key: ValueKey(widget.count),
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
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
